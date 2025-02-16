part of 'sales_summary_bloc.dart';

abstract class SalesSummaryEvent{}

class FetchDailySales extends SalesSummaryEvent {}

class FetchMonthlySales extends SalesSummaryEvent {}