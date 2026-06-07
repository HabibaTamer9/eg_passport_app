import 'package:eg_passport_app/features/requests/data/passport_request.dart';

abstract class RequestsRepository {
  Future<List<PassportRequest>> fetchRequests();
}

class MockRequestsRepository implements RequestsRepository {
  const MockRequestsRepository();

  @override
  Future<List<PassportRequest>> fetchRequests() async {
    await Future<void>.delayed(const Duration(milliseconds: 420));
    return const [
      PassportRequest(
        id: 'request_pending',
        title: 'طلب إصدار جواز سفر رقمي - جواز السفر العادي',
        passportType: 'جواز السفر العادي',
        requestNumber: 'EP-2025-0005847',
        submittedAt: '20 مايو 2025 - 10:30 م',
        status: PassportRequestStatus.pending,
        currentStageIndex: 1,
        stageDates: ['20 مايو', '20 مايو', '', ''],
      ),
      PassportRequest(
        id: 'request_approved',
        title: 'طلب إصدار جواز سفر رقمي - جواز السفر العادي',
        passportType: 'جواز السفر العادي',
        requestNumber: 'EP-2025-0004123',
        submittedAt: '15 مايو 2025 - 03:15 م',
        status: PassportRequestStatus.approved,
        currentStageIndex: 2,
        stageDates: ['10 مايو', '11 مايو', '15 مايو', ''],
      ),
      PassportRequest(
        id: 'request_completed',
        title: 'طلب إصدار جواز سفر رقمي - جواز السفر العادي',
        passportType: 'جواز السفر العادي',
        requestNumber: 'EP-2025-0002891',
        submittedAt: '05 مايو 2025 - 11:20 ص',
        status: PassportRequestStatus.completed,
        currentStageIndex: 3,
        stageDates: ['03 مايو', '03 مايو', '02 مايو', '05 مايو'],
      ),
      PassportRequest(
        id: 'request_rejected',
        title: 'طلب إصدار جواز سفر رقمي - جواز السفر العادي',
        passportType: 'جواز السفر العادي',
        requestNumber: 'EP-2025-0001456',
        submittedAt: '28 أبريل 2025 - 04:45 م',
        status: PassportRequestStatus.rejected,
        currentStageIndex: 1,
        stageDates: ['25 أبريل', '25 أبريل', '', '28 أبريل'],
        rejectionReason: 'صورة الوجه غير واضحة — يرجى إعادة رفع صورة واضحة بخلفية بيضاء',
      ),
    ];
  }
}
