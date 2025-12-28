import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_item.freezed.dart';
part 'cart_item.g.dart';

/// Cart item model for menu items in cart
@freezed
sealed class CartItem with _$CartItem {
  const factory CartItem({
    required String menuItemId,
    required String menuItemName,
    required int price,
    required int quantity,
    @Default('') String imageUrl,
  }) = _CartItem;

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);
}
