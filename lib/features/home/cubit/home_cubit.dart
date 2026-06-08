import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_state.dart';
import 'package:eg_passport_app/features/home/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  // Call this once when the screen opens, pass data from API + uploaded docs
  void loadHomeData({
    required UserModel user,
    required PassportModel passport,
    required ApplicationStatusModel applicationStatus,
    required List<DocumentModel> uploadedDocuments,
    required List<DocumentModel> requiredDocuments,
  }) {
    emit(HomeLoaded(
      user: user,
      passport: passport,
      applicationStatus: applicationStatus,
      uploadedDocuments: uploadedDocuments,
      requiredDocuments: requiredDocuments,
    ));
  }

  // Called when user taps "تحديث الآن" – triggers QR regeneration
  Future<void> refreshQrCode() async {
    final current = state;
    if (current is! HomeLoaded) return;

    emit(HomeQrRefreshing(
      user: current.user,
      passport: current.passport,
      applicationStatus: current.applicationStatus,
      uploadedDocuments: current.uploadedDocuments,
      requiredDocuments: current.requiredDocuments,
    ));

    try {
      // TODO: call your API here to regenerate QR
      // final newQrUrl = await passportRepository.refreshQr(current.passport.id);
      await Future.delayed(const Duration(seconds: 1)); // placeholder
      final newQrUrl =
          current.passport.qrCodeUrl; // replace with real API result

      emit(HomeLoaded(
        user: current.user,
        passport: current.passport.copyWith(qrCodeUrl: newQrUrl),
        applicationStatus: current.applicationStatus,
        uploadedDocuments: current.uploadedDocuments,
        requiredDocuments: current.requiredDocuments,
      ));
    } catch (e) {
      emit(HomeError(message: 'فشل تحديث رمز QR'));
    }
  }

  void loadError(String message) {
    emit(HomeError(message: message));
  }
}
