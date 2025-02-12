part of 'customer_bloc.dart';

abstract class CustomerEvent extends Equatable {
  const CustomerEvent();

  @override
  List<Object?> get props => [];
}

class LoadCustomers extends CustomerEvent {}

class SelectCustomer extends CustomerEvent {
  final Customer customer;

  const SelectCustomer(this.customer);

  @override
  List<Object> get props => [customer];
}

class AddCustomer extends CustomerEvent {
  final Customer customer;

  const AddCustomer(this.customer);

  @override
  List<Object> get props => [customer];
}

class UpdateCustomer extends CustomerEvent {
  final int id;
  final Customer customer;

  const UpdateCustomer(this.id, this.customer);

  @override
  List<Object> get props => [id, customer];
}

class DeleteCustomer extends CustomerEvent {
  final int id;

  const DeleteCustomer(this.id);

  @override
  List<Object> get props => [id];
}

class ClearSelectedCustomer extends CustomerEvent {}

