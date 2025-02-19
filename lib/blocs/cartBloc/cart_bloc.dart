import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_frontend/models/inventoryModel/inventoryEntity.dart';

// Events
abstract class CartEvent {}

class AddProductToCart extends CartEvent {
  final InventoryEntity product;
  final int quantity;
  AddProductToCart({required this.product, required this.quantity});
}

// States
abstract class CartState {}

class CartInitial extends CartState {}

class CartLoaded extends CartState {}

// Bloc
class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    on<AddProductToCart>((event, emit) {
      // Add cart logic here
      emit(CartLoaded());
    });
  }
}
