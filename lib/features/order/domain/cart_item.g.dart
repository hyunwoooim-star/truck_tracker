// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CartItem _$CartItemFromJson(Map<String, dynamic> json) => _CartItem(
  menuItemId: json['menuItemId'] as String,
  menuItemName: json['menuItemName'] as String,
  price: (json['price'] as num).toInt(),
  quantity: (json['quantity'] as num).toInt(),
  imageUrl: json['imageUrl'] as String? ?? '',
);

Map<String, dynamic> _$CartItemToJson(_CartItem instance) => <String, dynamic>{
  'menuItemId': instance.menuItemId,
  'menuItemName': instance.menuItemName,
  'price': instance.price,
  'quantity': instance.quantity,
  'imageUrl': instance.imageUrl,
};
