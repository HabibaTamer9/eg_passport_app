import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:eg_passport_app/features/home/cubit/home_cubit.dart';
import 'package:eg_passport_app/features/home/cubit/home_state.dart';

// ─────────────────────────────────────────────
//  COLOURS  (replace _C.xxx → AppColors.xxx)
// ─────────────────────────────────────────────
class _C {
  static const red = Color(0xFFD32F2F);
  static const lightRed = Color(0xFFFFEBEE);
  static const gold = Color(0xFFD4AF37);
  static const darkCard = Color(0xFF1A2340);
  static const bg = Color(0xFFF5F6FA);
  static const grey = Color(0xFF9E9E9E);
  static const lightGrey = Color(0xFFE0E0E0);
  static const black = Color(0xFF212121);
  static const white = Colors.white;
  static const green = Color(0xFF43A047);
  static const orange = Color(0xFFFF8F00);
}

// ─────────────────────────────────────────────
//  HOME SCREEN
// ─────────────────────────────────────────────
class DigitalPassport extends StatelessWidget {
  const DigitalPassport({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit()
        ..loadHomeData(
          user: const UserModel(
            fullName: 'أحمد محمد علي',
            nationality: 'Egyptian Citizen',
            avatarUrl: null,
          ),
          passport: const PassportModel(
            id: '1',
            applicationNumber: 'EP-2025-00055047',
            qrCodeUrl: '',
            expirySeconds: 169,
          ),
          applicationStatus: const ApplicationStatusModel(
            steps: [
              ApplicationStep(
                  label: 'استلام الطلب', status: StepStatus.done),
              ApplicationStep(
                  label: 'قيد الدراسة', status: StepStatus.done),
              ApplicationStep(
                  label: 'تحت المعالجة', status: StepStatus.active),
              ApplicationStep(
                  label: 'قيد المراجعة', status: StepStatus.pending),
              ApplicationStep(
                  label: 'تم الإصدار', status: StepStatus.pending),
            ],
          ),
          uploadedDocuments: const [
            DocumentModel(
                id: 'doc1', label: 'صورة شخصية', isUploaded: true),
            DocumentModel(
                id: 'doc2', label: 'بطاقة الهوية', isUploaded: true),
          ],
          requiredDocuments: const [
            DocumentModel(
                id: 'doc1', label: 'صورة شخصية', isUploaded: false),
            DocumentModel(
                id: 'doc2', label: 'بطاقة الهوية', isUploaded: false),
            DocumentModel(
                id: 'doc3', label: 'عقد الميلاد', isUploaded: false),
            DocumentModel(
                id: 'doc4', label: 'جواز السفر', isUploaded: false),
            DocumentModel(
                id: 'doc5', label: 'إثبات الإقامة', isUploaded: false),
          ],
        ),
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is HomeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: _C.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is HomeInitial || state is HomeLoading) {
            return const Center(child: CircularProgressIndicator(color: _C.red));
          }
          if (state is HomeError) {
            return Center(
              child: Text(state.message,
                  style: const TextStyle(color: _C.red, fontSize: 14)),
            );
          }

          final data = state as HomeLoaded;
          final isQrRefreshing = state is HomeQrRefreshing;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Greeting
                _GreetingRow(userName: data.user.fullName),
                const SizedBox(height: 14),

                // 2. Digital Passport Card
                _PassportCard(
                  user: data.user,
                  passport: data.passport,
                  isQrRefreshing: isQrRefreshing,
                  onRefreshQr: () => context.read<HomeCubit>().refreshQrCode(),
                ),
                const SizedBox(height: 20),

                // 3. Request Status
                _SectionTitle(title: 'حالة الطلب', showMore: true),
                const SizedBox(height: 10),
                _RequestStepper(steps: data.applicationStatus.steps),
                const SizedBox(height: 20),

                // 4. Quick Actions
                _SectionTitle(title: 'إجراءات سريعة'),
                const SizedBox(height: 10),
                const _QuickActions(),
                const SizedBox(height: 20),

                // 5. Uploaded Documents
                _SectionTitle(title: 'المستندات المرفوعة', showMore: true),
                const SizedBox(height: 10),
                _DocumentsGrid(
                  requiredDocuments: data.requiredDocuments,
                  uploadedDocuments: data.uploadedDocuments,
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  1. GREETING ROW
// ─────────────────────────────────────────────
class _GreetingRow extends StatelessWidget {
  final String userName;
  const _GreetingRow({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text('مرحباً بك 👋',
                style: TextStyle(color: _C.grey, fontSize: 12)),
            const SizedBox(height: 2),
            Text(userName,
                style: const TextStyle(
                    color: _C.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(width: 10),
        const CircleAvatar(
          radius: 22,
          backgroundColor: _C.lightGrey,
          child: Icon(Icons.person, color: _C.grey, size: 26),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  2. DIGITAL PASSPORT CARD
// ─────────────────────────────────────────────
class _PassportCard extends StatelessWidget {
  final UserModel user;
  final PassportModel passport;
  final bool isQrRefreshing;
  final VoidCallback onRefreshQr;

  const _PassportCard({
    required this.user,
    required this.passport,
    required this.isQrRefreshing,
    required this.onRefreshQr,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _C.darkCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _C.darkCard.withOpacity(0.35),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top label bar
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF111827),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _QrWidget(
                  qrUrl: passport.qrCodeUrl,
                  size: 36,
                  isRefreshing: isQrRefreshing,
                ),
                Row(
                  children: const [
                    Icon(Icons.shield_outlined, color: _C.gold, size: 16),
                    SizedBox(width: 6),
                    Text('جواز السفر الرقمي',
                        style: TextStyle(
                            color: _C.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          ),

          // Card body
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Right: info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _cardInfoRow(Icons.person_outline, user.fullName),
                      const SizedBox(height: 6),
                      _cardInfoRow(Icons.flag_outlined, user.nationality),
                      const SizedBox(height: 6),
                      _cardInfoRow(Icons.credit_card_outlined,
                          passport.applicationNumber),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _C.green.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: _C.green, width: 0.8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text('نشط',
                                  style: TextStyle(
                                      color: _C.green,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(width: 4),
                              Icon(Icons.check_circle_outline,
                                  color: _C.green, size: 13),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _CountdownRow(initialSeconds: passport.expirySeconds),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                // Left: avatar + large QR
                Column(
                  children: [
                    Container(
                      width: 72,
                      height: 88,
                      decoration: BoxDecoration(
                        color: _C.lightGrey,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: _C.gold, width: 1.5),
                      ),
                      child: user.avatarUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(7),
                              child: Image.network(
                                user.avatarUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(
                                    Icons.person,
                                    size: 46,
                                    color: _C.grey),
                              ),
                            )
                          : const Icon(Icons.person, size: 46, color: _C.grey),
                    ),
                    const SizedBox(height: 8),
                    _QrWidget(
                      qrUrl: passport.qrCodeUrl,
                      size: 72,
                      isRefreshing: isQrRefreshing,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Refresh QR button
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: SizedBox(
              width: double.infinity,
              height: 38,
              child: ElevatedButton.icon(
                onPressed: isQrRefreshing ? null : onRefreshQr,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _C.red,
                  disabledBackgroundColor: _C.red.withOpacity(0.6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                icon: isQrRefreshing
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: _C.white),
                      )
                    : const Icon(Icons.refresh, color: _C.white, size: 16),
                label: Text(
                  isQrRefreshing ? 'جارٍ التحديث...' : 'تحديث الآن',
                  style: const TextStyle(
                      color: _C.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardInfoRow(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Text(text,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: _C.white, fontSize: 12)),
        ),
        const SizedBox(width: 6),
        Icon(icon, color: _C.gold, size: 15),
      ],
    );
  }
}

// ── QR Widget ──
class _QrWidget extends StatelessWidget {
  final String qrUrl;
  final double size;
  final bool isRefreshing;

  const _QrWidget({
    required this.qrUrl,
    required this.size,
    required this.isRefreshing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: _C.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: isRefreshing
          ? const Center(
              child: CircularProgressIndicator(strokeWidth: 2, color: _C.red))
          : (qrUrl.isNotEmpty
              ? Image.network(
                  qrUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.qr_code_2, color: _C.black),
                )
              : const Icon(Icons.qr_code_2, color: _C.black)),
    );
  }
}

// ── Countdown row ──
class _CountdownRow extends StatefulWidget {
  final int initialSeconds;
  const _CountdownRow({required this.initialSeconds});

  @override
  State<_CountdownRow> createState() => _CountdownRowState();
}

class _CountdownRowState extends State<_CountdownRow> {
  late int _seconds;

  @override
  void initState() {
    super.initState();
    _seconds = widget.initialSeconds;
    _tick();
  }

  void _tick() {
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted || _seconds <= 0) return;
      setState(() => _seconds--);
      _tick();
    });
  }

  String get _formatted {
    final m = _seconds ~/ 60;
    final s = _seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(_formatted,
            style: const TextStyle(
                color: _C.white, fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(width: 4),
        const Icon(Icons.timer_outlined, color: _C.gold, size: 14),
        const SizedBox(width: 4),
        const Text('صالح خلال', style: TextStyle(color: _C.grey, fontSize: 11)),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  3. REQUEST STEPPER  (dynamic from API)
// ─────────────────────────────────────────────
class _RequestStepper extends StatelessWidget {
  final List<ApplicationStep> steps;
  const _RequestStepper({required this.steps});

  @override
  Widget build(BuildContext context) {
    if (steps.isEmpty) return const SizedBox();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: BoxDecoration(
        color: _C.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: List.generate(steps.length, (i) {
          final isLast = i == steps.length - 1;
          return Expanded(
            child: Row(
              children: [
                Expanded(child: _StepItem(step: steps[i])),
                if (!isLast)
                  Expanded(
                    child: Container(
                      height: 2,
                      color: steps[i].status == StepStatus.done
                          ? _C.red
                          : _C.lightGrey,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final ApplicationStep step;
  const _StepItem({required this.step});

  @override
  Widget build(BuildContext context) {
    Color circleColor;
    Widget circleChild;

    switch (step.status) {
      case StepStatus.done:
        circleColor = _C.red;
        circleChild = const Icon(Icons.check, color: _C.white, size: 13);
        break;
      case StepStatus.active:
        circleColor = _C.orange;
        circleChild = const Icon(Icons.access_time, color: _C.white, size: 13);
        break;
      case StepStatus.pending:
        circleColor = _C.lightGrey;
        circleChild = const SizedBox();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(color: circleColor, shape: BoxShape.circle),
          child: Center(child: circleChild),
        ),
        const SizedBox(height: 4),
        Text(
          step.label,
          textAlign: TextAlign.center,
          maxLines: 2,
          style: TextStyle(
            fontSize: 9,
            color: step.status == StepStatus.active ? _C.orange : _C.grey,
            fontWeight: step.status == StepStatus.active
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  4. QUICK ACTIONS  (clickable, routes TBD)
// ─────────────────────────────────────────────
class _QuickActions extends StatelessWidget {
  const _QuickActions();

  static const List<_ActionItem> _items = [
    _ActionItem(icon: Icons.qr_code_scanner, label: 'عرض QR', route: null),
    _ActionItem(
        icon: Icons.folder_copy_outlined, label: 'التفاصيل', route: null),
    _ActionItem(
        icon: Icons.picture_as_pdf_outlined, label: 'تحميل PDF', route: null),
    _ActionItem(
        icon: Icons.support_agent_outlined, label: 'مساندة', route: null),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:
          _items.map((a) => Expanded(child: _ActionTile(item: a))).toList(),
    );
  }
}

class _ActionItem {
  final IconData icon;
  final String label;
  final String? route; // TODO: fill in named routes
  const _ActionItem(
      {required this.icon, required this.label, required this.route});
}

class _ActionTile extends StatelessWidget {
  final _ActionItem item;
  const _ActionTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: () {
          if (item.route != null) {
            Navigator.pushNamed(context, item.route!);
          }
        },
        borderRadius: BorderRadius.circular(14),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: _C.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 8,
                      offset: const Offset(0, 2))
                ],
              ),
              child: Icon(item.icon, color: _C.red, size: 26),
            ),
            const SizedBox(height: 6),
            Text(item.label,
                style: const TextStyle(fontSize: 11, color: _C.black)),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  5. DOCUMENTS GRID  (data from document_upload screen)
// ─────────────────────────────────────────────
class _DocumentsGrid extends StatelessWidget {
  final List<DocumentModel> requiredDocuments;
  final List<DocumentModel> uploadedDocuments;

  const _DocumentsGrid({
    required this.requiredDocuments,
    required this.uploadedDocuments,
  });

  @override
  Widget build(BuildContext context) {
    final uploadedIds = uploadedDocuments.map((d) => d.id).toSet();

    final merged = requiredDocuments.map((doc) {
      final isUploaded = doc.isUploaded || uploadedIds.contains(doc.id);
      return DocumentModel(
        id: doc.id,
        label: doc.label,
        isUploaded: isUploaded,
        fileUrl: doc.fileUrl,
      );
    }).toList();

    if (merged.isEmpty) {
      return const Center(
        child: Text('لا توجد مستندات مطلوبة',
            style: TextStyle(color: _C.grey, fontSize: 13)),
      );
    }

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: merged.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (_, i) => _DocTile(doc: merged[i]),
    );
  }
}

class _DocTile extends StatelessWidget {
  final DocumentModel doc;
  const _DocTile({required this.doc});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: doc.isUploaded ? _C.lightRed : _C.lightGrey,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: doc.isUploaded ? _C.red : _C.lightGrey, width: 1),
              ),
              child: doc.fileUrl != null && doc.isUploaded
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(9),
                      child: Image.network(
                        doc.fileUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                            Icons.insert_drive_file_outlined,
                            color: doc.isUploaded ? _C.red : _C.grey,
                            size: 28),
                      ),
                    )
                  : Icon(Icons.insert_drive_file_outlined,
                      color: doc.isUploaded ? _C.red : _C.grey, size: 28),
            ),
            if (doc.isUploaded)
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    color: _C.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: _C.white, size: 10),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          doc.label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 9, color: _C.black),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  HELPER WIDGETS
// ─────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String title;
  final bool showMore;
  const _SectionTitle({required this.title, this.showMore = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (showMore)
          GestureDetector(
            onTap: () {
              // TODO: navigate to full list screen
            },
            child: const Text('عرض الكل',
                style: TextStyle(
                    color: _C.red, fontSize: 12, fontWeight: FontWeight.w500)),
          )
        else
          const SizedBox(),
        Text(title,
            style: const TextStyle(
                color: _C.black, fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
