import 'package:freezed_annotation/freezed_annotation.dart';

part 'review.freezed.dart';
part 'review.g.dart';

@freezed
abstract class Review with _$Review {
  const factory Review({
    required String userName,
    required double rating,
    required String text,
    required String date,
    @Default(false) bool isVerifiedPurchase,
    @Default(0) int helpfulCount,
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) =>
      _$ReviewFromJson(json);
}
