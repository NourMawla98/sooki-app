import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';

import '../../../../backend_integration/apis/orders_api.dart';
import '../../../../services/theme_service.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_styles.dart';
import '../../../reusable_components/skeleton/skeleton_shimmer.dart';
import '_cart_surface_theme.dart';

/// Payment-method selector shown on the cart screen. Fetches the available
/// methods from the backend and lets the customer pick their preferred one
/// (defaults to the first). Currently the backend offers a single method
/// (Cash on delivery), so it renders pre-selected.
class PaymentMethodPicker extends StatefulWidget {
  const PaymentMethodPicker({super.key});

  @override
  State<PaymentMethodPicker> createState() => _PaymentMethodPickerState();
}

class _PaymentMethodPickerState extends State<PaymentMethodPicker> {
  OrdersApi get _ordersApi => GetIt.instance<OrdersApi>();

  bool _loading = true;
  List<PaymentMethodOption> _methods = const [];
  int? _selectedId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result = await _ordersApi.getPaymentMethods();
    if (!mounted) return;
    result.fold(
      (_) => setState(() => _loading = false),
      (methods) => setState(() {
        _methods = methods;
        _selectedId = methods.isNotEmpty ? methods.first.id : null;
        _loading = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (context, _) {
        final c = CartSurfaceColors.of(
          isDark: ThemeService.instance.isDarkMode,
        );

        if (_loading) return _Skeleton(colors: c);
        if (_methods.isEmpty) return const SizedBox.shrink();

        return Column(
          children: [
            for (var i = 0; i < _methods.length; i++) ...[
              if (i > 0) const SizedBox(height: 8),
              _MethodRow(
                method: _methods[i],
                selected: _methods[i].id == _selectedId,
                colors: c,
                onTap: () => setState(() => _selectedId = _methods[i].id),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _MethodRow extends StatelessWidget {
  final PaymentMethodOption method;
  final bool selected;
  final CartSurfaceColors colors;
  final VoidCallback onTap;

  const _MethodRow({
    required this.method,
    required this.selected,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = selected
        ? AppColors.auroraPink.withValues(alpha: 0.55)
        : colors.glassBorder;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: colors.glassFill,
          border: Border.all(color: borderColor, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: AppColors.auroraElectricBlue.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(7),
              ),
              alignment: Alignment.center,
              child: FaIcon(
                FontAwesomeIcons.moneyBillWave,
                size: 11,
                color: AppColors.auroraElectricBlue,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                method.name,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: colors.text,
                ),
              ),
            ),
            _RadioDot(selected: selected, colors: colors),
          ],
        ),
      ),
    );
  }
}

class _RadioDot extends StatelessWidget {
  final bool selected;
  final CartSurfaceColors colors;

  const _RadioDot({required this.selected, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? AppColors.auroraPink : colors.textMute,
          width: 2,
        ),
      ),
      alignment: Alignment.center,
      child: selected
          ? Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.auroraPink,
              ),
            )
          : null,
    );
  }
}

class _Skeleton extends StatelessWidget {
  final CartSurfaceColors colors;
  const _Skeleton({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colors.glassFill,
        border: Border.all(color: colors.glassBorder, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 26,
            height: 26,
            child: SkeletonShimmer(borderRadius: BorderRadius.circular(7)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SizedBox(
              height: 11.5,
              child: SkeletonShimmer(borderRadius: BorderRadius.circular(4)),
            ),
          ),
        ],
      ),
    );
  }
}
