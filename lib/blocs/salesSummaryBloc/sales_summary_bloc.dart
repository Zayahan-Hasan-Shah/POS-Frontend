import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pos_frontend/models/salesModel/salesSummary.dart';
import 'package:pos_frontend/services/apiService.dart';

part 'sales_summary_event.dart';
part 'sales_summary_state.dart';

class SalesSummaryBloc extends Bloc<SalesSummaryEvent,SalesSummaryState > {
  final ApiService apiService;

  SalesSummaryBloc({required this.apiService}) : super(SalesInitial()) {
    on<FetchDailySales>(_onFetchDailySales);
    on<FetchMonthlySales>(_onFetchMonthlySales);
  }

   Future<void> _onFetchDailySales(
    FetchDailySales event,
    Emitter<SalesSummaryState> emit,
  ) async {
    try {
      emit(SalesLoading());
      final salesData = await apiService.getDailySalesSummary();
      emit(SalesLoaded(salesData));
    } catch (e) {
      emit(SalesError(e.toString()));
    }
  }

  Future<void> _onFetchMonthlySales(
    FetchMonthlySales event,
    Emitter<SalesSummaryState> emit,
  ) async {
    try {
      emit(SalesLoading());
      final salesData = await apiService.getMonthlySalesSummary();
      emit(SalesLoaded(salesData));
    } catch (e) {
      emit(SalesError(e.toString()));
    }
  }
}