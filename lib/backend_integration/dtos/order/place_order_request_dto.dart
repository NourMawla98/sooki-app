class PlaceOrderRequestDto {
  final int customerAddressId;
  final String? customerNote;
  final String? couponCode;

  /// The total the checkout showed. The backend refuses the order with a 409
  /// when its own total differs, so the shopper never pays a price they did
  /// not see.
  final double? expectedTotal;

  const PlaceOrderRequestDto({
    required this.customerAddressId,
    this.customerNote,
    this.couponCode,
    this.expectedTotal,
  });

  Map<String, dynamic> toJson() => {
        'customerAddressId': customerAddressId,
        if (customerNote != null && customerNote!.isNotEmpty)
          'customerNote': customerNote,
        if (couponCode != null && couponCode!.isNotEmpty) 'couponCode': couponCode,
        if (expectedTotal != null) 'expectedTotal': expectedTotal,
      };
}
