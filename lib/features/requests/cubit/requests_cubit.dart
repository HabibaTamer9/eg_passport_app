import 'package:eg_passport_app/features/requests/cubit/requests_state.dart';
import 'package:eg_passport_app/features/requests/data/passport_request.dart';
import 'package:eg_passport_app/features/requests/data/requests_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RequestsCubit extends Cubit<RequestsState> {
  RequestsCubit(this._repository) : super(const RequestsLoading());

  final RequestsRepository _repository;
  List<PassportRequest> _allRequests = const [];

  Future<void> loadRequests() async {
    emit(const RequestsLoading());
    try {
      _allRequests = await _repository.fetchRequests();
      emit(
        RequestsLoadedSuccess(
          allRequests: _allRequests,
          visibleRequests: _allRequests,
          selectedFilter: RequestFilter.all,
        ),
      );
    } catch (_) {
      emit(
        const RequestsLoadError('تعذر تحميل الطلبات، يرجى المحاولة مرة أخرى.'),
      );
    }
  }

  void filterRequests(RequestFilter filter) {
    final currentState = state;
    if (currentState is! RequestsLoadedSuccess) return;

    final matchingStatus = filter.matchingStatus;
    final visibleRequests = matchingStatus == null
        ? _allRequests
        : _allRequests
              .where((request) => request.status == matchingStatus)
              .toList();

    emit(
      RequestsLoadedSuccess(
        allRequests: _allRequests,
        visibleRequests: visibleRequests,
        selectedFilter: filter,
      ),
    );
  }

  int countForFilter(RequestFilter filter) {
    if (filter == RequestFilter.all) return _allRequests.length;
    final status = filter.matchingStatus;
    if (status == null) return _allRequests.length;
    return _allRequests.where((request) => request.status == status).length;
  }
}
