import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pos_frontend/models/SupplierModel/supplierModel.dart';
import 'package:pos_frontend/services/apiService.dart';

part 'supplier_event.dart';
part 'supplier_state.dart';

class SupplierBloc extends Bloc<SupplierEvent, SupplierState> {
  final ApiService apiService;

  SupplierBloc({required this.apiService}) : super(SupplierInitial()) {
    on<LoadSuppliers>(_onLoadSuppliers);
    on<AddSupplier>(_onAddSupplier);
    on<UpdateSupplier>(_onUpdateSupplier);
    on<DeleteSupplier>(_onDeleteSupplier);
  }

  Future<void> _onLoadSuppliers(
    LoadSuppliers event,
    Emitter<SupplierState> emit,
  ) async {
    emit(SupplierLoading());
    try {
      final suppliers = await apiService.getSuppliers();
      emit(SupplierLoaded(suppliers));
    } catch (e) {
      emit(SupplierError(e.toString()));
    }
  }

  Future<void> _onAddSupplier(
    AddSupplier event,
    Emitter<SupplierState> emit,
  ) async {
    try {
      if (state is SupplierLoaded) {
        final currentState = state as SupplierLoaded;
        final newSupplier = await apiService.createSupplier(event.supplier);
        emit(SupplierLoaded([...currentState.suppliers, newSupplier]));
      }
    } catch (e) {
      emit(SupplierError(e.toString()));
    }
  }

  Future<void> _onUpdateSupplier(
    UpdateSupplier event,
    Emitter<SupplierState> emit,
  ) async {
    try {
      if (state is SupplierLoaded) {
        final currentState = state as SupplierLoaded;
        final updatedSupplier = await apiService.updateSupplier(
          event.id,
          event.supplier,
        );
        final updatedSuppliers = currentState.suppliers.map((supplier) {
          return supplier.id == event.id ? updatedSupplier : supplier;
        }).toList();
        emit(SupplierLoaded(updatedSuppliers));
      }
    } catch (e) {
      emit(SupplierError(e.toString()));
    }
  }

  Future<void> _onDeleteSupplier(
    DeleteSupplier event,
    Emitter<SupplierState> emit,
  ) async {
    try {
      if (state is SupplierLoaded) {
        final currentState = state as SupplierLoaded;
        await apiService.deleteSupplier(event.id);
        emit(SupplierLoaded(
          currentState.suppliers
              .where((supplier) => supplier.id != event.id)
              .toList(),
        ));
      }
    } catch (e) {
      emit(SupplierError(e.toString()));
    }
  }
}
