class PlaceOrderRequestDto {
  final int customerAddressId;
  final String? customerNote;
  final String? couponCode;

  const PlaceOrderRequestDto({
    required this.customerAddressId,
    this.customerNote,
    this.couponCode,
  });

  Map<String, dynamic> toJson() => {
        'customerAddressId': customerAddressId,
        if (customerNote != null && customerNote!.isNotEmpty)
          'customerNote': customerNote,
        if (couponCode != null && couponCode!.isNotEmpty) 'couponCode': couponCode,
      };
}
