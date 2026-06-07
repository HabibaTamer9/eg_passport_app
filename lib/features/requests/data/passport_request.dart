enum PassportRequestStatus { pending, approved, completed, rejected }

enum RequestFilter { all, pending, approved, completed, rejected }

class PassportRequest {
  const PassportRequest({
    required this.id,
    required this.title,
    required this.passportType,
    required this.requestNumber,
    required this.submittedAt,
    required this.status,
    required this.currentStageIndex,
    required this.stageDates,
    this.rejectionReason,
  });

  final String id;
  final String title;
  final String passportType;
  final String requestNumber;
  final String submittedAt;
  final PassportRequestStatus status;
  final int currentStageIndex;
  final List<String> stageDates;
  final String? rejectionReason;
}

extension PassportRequestStatusInfo on PassportRequestStatus {
  String get label {
    switch (this) {
      case PassportRequestStatus.pending:
        return 'قيد المراجعة';
      case PassportRequestStatus.approved:
        return 'تمت الموافقة';
      case PassportRequestStatus.completed:
        return 'مكتمل';
      case PassportRequestStatus.rejected:
        return 'تم الرفض';
    }
  }
}

extension RequestFilterInfo on RequestFilter {
  String get label {
    switch (this) {
      case RequestFilter.all:
        return 'الكل';
      case RequestFilter.pending:
        return 'قيد المراجعة';
      case RequestFilter.approved:
        return 'تمت الموافقة';
      case RequestFilter.completed:
        return 'مكتمل';
      case RequestFilter.rejected:
        return 'تم الرفض';
    }
  }

  PassportRequestStatus? get matchingStatus {
    switch (this) {
      case RequestFilter.all:
        return null;
      case RequestFilter.pending:
        return PassportRequestStatus.pending;
      case RequestFilter.approved:
        return PassportRequestStatus.approved;
      case RequestFilter.completed:
        return PassportRequestStatus.completed;
      case RequestFilter.rejected:
        return PassportRequestStatus.rejected;
    }
  }
}
