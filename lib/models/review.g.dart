// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Review _$ReviewFromJson(Map<String, dynamic> json) => _Review(
  userName: json['userName'] as String,
  rating: (json['rating'] as num).toDouble(),
  text: json['text'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  isVerifiedPurchase: json['isVerifiedPurchase'] as bool? ?? false,
  helpfulCount: (json['helpfulCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ReviewToJson(_Review instance) => <String, dynamic>{
  'userName': instance.userName,
  'rating': instance.rating,
  'text': instance.text,
  'createdAt': instance.createdAt.toIso8601String(),
  'isVerifiedPurchase': instance.isVerifiedPurchase,
  'helpfulCount': instance.helpfulCount,
};
