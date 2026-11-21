import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '../backend_integration/apis/cart_api.dart';
import '../backend_integration/apis/orders_api.dart';
import '../backend_integration/dtos/cart/cart_dto.dart';
import '../utils/number_localization.dart';
import 'address_service.dart';

/// Why a promo code was not applied: the backend's own reason when it gave
/// one, or that the shopper has no delivery address to price it against.
sealed class PromoRejection {
  const PromoRejection();
}

class PromoRejectedByBackend extends PromoRejection {
  final String? message;
  const PromoRejectedByBackend(this.message);
}

class PromoNeedsAddress extends PromoRejection {
  const PromoNeedsAddress();
}

class CartService extends ChangeNotifier {
  final CartApi _cartApi;

  List<CartItemDto> _items = [];
  // The subtotal the backend priced, null until the first load.
  double? _serverSubtotal;
  // The cart after deals as the backend priced it, null until loaded.
  double? _serverTotal;
  double _dealDiscount = 0.0;
  double _singleItemDiscount = 0.0;
  List<AppliedDealDto> _appliedDeals = [];
  SpendDealDto? _spendDeal;
  String? _promoCode;
  double _promoDiscount = 0.0;
  // The order as the coupon preview priced it, when the backend sent it.
  double? _promoDeliveryFee;
  double? _promoTotal;
  double? _deliveryFee;
  double? _feePricedTotal;
  bool _loadingDeliveryFee = false;

  CartService(this._cartApi);

  // --- Public data ----------------------------------------------------------

  List<CartLineItem> get displayItems =>
      _items.map(CartLineItem.fromServer).toList();

  bool get isEmpty => _items.isEmpty;
  int get itemCount => _items.fold(0, (s, i) => s + i.quantity);
  /// The cart before any deal, fixed price deals included. The backend's
  /// figure once loaded, the lines at their normal prices until then.
  double get subtotal =>
      _serverSubtotal ??
      _items.fold(
        0.0,
        (s, i) => s + (i.unitPriceBeforeDeal ?? i.unitPrice) * i.quantity,
      );
  /// What the backend charges to deliver the current cart to the selected
  /// address. Null until the first fetch lands, which is why the summaries
  /// show a placeholder rather than a number while it is loading.
  double? get deliveryFee => hasPromo && _promoDeliveryFee != null
      ? _promoDeliveryFee
      : _deliveryFee;
  bool get isLoadingDeliveryFee => _loadingDeliveryFee;
  double get shippingCost => isEmpty ? 0.0 : (deliveryFee ?? 0.0);

  /// The cart after bundle, multi-buy, free gift and spend deals, before
  /// delivery and any coupon. The backend's figure once loaded. Delivery is
  /// priced on this, since free delivery is decided after deals.
  double get totalAfterDeals {
    final server = _serverTotal;
    if (server != null) return server;
    final raw = subtotal - dealDiscount;
    return raw < 0 ? 0 : raw;
  }
  String? get promoCode => _promoCode;
  bool get hasPromo => _promoCode != null;

  /// The discount the backend quoted for [promoCode] on this cart and address.
  double get promoDiscount => _promoCode == null ? 0.0 : _promoDiscount;

  /// What the shopper pays. With a coupon, the total the coupon preview
  /// priced when the backend sent one, otherwise worked out from the parts.
  double get total {
    final promoTotal = _promoTotal;
    if (hasPromo && promoTotal != null) return promoTotal;
    final raw = totalAfterDeals + shippingCost - promoDiscount;
    return raw < 0 ? 0 : raw;
  }

