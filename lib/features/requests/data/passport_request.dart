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

  PassportRequestStatus mapStatus(String? status) {
    switch (status) {
      case "PendingReview":
        return PassportRequestStatus.pending;

      case "Approved":
        return PassportRequestStatus.approved;

      case "Rejected":
        return PassportRequestStatus.rejected;

      case "Completed":
        return PassportRequestStatus.completed;

      default:
        return PassportRequestStatus.pending;
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

// data: {items:
// [{id: 9a429bc8-4697-4c77-82c4-fb5473ab928e,
// userId: 9b9f134a-aee3-4705-8caf-8a3ca3a7208d,
// applicationNumber: EGY-20260607-538782,
// status: PendingReview,
// submittedAt: 2026-06-07T21:24:02.7293904,
// reviewedAt: null,
// reviewedByAdminId: null,
// rejectionReason: null,
// rejectionReasonAr: null,
// rejectionReasonEn: null,
// createdAt: 2026-06-07T21:23:27.8849557,
// documents: [{id: 97756b5c-d263-4d4c-bc7e-10e779e73cb3, applicationId:
// 9a429bc8-4697-4c77-82c4-fb5473ab928e,
// documentType: ProfilePhoto,
// fileName: e9623ee775ef4adf8aac0156c6329593.png,
// fileUrl: /uploads/users/9b9f134a-aee3-4705-8caf-8a3ca3a7208d/applications/9a429bc8-4697-4c77-82c4-fb5473ab928e/ProfilePhoto/e9623ee775ef4adf8aac0156c6329593.png,
// contentType: image/png,
// fileSize: 3531,
// status: Uploaded,
// rejectionReason: null,
// uploadedAt: 2026-06-07T21:23:29.1277688},
// {id: 886e56b2-ec41-4a80-8dbb-78b668e9
