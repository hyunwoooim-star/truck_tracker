// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MenuItem _$MenuItemFromJson(Map<String, dynamic> json) => _MenuItem(
  id: json['id'] as String,
  name: json['name'] as String,
  price: (json['price'] as num).toInt(),
  description: json['description'] as String? ?? '',
  imageUrl: json['imageUrl'] as String? ?? '',
  isSoldOut: json['isSoldOut'] as bool? ?? false,
);

Map<String, dynamic> _$MenuItemToJson(_MenuItem instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'price': instance.price,
  'description': instance.description,
  'imageUrl': instance.imageUrl,
  'isSoldOut': instance.isSoldOut,
};