  /// Ask the backend what delivery costs for the selected address and the
  /// cart after deals. The fee moves with that amount because delivery is
  /// free above a threshold, so this reruns whenever the cart changes and
  /// no-ops when the amount it last priced is still current.
  ///
  /// Pass [force] to price again even when the amount has not moved. A pull
  /// to refresh has to reach the network, and the fee can change under a
  /// steady amount when the selected address or the threshold changes.
  Future<void> refreshDeliveryFee({bool force = false}) async {
    if (isEmpty) {
      if (_feePricedTotal == 0.0 && _deliveryFee == 0.0) return;
      _deliveryFee = 0.0;
      _feePricedTotal = 0.0;
      _loadingDeliveryFee = false;
      notifyListeners();
      return;
    }

    if (!force && _feePricedTotal == totalAfterDeals) return;

    final addressService = GetIt.instance<AddressService>();
    if (addressService.addresses.isEmpty) {
      await addressService.loadFromServer();
    }
    final addressId = addressService.selectedId;
    if (addressId == null) return;

    final pricedTotal = totalAfterDeals;
    _feePricedTotal = pricedTotal;
    _loadingDeliveryFee = true;
    notifyListeners();

    final result = await GetIt.instance<OrdersApi>()
        .getDeliveryFee(addressId: addressId, cartTotal: pricedTotal);

    _loadingDeliveryFee = false;
    result.fold(
      // A failed lookup must not stick, or the cart never prices again.
      (_) => _feePricedTotal = null,
      (fee) => _deliveryFee = fee,
    );
    notifyListeners();
    // A coupon's value can move with the cart and the delivery fee.
    await _repricePromo();
  }

  bool isInCart(int itemSizeId) =>
      _items.any((i) => i.itemSizeId == itemSizeId);

  /// Units of [itemId] in the cart, across every color and size.
  int quantityOfItem(int itemId) => _items
      .where((i) => i.itemId == itemId)
      .fold(0, (s, i) => s + i.quantity);

  /// Whether the cart applies the deal [dealId], by its applied deals or by a
  /// line priced by it.
  bool isDealApplied(int dealId) =>
      _appliedDeals.any((d) => d.dealId == dealId) ||
      _items.any((i) => i.appliedDealId == dealId);

  /// Whether a line of [itemId] is priced by a deal other than [dealId].
  bool isItemTakenByOtherDeal(int itemId, int dealId) => _items.any(
    (i) =>
        i.itemId == itemId &&
        i.appliedDealId != null &&
        i.appliedDealId != dealId,
  );

  /// Everything deals take off the cart, fixed price deals included.
  double get dealDiscount => _dealDiscount;

  /// The part of [dealDiscount] fixed price deals save.
  double get singleItemDiscount => _singleItemDiscount;

  /// One summary row per saving, adding up to [dealDiscount]: fixed price
  /// deals as one row, then each other applied deal. Fixed price entries in
  /// the applied deals are left out so they are not counted twice.
  List<({String title, double saving})> get dealSavingRows => [
    if (_singleItemDiscount > 0)
      (
        title: 'cart_summary.deal_price_savings'.tr(),
        saving: _singleItemDiscount,
      ),
    for (final deal in _appliedDeals)
      if (deal.type != 1 && deal.saving > 0)
        (title: deal.title, saving: deal.saving),
  ];
  List<AppliedDealDto> get appliedDeals => _appliedDeals;

  /// The best live spend deal and the cart's progress to it, or null when
  /// none is live.
  SpendDealDto? get spendDeal => _spendDeal;

  /// "Add $X more to get Y% off" while a live spend deal is not reached yet,
  /// from the backend's remaining amount; null otherwise.
  String? get spendDealHint {
    final deal = _spendDeal;
    if (deal == null || deal.unlocked || deal.remaining <= 0 || isEmpty) {
      return null;
    }
    return 'cart_summary.spend_hint'.tr(
      namedArgs: {
        'amount': '\$${localizedPrice(deal.remaining)}',
        'percent': localizedNumber(deal.discountPercent.round()),
      },
    );
  }

  // --- Server sync ----------------------------------------------------------

  Future<void> loadFromServer() async {
    final result = await _cartApi.getCart();
    result.fold((_) {}, (dto) {
      _items = dto.items;
      _serverSubtotal = dto.subtotal;
      _serverTotal = dto.total;
      _dealDiscount = dto.dealDiscount;
      _singleItemDiscount = dto.singleItemDiscount;
      _appliedDeals = dto.appliedDeals;
      _spendDeal = dto.spendDeal;
      notifyListeners();
    });
  }

