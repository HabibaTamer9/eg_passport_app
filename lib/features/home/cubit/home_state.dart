import 'package:equatable/equatable.dart';

// ─────────────────────────────────────────────
//  MODELS
// ─────────────────────────────────────────────

class UserModel extends Equatable {
  final String fullName;
  final String nationality;
  final String? avatarUrl;

  const UserModel({
    required this.fullName,
    required this.nationality,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [fullName, nationality, avatarUrl];
}

class PassportModel extends Equatable {
  final String id;
  final String applicationNumber;
  final String qrCodeUrl; // URL or base64 returned from API
  final int expirySeconds; // countdown seconds returned from API

  const PassportModel({
    required this.id,
    required this.applicationNumber,
    required this.qrCodeUrl,
    required this.expirySeconds,
  });

  PassportModel copyWith({
    String? id,
    String? applicationNumber,
    String? qrCodeUrl,
    int? expirySeconds,
  }) {
    return PassportModel(
      id: id ?? this.id,
      applicationNumber: applicationNumber ?? this.applicationNumber,
      qrCodeUrl: qrCodeUrl ?? this.qrCodeUrl,
      expirySeconds: expirySeconds ?? this.expirySeconds,
    );
  }

  @override
  List<Object?> get props => [id, applicationNumber, qrCodeUrl, expirySeconds];
}

// Each step in the application progress timeline
class ApplicationStep extends Equatable {
  final String label;
  final StepStatus status;

  const ApplicationStep({required this.label, required this.status});

  @override
  List<Object?> get props => [label, status];
}

enum StepStatus { done, active, pending }

class ApplicationStatusModel extends Equatable {
  final List<ApplicationStep> steps;

  const ApplicationStatusModel({required this.steps});

  @override
  List<Object?> get props => [steps];
}

class DocumentModel extends Equatable {
  final String id;
  final String label;
  final bool isUploaded;
  final String? fileUrl; // local path or network url

  const DocumentModel({
    required this.id,
    required this.label,
    required this.isUploaded,
    this.fileUrl,
  });

  @override
  List<Object?> get props => [id, label, isUploaded, fileUrl];
}

// ─────────────────────────────────────────────
//  STATES
// ─────────────────────────────────────────────

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final UserModel user;
  final PassportModel passport;
  final ApplicationStatusModel applicationStatus;
  final List<DocumentModel> uploadedDocuments;
  final List<DocumentModel> requiredDocuments;

  const HomeLoaded({
    required this.user,
    required this.passport,
    required this.applicationStatus,
    required this.uploadedDocuments,
    required this.requiredDocuments,
  });

  @override
  List<Object?> get props => [
        user,
        passport,
        applicationStatus,
        uploadedDocuments,
        requiredDocuments,
      ];
}

// Same as HomeLoaded but signals QR is refreshing (shows loader on button)
class HomeQrRefreshing extends HomeLoaded {
  const HomeQrRefreshing({
    required super.user,
    required super.passport,
    required super.applicationStatus,
    required super.uploadedDocuments,
    required super.requiredDocuments,
  });
}

class HomeError extends HomeState {
  final String message;
  const HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}
