import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_frontend/services/apiService.dart';
import 'inventory_event.dart';
import 'inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final ApiService apiService;

  InventoryBloc({required this.apiService}) : super(InventoryInitial()) {
    on<LoadInventory>(_onLoadInventory);
    on<AddProduct>(_onAddProduct);
    on<UpdateProduct>(_onUpdateProduct);
    on<DeleteProduct>(_onDeleteProduct);
  }

  Future<void> _onLoadInventory(
    LoadInventory event,
    Emitter<InventoryState> emit,
  ) async {
    emit(InventoryLoading());
    try {
      final products = await apiService.getInventory();
      emit(InventoryLoaded(products));
    } catch (e) {
      emit(InventoryError(e.toString()));
    }
  }

  Future<void> _onAddProduct(
    AddProduct event,
    Emitter<InventoryState> emit,
  ) async {
    try {
      await apiService.addProduct(
        event.name,
        event.price,
        event.quantity,
        event.categoryId,
      );
      add(LoadInventory());
    } catch (e) {
      emit(InventoryError(e.toString()));
    }
  }

  Future<void> _onUpdateProduct(
    UpdateProduct event,
    Emitter<InventoryState> emit,
  ) async {
    try {
      await apiService.updateProduct(
        event.id,
        event.name,
        event.price,
        event.quantity,
        event.categoryId,
      );
      add(LoadInventory());
    } catch (e) {
      emit(InventoryError(e.toString()));
    }
  }

  Future<void> _onDeleteProduct(
    DeleteProduct event,
    Emitter<InventoryState> emit,
  ) async {
    try {
      await apiService.deleteProduct(event.id);
      add(LoadInventory());
    } catch (e) {
      emit(InventoryError(e.toString()));
    }
  }
}
