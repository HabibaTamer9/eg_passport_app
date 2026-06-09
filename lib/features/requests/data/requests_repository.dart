import 'package:eg_passport_app/core/data/app_data.dart';
import 'package:eg_passport_app/features/requests/data/passport_request.dart';

import '../../../core/Api/api_helper.dart';
import '../../../core/Api/endpoint.dart';

abstract class RequestsRepository {
  Future<List<PassportRequest>> fetchRequests();
}

class MockRequestsRepository implements RequestsRepository {
  const MockRequestsRepository();



  @override
  Future<List<PassportRequest>> fetchRequests() async {
    print("fetchRequests");
      try {
        var response = await ApiHelper().getAPI(
          "${Endpoint.my}${Endpoint.applications}",
        );

        if (response["success"] != true) {
          print(response);
          return [];
        }
        print(response);

        final items = response["data"]["items"] as List;

        return items.map((item) {
          return PassportRequest(
            id: item["id"],
            title: "Passport Request",
            passportType: "Regular Passport",
            requestNumber: item["applicationNumber"],
            submittedAt: AppData().formatDate(item["submittedAt"] )?? "",
            status: _mapStatus(item["status"]),
            currentStageIndex: _getStageIndex(item["status"]),
            stageDates: [
              AppData().formatDate(item["createdAt"])
            ],
            rejectionReason: item["rejectionReason"],
          );
        }).toList();
      } catch (e) {
        print(e);
        return [];
      }

  }
  PassportRequestStatus _mapStatus(String? status) {
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
  int _getStageIndex(String? status) {
    switch (status) {
      case "PendingReview":
        return 1;

      case "Approved":
        return 2;

      case "Completed":
        return 2;

      case "Rejected":
        return 1;

      default:
        return 0;
    }
  }
}
