// import 'package:pos_frontend/models/inventoryModel/inventoryEntity.dart';

// class CartItem {
//   final InventoryEntity product;
//   int quantity;
//   double get total => product.price * quantity;

//   CartItem({
//     required this.product,
//     this.quantity = 1,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'product_id': product.id,
//       'quantity': quantity,
//       'price': product.price,
//       'total': total,
//     };
//   }
// }

import 'package:pos_frontend/models/inventoryModel/inventoryEntity.dart';

class CartItem {
  final InventoryEntity product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });
}