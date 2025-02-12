part of 'supplier_bloc.dart';

abstract class SupplierEvent extends Equatable {
  const SupplierEvent();

  @override
  List<Object?> get props => [];
}

class LoadSuppliers extends SupplierEvent {}

class AddSupplier extends SupplierEvent {
  final Supplier supplier;
  const AddSupplier(this.supplier);

  @override
  List<Object> get props => [supplier];
}

class UpdateSupplier extends SupplierEvent {
  final int id;
  final Supplier supplier;
  const UpdateSupplier(this.id, this.supplier);

  @override
  List<Object> get props => [id, supplier];
}

class DeleteSupplier extends SupplierEvent {
  final int id;
  const DeleteSupplier(this.id);

  @override
  List<Object> get props => [id];
}


