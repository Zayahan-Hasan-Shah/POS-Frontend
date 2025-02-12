part of 'customer_bloc.dart';

abstract class CustomerState extends Equatable {
  const CustomerState();

  @override
  List<Object?> get props => [];
}

class CustomerInitial extends CustomerState {}

class CustomerLoading extends CustomerState {}

class CustomerLoaded extends CustomerState {
  final List<Customer> customers;
  final Customer? selectedCustomer;

  const CustomerLoaded({
    required this.customers,
    this.selectedCustomer,
  });

  @override
  List<Object?> get props => [customers, selectedCustomer];

  CustomerLoaded copyWith({
    List<Customer>? customers,
    Customer? selectedCustomer,
  }) {
    return CustomerLoaded(
      customers: customers ?? this.customers,
      selectedCustomer: selectedCustomer ?? this.selectedCustomer,
    );
  }
}

class CustomerError extends CustomerState {
  final String message;

  const CustomerError(this.message);

  @override
  List<Object> get props => [message];
}

