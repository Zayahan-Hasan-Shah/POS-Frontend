import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pos_frontend/models/customerModel/customerEntity.dart';
import 'package:pos_frontend/services/apiService.dart';

part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final ApiService apiService;

  CustomerBloc({required this.apiService}) : super(CustomerInitial()) {
    on<LoadCustomers>(_onLoadCustomers);
    on<SelectCustomer>(_onSelectCustomer);
    on<AddCustomer>(_onAddCustomer);
    on<UpdateCustomer>(_onUpdateCustomer);
    on<DeleteCustomer>(_onDeleteCustomer);
    on<ClearSelectedCustomer>(_onClearSelectedCustomer);
  }

  Future<void> _onLoadCustomers(
    LoadCustomers event,
    Emitter<CustomerState> emit,
  ) async {
    emit(CustomerLoading());
    try {
      final customers = await apiService.getCustomers();
      emit(CustomerLoaded(customers: customers));
    } catch (e) {
      emit(CustomerError(e.toString()));
    }
  }

  void _onSelectCustomer(
    SelectCustomer event,
    Emitter<CustomerState> emit,
  ) {
    if (state is CustomerLoaded) {
      final currentState = state as CustomerLoaded;
      emit(currentState.copyWith(selectedCustomer: event.customer));
    }
  }

  Future<void> _onAddCustomer(
    AddCustomer event,
    Emitter<CustomerState> emit,
  ) async {
    try {
      if (state is CustomerLoaded) {
        final currentState = state as CustomerLoaded;
        final newCustomer = await apiService.createCustomer(event.customer);
        emit(CustomerLoaded(
          customers: [...currentState.customers, newCustomer],
          selectedCustomer: newCustomer,
        ));
      }
    } catch (e) {
      emit(CustomerError(e.toString()));
    }
  }

  Future<void> _onUpdateCustomer(
    UpdateCustomer event,
    Emitter<CustomerState> emit,
  ) async {
    try {
      if (state is CustomerLoaded) {
        final currentState = state as CustomerLoaded;
        final updatedCustomer = await apiService.updateCustomer(
          event.id,
          event.customer,
        );
        final updatedCustomers = currentState.customers.map((customer) {
          return customer.id == event.id ? updatedCustomer : customer;
        }).toList();
        emit(CustomerLoaded(
          customers: updatedCustomers,
          selectedCustomer: currentState.selectedCustomer?.id == event.id
              ? updatedCustomer
              : currentState.selectedCustomer,
        ));
      }
    } catch (e) {
      emit(CustomerError(e.toString()));
    }
  }

  Future<void> _onDeleteCustomer(
    DeleteCustomer event,
    Emitter<CustomerState> emit,
  ) async {
    try {
      if (state is CustomerLoaded) {
        final currentState = state as CustomerLoaded;
        await apiService.deleteCustomer(event.id);
        emit(CustomerLoaded(
          customers: currentState.customers
              .where((customer) => customer.id != event.id)
              .toList(),
          selectedCustomer: currentState.selectedCustomer?.id == event.id
              ? null
              : currentState.selectedCustomer,
        ));
      }
    } catch (e) {
      emit(CustomerError(e.toString()));
    }
  }

  void _onClearSelectedCustomer(
    ClearSelectedCustomer event,
    Emitter<CustomerState> emit,
  ) {
    if (state is CustomerLoaded) {
      final currentState = state as CustomerLoaded;
      emit(currentState.copyWith(selectedCustomer: null));
}
}
}