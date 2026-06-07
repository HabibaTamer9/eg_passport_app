import 'package:eg_passport_app/features/requests/data/passport_request.dart';

abstract class RequestsState {
  const RequestsState();
}

class RequestsLoading extends RequestsState {
  const RequestsLoading();
}

class RequestsLoadedSuccess extends RequestsState {
  const RequestsLoadedSuccess({
    required this.allRequests,
    required this.visibleRequests,
    required this.selectedFilter,
  });

  final List<PassportRequest> allRequests;
  final List<PassportRequest> visibleRequests;
  final RequestFilter selectedFilter;
}

class RequestsLoadError extends RequestsState {
  const RequestsLoadError(this.message);

  final String message;
}
