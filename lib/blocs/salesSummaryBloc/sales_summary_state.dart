part of 'sales_summary_bloc.dart';

abstract class SalesSummaryState {}

class SalesInitial extends SalesSummaryState {}

class SalesLoading extends SalesSummaryState {}

class SalesLoaded extends SalesSummaryState {
  final List<SalesSummary> salesData;
  SalesLoaded(this.salesData);
}
class SalesError extends SalesSummaryState {
  final String message;
  SalesError(this.message);
}