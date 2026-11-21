/// The kind of saving a deal offers. The backend sends the number.
enum DealType {
  /// Each item has a fixed deal price.
  singleItem,

  /// Every line bought together for one bundle price.
  bundle,

  /// Enough units of one item take a percent off every unit.
  multiBuy,

  /// Every buy line in the cart makes the free line cost nothing.
  freeGift,

  /// A cart subtotal over the threshold takes a percent off the cart.
  spendThreshold;

  /// Unknown numbers fall back to [singleItem], which is how a backend that
  /// predates deal types describes every deal.
  static DealType fromInt(int v) {
    switch (v) {
      case 2: return bundle;
      case 3: return multiBuy;
      case 4: return freeGift;
      case 5: return spendThreshold;
      default: return singleItem;
    }
  }
}

/// Whether a deal line is paid for or handed out free.
enum DealLineRole {
  buy,
  free;

  static DealLineRole fromInt(int v) => v == 2 ? free : buy;
}