  /// Forgets the cart held for the previous identity, before the next one's
  /// cart is fetched.
  void reset() {
    _items = [];
    _serverSubtotal = null;
    _serverTotal = null;
    _promoDeliveryFee = null;
    _promoTotal = null;
    _dealDiscount = 0.0;
    _singleItemDiscount = 0.0;
    _appliedDeals = [];
    _spendDeal = null;
    _promoCode = null;
    _promoDiscount = 0.0;
    _deliveryFee = null;
    _feePricedTotal = null;
    _loadingDeliveryFee = false;
    notifyListeners();
  }

  // --- Mutations ------------------------------------------------------------

  Future<String?> addToCart({
    required int? itemSizeId,
    required int itemId,
    required String itemTitle,
    String? mainImageUrl,
    required String colorName,
    required String sizeName,
    required double unitPrice,
    int quantity = 1,
  }) async {
    final result = await _cartApi.addToCart(itemSizeId, quantity);
    return result.fold((_) => null, (message) async {
      await loadFromServer();
      return message.isNotEmpty ? message : null;
    });
  }

  Future<String?> removeItem(String id) async {
    final cartItemId = int.tryParse(id);
    if (cartItemId == null) return null;
    final result = await _cartApi.removeItem(cartItemId);
    await loadFromServer();
    return result.fold((_) => null, (m) => m.isNotEmpty ? m : null);
  }

  Future<void> updateQuantity(String id, int newQty) async {
    final cartItemId = int.tryParse(id);
    if (cartItemId == null) return;
    if (newQty <= 0) {
      await removeItem(id);
    } else {
      await _cartApi.updateQuantity(cartItemId, newQty);
      await loadFromServer();
    }
  }

  Future<void> clearCart() async {
    await _cartApi.clearCart();
    _items = [];
    _serverSubtotal = 0.0;
    _serverTotal = 0.0;
    _promoDeliveryFee = null;
    _promoTotal = null;
    _dealDiscount = 0.0;
    _singleItemDiscount = 0.0;
    _appliedDeals = [];
    // The spend deal is still live, an empty cart just starts from nothing.
    final spend = _spendDeal;
    _spendDeal = spend?.copyWith(
      eligibleSubtotal: 0.0,
      remaining: spend.spendThreshold,
      unlocked: false,
    );
    _promoCode = null;
    _promoDiscount = 0.0;
    notifyListeners();
  }

  /// Asks the backend what [code] is worth on this cart for the selected
  /// address. Returns null once applied, or why it was not.
  Future<PromoRejection?> applyPromo(String code) async {
    final normalized = code.trim().toUpperCase();
    final addressId = GetIt.instance<AddressService>().selectedId;
    if (addressId == null) return const PromoNeedsAddress();

    final result = await GetIt.instance<OrdersApi>()
        .getCouponPreview(couponCode: normalized, addressId: addressId);
    return result.fold(
      (failure) => PromoRejectedByBackend(failure.message),
      (preview) {
        if (!preview.isApplicable) return PromoRejectedByBackend(preview.reason);
        _promoCode = normalized;
        _promoDiscount = preview.discountAmount;
        _promoDeliveryFee = preview.deliveryFee;
        _promoTotal = preview.total;
        notifyListeners();
        return null;
      },
    );
  }

  void removePromo() {
    _promoCode = null;
    _promoDiscount = 0.0;
    _promoDeliveryFee = null;
    _promoTotal = null;
    notifyListeners();
  }

  /// Prices the applied code again after the cart or address changed, and
  /// drops it when it no longer applies, so the totals never show a discount
  /// the backend would refuse at checkout.
  Future<void> _repricePromo() async {
    final code = _promoCode;
    if (code == null) return;
    final rejection = await applyPromo(code);
    if (rejection != null && _promoCode == code) removePromo();
  }
}
