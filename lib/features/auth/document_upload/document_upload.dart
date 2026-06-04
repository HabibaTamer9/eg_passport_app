import 'dart:async';
import 'package:dio/dio.dart';
import 'package:eg_passport_app/core/theme/app_colors.dart';
import 'package:eg_passport_app/features/auth/otp/view/otp_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/Api/api_helper.dart';
import '../../../core/Api/endpoint.dart';
import '../../../core/customs/custom_button.dart';
import '../../../core/data/app_data.dart';
import '../widgets/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../otp/cubit/otp_cubit.dart';
import 'document_file_picker_service.dart';
import 'document_upload_models.dart';

class DocumentUploadScreen extends StatefulWidget {
  const DocumentUploadScreen({super.key});

  @override
  State<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  static const Color _crimsonRed = Color(0xFFBD0F1B);
  static const Color _successGreen = Color(0xFF168A46);
  static const Color _pageBackground = Color(0xFFF7F6F3);
  static const Color _cardBackground = Color(0xFFFFFFFF);
  static const Color _borderColor = Color(0xFFE7E2D9);
  static const Color _mutedText = Color(0xFF6F6A61);
  static const Color _goldAccent = Color(0xFFC5A15B);
  static const Color _ink = Color(0xFF201B16);
  static const Color _securityBadgeBg = Color(0xFFFBF7EA);
  static const Color _sidebarActiveBg = Color(0xFFF8F1E3);
  static const double _webBreakpoint = 900;

  static const String _securityText =
      'جميع ملفاتك محمية ومشفرة: نضمن سرية وأمان بياناتك وفقاً لأعلى معايير الأمن';

  /// Progress milestones shown while [_simulateNetworkUpload] runs.
  static const List<int> _uploadProgressSteps = [40, 70, 100];

  late final Map<DocumentField, DocumentUploadSlotState> _uploads = {
    for (final field in DocumentField.values) field: DocumentUploadSlotState(),
  };

  final Map<DocumentField, Timer?> _uploadTimers = {};

  /// True only when all 4 required documents reached 100% (existing passport optional).
  bool get _canProceed {
    return DocumentUploadRegistry.requiredSlots.every(
      (slot) => _uploads[slot.id]!.isComplete,
    );
  }

  @override
  void dispose() {
    for (final timer in _uploadTimers.values) {
      timer?.cancel();
    }
    super.dispose();
  }

  void _showSnack(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, textAlign: TextAlign.right),
        backgroundColor: isError ? _crimsonRed : _successGreen,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Entry point: card tap, action button, or bottom-sheet row.
  Future<void> _pickAndUploadDocument(DocumentField field) async {
    final state = _uploads[field]!;
    if (state.isUploading) return;

    try {
      final picked = await DocumentFilePickerService.pickForField(field);
      if (!mounted || picked == null) return;

      _uploadTimers[field]?.cancel();
      setState(() {
        state.fileName = picked.name;
        state.filePath = picked.displayPath;
        state.fileSizeBytes = picked.sizeBytes;
      });

      await _simulateNetworkUpload(field);
    } on DocumentPickValidationException catch (error) {
      _showSnack(error.messageAr, isError: true);
    } catch (e) {
      print(e);
      _showSnack(
        'فشل رفع الملف. تحقق من اتصالك بالإنترنت وحاول مرة أخرى',
        isError: true,
      );
    }
  }

  /// TEMP: simulates server upload after a real file pick.
  /// Replace with Dio/multipart + onSendProgress (or polling) calling setState.
  Future<void> _simulateNetworkUpload(DocumentField field) async {
    final state = _uploads[field]!;
    if (state.isUploading) return;

    _uploadTimers[field]?.cancel();

    if (!mounted) return;
    setState(() {
      state.phase = DocumentUploadPhase.uploading;
      state.progress = 0;
    });

    final completer = Completer<void>();
    var stepIndex = -1;

    void scheduleNextStep() {
      stepIndex += 1;
      if (!mounted) {
        completer.complete();
        return;
      }

      if (stepIndex < _uploadProgressSteps.length) {
        setState(() => state.progress = _uploadProgressSteps[stepIndex]);
        _uploadTimers[field] = Timer(
          const Duration(milliseconds: 550),
          scheduleNextStep,
        );
        return;
      }

      setState(() {
        state.progress = 100;
        state.phase = DocumentUploadPhase.complete;
      });
      _uploadTimers[field]?.cancel();
      _uploadTimers[field] = null;
      completer.complete();
    }

    _uploadTimers[field] = Timer(
      const Duration(milliseconds: 300),
      scheduleNextStep,
    );
    return completer.future;
  }

