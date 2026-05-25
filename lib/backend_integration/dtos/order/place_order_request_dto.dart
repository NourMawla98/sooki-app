class PlaceOrderRequestDto {
  final int customerAddressId;
  final String? customerNote;

  const PlaceOrderRequestDto({
    required this.customerAddressId,
    this.customerNote,
  });

  Map<String, dynamic> toJson() => {
        'customerAddressId': customerAddressId,
        if (customerNote != null && customerNote!.isNotEmpty)
          'customerNote': customerNote,
      };
}
