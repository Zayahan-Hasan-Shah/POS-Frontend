import 'package:pos_frontend/models/inventoryModel/inventoryEntity.dart';

abstract class InventoryState {}

class InventoryInitial extends InventoryState {}

class InventoryLoading extends InventoryState {}

class InventoryLoaded extends InventoryState {
  final List<InventoryEntity> products;

  InventoryLoaded(this.products);
}

class InventoryError extends InventoryState {
  final String message;

  InventoryError(this.message);
}