  void _removeUpload(DocumentField field) {
    _uploadTimers[field]?.cancel();
    _uploadTimers[field] = null;

    setState(() => _uploads[field]!.reset());
  }

  Future<void> _showReviewDialog() async {
    if (!_canProceed) return;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: _cardBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            title: const Text(
              'مراجعة المستندات',
              style: TextStyle(fontWeight: FontWeight.w800, color: _ink),
            ),
            content: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: DocumentUploadRegistry.all.map((document) {
                  final state = _uploads[document.id]!;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Icon(
                          state.isComplete
                              ? Icons.check_circle
                              : Icons.info_outline,
                          size: 20,
                          color: state.isComplete ? _successGreen : _mutedText,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _documentTitle(document),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _ink,
                            ),
                          ),
                        ),
                        Text(
                          state.isComplete
                              ? 'جاهز'
                              : (document.required ? 'مطلوب' : 'اختياري'),
                          style: TextStyle(
                            color: state.isComplete
                                ? _successGreen
                                : _mutedText,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('إلغاء', style: TextStyle(color: _mutedText)),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  uploadAndSubmitApplication();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _crimsonRed,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('تأكيد الإرسال'),
              ),
            ],
          ),
        );
      },
    );
  }

  String messageLanguage = ApiHelper.messageLanguage;

  String _apiMessage(Map<String, dynamic> response) {
    final errors = response["errors"];
    if (errors.isNotEmpty) {
      return errors.first[messageLanguage] ?? "حدث خطأ في البيانات";
    }

    return response[messageLanguage] ?? "حدث خطأ غير متوقع";
  }

  Future<void> _showApiDialog({
    required String title,
    required String message,
  }) async {
    if (!mounted) return;

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CustomButton(textName: "OK", onPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }

  String _documentTypeName(DocumentField field) {
    return field.toString().split('.').last;
  }

  Future<String?> _ensureDraftApplication() async {
    if (AppData.user.applicationId != null &&
        AppData.user.applicationId!.isNotEmpty) {
      return AppData.user.applicationId;
    }

    final response = await ApiHelper().postAPI("${Endpoint.appURL}draft", {});
    if (response["success"] != true) {
      return null;
    }

    final applicationId = response["data"]?["id"]?.toString();
    AppData.user.applicationId = applicationId;
    AppData.user.appNumber = response["data"]?["applicationNumber"]?.toString();
    return applicationId;
  }

  Future<void> uploadAndSubmitApplication() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("جاري رفع المستندات"),
        content: Center(
          child: CircularProgressIndicator(color: AppColors.primaryRedColor),
        ),
      ),
    );

    try {
      final applicationId = await _ensureDraftApplication();
      if (applicationId == null) {
        if (mounted) Navigator.of(context, rootNavigator: true).pop();
        await _showApiDialog(title: "خطأ", message: "تعذر إنشاء طلب جديد.");
        return;
      }

      final selectedDocuments = _uploads.entries
          .where((entry) =>
      entry.value.filePath != null &&
          entry.value.filePath!.trim().isNotEmpty)
          .toList();

      for (final document in selectedDocuments) {
        final path = document.value.filePath!;
        final fileName = path.split(RegExp(r'[\\/]')).last;
        final formData = FormData.fromMap({
          "DocumentType": _documentTypeName(document.key),
          "File": await MultipartFile.fromFile(path, filename: fileName),
        });

        final response = await ApiHelper().docPostAPI(
          "${Endpoint.appURL}$applicationId/${Endpoint.documents}",
          formData,
        );

        if (response["success"] != true) {
          if (mounted) Navigator.of(context, rootNavigator: true).pop();
          await _showApiDialog(title: "خطأ", message: _apiMessage(response));
          return;
        }
      }

      if (mounted) Navigator.of(context, rootNavigator: true).pop();

      await _showApiDialog(
        title: "تم",
        message: "تم رفع المستندات. أكمل التحقق من رمز OTP لإرسال الطلب.",
      );

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) => OtpCubit(),
            child: const OtpScreen(),
          ),
        ),
      );
    } catch (e) {
      if (mounted) Navigator.of(context, rootNavigator: true).pop();
      await _showApiDialog(
        title: "خطأ",
        message: "حدث خطأ أثناء رفع المستندات. حاول مرة أخرى.",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _pageBackground,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= _webBreakpoint;
            return isWide ? _buildWebLayout() : _buildMobileLayout();
          },
        ),
      ),
    );
  }

  Widget _buildWebLayout() {
    return Row(
      textDirection: TextDirection.rtl,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSidebar(width: 260),
        Expanded(
          child: Column(
            children: [
              _buildTopBar(compact: false),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(28, 22, 28, 28),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1080),
                      child: _buildMainContent(isWide: true),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Background(
      currentIndex: 2,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
              child: _buildMainContent(isWide: false),
            ),
          ),
          _buildBottomActions(isWide: false),
        ],
      ),
    );
  }

  Widget _buildTopBar({required bool compact}) {
    return SafeArea(
      bottom: false,
      child: Container(
        height: compact ? 64 : 70,
        padding: EdgeInsets.symmetric(horizontal: compact ? 10 : 28),
        decoration: const BoxDecoration(
          color: _cardBackground,
          border: Border(bottom: BorderSide(color: _borderColor)),
        ),
        child: Row(
          children: [
            if (compact)
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.menu_rounded),
                color: _ink,
                tooltip: 'القائمة',
              )
            else
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.menu_rounded),
                color: _ink,
                tooltip: 'القائمة',
              ),
            const Spacer(),
            _buildLogo(compact: compact),
            const Spacer(),
            if (!compact) ...[
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_outlined),
                color: _ink,
                tooltip: 'الإشعارات',
              ),
              const SizedBox(width: 8),
              _buildLanguagePill(),
              const SizedBox(width: 14),
              _buildUserChip(),
            ] else
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_outlined),
                color: _ink,
                tooltip: 'الإشعارات',
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguagePill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: _cardBackground,
        border: Border.all(color: _borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.language, size: 16, color: _mutedText),
          SizedBox(width: 6),
          Text(
            'العربية',
            style: TextStyle(
              color: _ink,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 4),
          Icon(Icons.keyboard_arrow_down, size: 16, color: _mutedText),
        ],
      ),
    );
  }

  Widget _buildUserChip() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircleAvatar(
          radius: 18,
          backgroundColor: Color(0xFFE9D8C0),
          child: Icon(Icons.person, color: _crimsonRed, size: 20),
        ),
        const SizedBox(width: 9),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'أحمد محمد علي',
              style: TextStyle(
                color: _ink,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'مواطن مصري',
              style: TextStyle(color: _mutedText, fontSize: 11),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLogo({required bool compact}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: compact ? 34 : 42,
          height: compact ? 34 : 42,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF5D893), Color(0xFFB8862E)],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.workspace_premium, color: Colors.white),
        ),
        const SizedBox(width: 10),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Egy E-Passport',
              style: TextStyle(
                color: _crimsonRed,
                fontSize: compact ? 14 : 16,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              'جواز السفر الرقمي المصري',
              style: TextStyle(
                color: _mutedText,
                fontSize: compact ? 9 : 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSidebar({required double width}) {
    return Container(
      width: width,
      decoration: const BoxDecoration(
        color: _cardBackground,
        border: Border(left: BorderSide(color: _borderColor)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
              child: Row(
                children: const [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Color(0xFFE9D8C0),
                    child: Icon(Icons.person, color: _crimsonRed),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'أحمد محمد علي',
                          style: TextStyle(
                            color: _ink,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          '29301019001234',
                          style: TextStyle(color: _mutedText, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: _borderColor),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 10),
                children: [
                  _sidebarItem(Icons.home_outlined, 'الرئيسية', false),
                  _sidebarItem(Icons.assignment_outlined, 'إدارة الطلب', false),
                  _sidebarItem(Icons.article_outlined, 'طلباتي', false),
                  _sidebarItem(Icons.folder_open_outlined, 'المستندات', true),
                  _sidebarItem(
                    Icons.notifications_outlined,
                    'الإشعارات',
                    false,
                  ),
                  _sidebarItem(Icons.person_outline, 'الملف الشخصي', false),
                  _sidebarItem(Icons.settings_outlined, 'الإعدادات', false),
                ],
              ),
            ),
            _buildSidebarFooter(),
          ],
        ),
      ),
    );
  }

  Widget _sidebarItem(IconData icon, String label, bool active) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: active ? _sidebarActiveBg : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            child: Row(
              children: [
                Icon(icon, size: 20, color: active ? _crimsonRed : _mutedText),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: active ? _crimsonRed : _ink,
                      fontSize: 14,
                      fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSidebarFooter() {
    return Container(
      height: 128,
      margin: const EdgeInsets.all(18),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F0E2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 12,
            bottom: 18,
            child: Icon(
              Icons.account_balance,
              size: 72,
              color: _goldAccent.withValues(alpha: 0.26),
            ),
          ),
          Positioned(
            left: -18,
            bottom: -18,
            child: Container(
              width: 132,
              height: 132,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _crimsonRed, width: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent({required bool isWide}) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'رفع المستندات المطلوبة',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _ink,
            fontSize: isWide ? 25.sp : 19.sp,
            fontWeight: FontWeight.w900,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          'أكمل رفع المستندات المطلوبة لإتمام طلب جواز السفر الرقمي',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _mutedText,
            fontSize: isWide ? 14.sp : 12.sp,
            height: 1.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: isWide ? 24 : 16),
        if (isWide) ...[_buildDropZone(), const SizedBox(height: 24)],
        Text(
          'المستندات المطلوبة',
          style: TextStyle(
            color: _ink,
            fontSize: isWide ? 17 : 14,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 12),
        isWide ? _buildWebDocumentsGrid() : _buildMobileDocumentsList(),
        const SizedBox(height: 18),
        _buildSecurityBadge(),
        if (isWide) ...[
          const SizedBox(height: 24),
          _buildBottomActions(isWide: true),
        ],
      ],
    );

    if (!isWide) return content;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: _cardBackground,
        border: Border.all(color: _borderColor),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: content,
    );
  }

  Widget _buildDropZone() {
    return DragTarget<Object>(
      onWillAcceptWithDetails: (_) => true,
      onAcceptWithDetails: (_) => _showPickDocumentSheet(),
      builder: (context, candidateData, rejectedData) {
        final highlighted = candidateData.isNotEmpty;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _showPickDocumentSheet,
            borderRadius: BorderRadius.circular(10),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 30),
              decoration: BoxDecoration(
                color: highlighted ? _securityBadgeBg : const Color(0xFFFEFDFB),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: highlighted ? _crimsonRed : _borderColor,
                  width: highlighted ? 1.8 : 1.2,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    color: _goldAccent,
                    size: 46,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'اسحب وأفلت الملفات هنا',
                    style: TextStyle(
                      color: _ink,
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'أو اضغط لاختيار نوع المستند وبدء الرفع',
                    style: TextStyle(
                      color: _mutedText,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 9),
                  Text(
                    'JPG, PNG, PDF · حتى 10MB حسب نوع المستند',
                    style: TextStyle(
                      color: _mutedText.withValues(alpha: 0.85),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showPickDocumentSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 44,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: _borderColor,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(
                      'اختر المستند للرفع',
                      style: TextStyle(
                        color: _ink,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  ...DocumentUploadRegistry.all.map((document) {
                    final state = _uploads[document.id]!;
                    return ListTile(
                      enabled: !state.isUploading,
                      leading: _buildDocumentStateIcon(state, document),
                      title: Text(
                        _documentTitle(document),
                        style: const TextStyle(
                          color: _ink,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      subtitle: Text(document.rulesAr),
                      onTap: state.isUploading
                          ? null
                          : () {
                              Navigator.pop(context);
                              _pickAndUploadDocument(document.id);
                            },
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color _documentBorderColor({
    required DocumentUploadSlotState state,
    bool highlighted = false,
  }) {
    if (highlighted || state.isUploading) {
      return _crimsonRed.withValues(alpha: 0.72);
    }
    if (state.isComplete) {
      return _successGreen.withValues(alpha: 0.54);
    }
    return _borderColor;
  }

  Color _cardShadowColor(DocumentUploadSlotState state) {
    if (state.isUploading) {
      return _crimsonRed.withValues(alpha: 0.12);
    }
    if (state.isComplete) {
      return _successGreen.withValues(alpha: 0.10);
    }
    return Colors.black.withValues(alpha: 0.035);
  }

  Widget _buildStatusPill(DocumentUploadSlotState state) {
    final Color color;
    final Color backgroundColor;
    final String text;

    if (state.isComplete) {
      color = _successGreen;
      backgroundColor = _successGreen.withValues(alpha: 0.10);
      text = '100%';
    } else if (state.isUploading) {
      color = _crimsonRed;
      backgroundColor = _crimsonRed.withValues(alpha: 0.08);
      text = '${state.progress}%';
    } else {
      color = _mutedText;
      backgroundColor = const Color(0xFFF2EEE8);
      text = '0%';
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      margin: const EdgeInsetsDirectional.only(start: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10.5,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
    );
  }

  /// Shows the user-selected file name after a successful [FilePicker] result.
  Widget _buildSelectedFileLabel(DocumentUploadSlotState state) {
    if (!state.hasSelectedFile) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        children: [
          const Icon(
            Icons.insert_drive_file_outlined,
            size: 14,
            color: _mutedText,
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              state.fileName!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _ink,
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldNameChip(DocumentSlotConfig document) {
    return Row(
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F2EE),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: _borderColor),
            ),
            child: Text(
              document.fieldName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textDirection: TextDirection.ltr,
              style: const TextStyle(
                color: _mutedText,
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
          decoration: BoxDecoration(
            color: document.required
                ? _crimsonRed.withValues(alpha: 0.08)
                : _successGreen.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            document.required ? 'مطلوب *' : 'اختياري',
            style: TextStyle(
              color: document.required ? _crimsonRed : _successGreen,
              fontSize: 10.5,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadActionButton(
    DocumentSlotConfig document,
    DocumentUploadSlotState state, {
    required bool compact,
  }) {
    final label = state.isComplete ? 'إعادة الرفع' : 'بدء الرفع';
    final icon = state.isComplete
        ? Icons.refresh_rounded
        : state.isUploading
        ? Icons.sync_rounded
        : Icons.cloud_upload_outlined;
    final color = state.isComplete ? _successGreen : _crimsonRed;

    if (compact) {
      return Tooltip(
        message: label,
        child: SizedBox(
          width: 34,
          height: 30,
          child: IconButton(
            onPressed: state.isUploading
                ? null
                : () => _pickAndUploadDocument(document.id),
            icon: Icon(icon, size: 17),
            color: color,
            padding: EdgeInsets.zero,
            style: IconButton.styleFrom(
              backgroundColor: color.withValues(alpha: 0.09),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
            ),
          ),
        ),
      );
    }

    return OutlinedButton.icon(
      onPressed: state.isUploading
          ? null
          : () => _pickAndUploadDocument(document.id),
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color.withValues(alpha: 0.48)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        minimumSize: const Size.fromHeight(36),
        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildWebDocumentsGrid() {
    final requiredDocuments = DocumentUploadRegistry.all
        .where((document) => document.required)
        .toList();
    final optionalDocument = DocumentUploadRegistry.all.firstWhere(
      (document) => !document.required,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 900 ? 4 : 2;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: columns == 4 ? 0.72 : 0.98,
              ),
              itemCount: requiredDocuments.length,
              itemBuilder: (context, index) {
                return _buildWebDocumentCard(requiredDocuments[index]);
              },
            );
          },
        ),
        const SizedBox(height: 14),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 260,
            height: 360,
            child: _buildWebDocumentCard(optionalDocument),
          ),
        ),
      ],
    );
  }

  Widget _buildWebDocumentCard(DocumentSlotConfig document) {
    final state = _uploads[document.id]!;

    return DragTarget<Object>(
      onWillAcceptWithDetails: (_) => !state.isUploading,
      onAcceptWithDetails: (_) => _pickAndUploadDocument(document.id),
      builder: (context, candidateData, rejectedData) {
        final highlighted = candidateData.isNotEmpty;

        return Tooltip(
          message: document.rulesEn,
          waitDuration: const Duration(milliseconds: 500),
          child: Material(
            color: _cardBackground,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: state.isUploading
                  ? null
                  : () => _pickAndUploadDocument(document.id),
              borderRadius: BorderRadius.circular(8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: highlighted
                      ? _securityBadgeBg
                      : const Color(0xFFFEFDFB),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _documentBorderColor(
                      state: state,
                      highlighted: highlighted,
                    ),
                    width: highlighted ? 1.6 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _cardShadowColor(state),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            _documentTitle(document),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: _ink,
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              height: 1.25,
                            ),
                          ),
                        ),
                        _buildStatusPill(state),
                        if (state.isComplete)
                          _smallIconButton(
                            icon: Icons.close_rounded,
                            tooltip: 'إزالة وإعادة الرفع',
                            onPressed: () => _removeUpload(document.id),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    _buildFieldNameChip(document),
                    _buildSelectedFileLabel(state),
                    const SizedBox(height: 8),
                    Expanded(child: _buildPreviewThumbnail(document, state)),
                    const SizedBox(height: 9),
                    Text(
                      document.rulesAr,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _mutedText,
                        fontSize: 10.5,
                        height: 1.3,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildUploadStatus(document, state, compact: false),
                    const SizedBox(height: 8),
                    _buildUploadActionButton(document, state, compact: false),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMobileDocumentsList() {
    return Column(
      children: DocumentUploadRegistry.all.map((document) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _buildMobileDocumentRow(document),
        );
      }).toList(),
    );
  }

  Widget _buildMobileDocumentRow(DocumentSlotConfig document) {
    final state = _uploads[document.id]!;

    return Tooltip(
      message: document.rulesEn,
      child: Material(
        color: _cardBackground,
        borderRadius: BorderRadius.circular(9),
        child: InkWell(
          onTap: state.isUploading
              ? null
              : () => _pickAndUploadDocument(document.id),
          borderRadius: BorderRadius.circular(9),
          child: Container(
            constraints: const BoxConstraints(minHeight: 84),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: _documentBorderColor(state: state)),
              boxShadow: [
                BoxShadow(
                  color: _cardShadowColor(state),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              textDirection: TextDirection.rtl,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 58,
                  height: 58,
                  child: _buildPreviewThumbnail(document, state),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _documentTitle(document),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: _ink,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          _buildStatusPill(state),
                          if (state.isComplete)
                            _smallIconButton(
                              icon: Icons.refresh_rounded,
                              tooltip: 'إعادة الرفع',
                              onPressed: () => _removeUpload(document.id),
                            ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      _buildSelectedFileLabel(state),
                      Text(
                        document.rulesAr,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _mutedText,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Row(
                        children: [
                          Expanded(
                            child: _buildUploadStatus(
                              document,
                              state,
                              compact: true,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _buildUploadActionButton(
                            document,
                            state,
                            compact: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewThumbnail(
    DocumentSlotConfig document,
    DocumentUploadSlotState state,
  ) {
    if (state.isIdle && !state.hasSelectedFile) {
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFAF8F5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _borderColor),
        ),
        child: Center(
          child: Icon(
            document.required
                ? Icons.cloud_upload_outlined
                : Icons.upload_file_outlined,
            color: _mutedText,
            size: 28,
          ),
        ),
      );
    }

    final isPassport = document.id == DocumentField.ExistingPassport;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: document.previewColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: state.isComplete
              ? _successGreen.withValues(alpha: 0.45)
              : _borderColor,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (isPassport)
            _buildPassportPreview(state)
          else
            _buildPaperPreview(document, state),
          if (state.isUploading)
            Center(
              child: SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(
                  value: state.progress > 0 ? state.progress / 100 : null,
                  strokeWidth: 4,
                  color: _crimsonRed,
                  backgroundColor: Colors.white.withValues(alpha: 0.78),
                ),
              ),
            ),
          if (state.isComplete)
            Positioned(
              top: 5,
              right: 5,
              child: Container(
                width: 19,
                height: 19,
                decoration: const BoxDecoration(
                  color: _successGreen,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 13),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPaperPreview(
    DocumentSlotConfig document,
    DocumentUploadSlotState state,
  ) {
    const foreground = Color(0xCC201B16);

    if (document.id == DocumentField.ProfilePhoto) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.person, color: foreground, size: 34),
            if (state.hasSelectedFile) ...[
              const SizedBox(height: 6),
              _previewFileName(state.fileName!),
            ],
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(document.icon, color: foreground, size: 24.sp),
        ],
      ),
    );
  }

  Widget _previewFileName(String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: _ink.withValues(alpha: 0.75),
          fontSize: 9.sp,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildPassportPreview(DocumentUploadSlotState state) {
    return Container(
      margin: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: const Color(0xFF171717),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.workspace_premium, color: _goldAccent, size: 24),

        ],
      ),
    );
  }

  Widget _buildUploadStatus(
    DocumentSlotConfig document,
    DocumentUploadSlotState state, {
    required bool compact,
  }) {
    if (state.isComplete) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.check_circle, color: _successGreen, size: 17),
          SizedBox(width: 6),
          Text(
            'تم الرفع بنجاح',
            style: TextStyle(
              color: _successGreen,
              fontSize: 12.5,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      );
    }

    if (state.isIdle) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_upload_outlined, color: _mutedText, size: 16),
          const SizedBox(width: 5),
          Text(
            document.id == DocumentField.ExistingPassport
                ? 'لم يتم رفع ملف'
                : 'اضغط للرفع',
            style: const TextStyle(
              color: _mutedText,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      );
    }

    if (state.isUploading && state.progress == 0) {
      return const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: _crimsonRed,
            ),
          ),
          SizedBox(width: 6),
          Text(
            'جاري الرفع...',
            style: TextStyle(
              color: _mutedText,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  value: state.progress / 100,
                  minHeight: compact ? 4 : 5,
                  backgroundColor: const Color(0xFFF1D4D5),
                  valueColor: const AlwaysStoppedAnimation<Color>(_crimsonRed),
                ),
              ),
            ),
            const SizedBox(width: 9),
            Text(
              '${state.progress}%',
              style: const TextStyle(
                color: _crimsonRed,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        if (!compact) ...[
          const SizedBox(height: 5),
          const Text(
            'جاري الرفع...',
            style: TextStyle(
              color: _mutedText,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSecurityBadge() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 14,
        vertical: MediaQuery.sizeOf(context).width >= _webBreakpoint ? 14 : 11,
      ),
      decoration: BoxDecoration(
        color: _securityBadgeBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFEADFC4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock_outline, color: _goldAccent, size: 21),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              _securityText,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF5E5648),
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions({required bool isWide}) {
    final backButton = OutlinedButton(
      onPressed: () => Navigator.maybePop(context),
      style: OutlinedButton.styleFrom(
        foregroundColor: _ink,
        side: const BorderSide(color: _borderColor),
        padding: EdgeInsets.symmetric(
          horizontal: isWide ? 30 : 14,
          vertical: 13,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: const Text(
        'رجوع',
        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
      ),
    );

    final nextButton = ElevatedButton(
      onPressed: _canProceed ? _showReviewDialog : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: _crimsonRed,
        foregroundColor: Colors.white,
        disabledBackgroundColor: _crimsonRed.withValues(alpha: 0.34),
        disabledForegroundColor: Colors.white.withValues(alpha: 0.76),
        elevation: 0,
        padding: EdgeInsets.symmetric(
          horizontal: isWide ? 38 : 18,
          vertical: 13,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: const Text(
        'التالي',
        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
      ),
    );

    if (isWide) {
      return Row(
        textDirection: TextDirection.ltr,
        children: [
          backButton,
          const Spacer(),
          SizedBox(width: 154, child: nextButton),
        ],
      );
    }

    return Container(
      decoration: const BoxDecoration(
        color: _cardBackground,
        border: Border(top: BorderSide(color: _borderColor)),
      ),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
      child: SafeArea(
        top: false,
        child: Row(
          textDirection: TextDirection.ltr,
          children: [
            Expanded(child: backButton),
            const SizedBox(width: 10),
            Expanded(flex: 2, child: nextButton),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentStateIcon(
    DocumentUploadSlotState state,
    DocumentSlotConfig document,
  ) {
    if (state.isComplete) {
      return const Icon(Icons.check_circle, color: _successGreen);
    }

    if (state.isUploading) {
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          value: state.progress / 100,
          strokeWidth: 2.5,
          color: _crimsonRed,
          backgroundColor: const Color(0xFFF1D4D5),
        ),
      );
    }

    return Icon(document.icon, color: _crimsonRed);
  }

  Widget _smallIconButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkResponse(
        onTap: onPressed,
        radius: 18,
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Icon(icon, color: _mutedText, size: 18),
        ),
      ),
    );
  }

  String _documentTitle(DocumentSlotConfig document) {
    return document.required ? '${document.titleAr} *' : document.titleAr;
  }
}
