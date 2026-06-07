import 'package:eg_passport_app/features/e_passport/presentation/widgets/e_passport_design.dart';
import 'package:eg_passport_app/features/requests/data/passport_request.dart';
import 'package:eg_passport_app/features/requests/presentation/widgets/passport_cover_card.dart';
import 'package:eg_passport_app/features/requests/presentation/widgets/rejection_reason_box.dart';
import 'package:eg_passport_app/features/requests/presentation/widgets/request_status_badge.dart';
import 'package:eg_passport_app/features/requests/presentation/widgets/tracking_timeline.dart';
import 'package:flutter/material.dart';

class RequestCard extends StatefulWidget {
  const RequestCard({super.key, required this.request});

  final PassportRequest request;

  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 680;
        return Container(
          padding: EdgeInsets.all(compact ? 13 : 16),
          decoration: BoxDecoration(
            color: EPassportColors.surface,
            border: Border.all(color: EPassportColors.border),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.035),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: compact ? _buildMobile() : _buildDesktop(),
        );
      },
    );
  }

  Widget _buildDesktop() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            RequestStatusBadge(status: widget.request.status),
            const Spacer(),
            _ExpandToggle(
              expanded: _expanded,
              onTap: () => setState(() => _expanded = !_expanded),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 92, child: PassportCoverCard()),
            const SizedBox(width: 22),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.request.title,
                    textAlign: TextAlign.center,
                    style: EPassportTextStyles.title(18),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    widget.request.passportType,
                    textAlign: TextAlign.center,
                    style: EPassportTextStyles.body(
                      size: 12,
                      color: EPassportColors.muted,
                      weight: FontWeight.w600,
                    ),
                  ),
                  if (_expanded) ...[
                    const SizedBox(height: 20),
                    TrackingTimeline(request: widget.request, compact: false),
                    if (widget.request.rejectionReason != null) ...[
                      const SizedBox(height: 13),
                      RejectionReasonBox(
                        reason: widget.request.rejectionReason!,
                      ),
                    ],
                  ],
                ],
              ),
            ),
            const SizedBox(width: 22),
            _RequestMetaPanel(request: widget.request),
          ],
        ),
      ],
    );
  }

  Widget _buildMobile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          textDirection: TextDirection.rtl,
          children: [
            RequestStatusBadge(status: widget.request.status),
            const Spacer(),
            _ExpandToggle(
              expanded: _expanded,
              onTap: () => setState(() => _expanded = !_expanded),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: TextDirection.rtl,
          children: [
            SizedBox(
              width: 76,
              child: PassportCoverCard(compact: true),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.request.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: EPassportTextStyles.body(
                      size: 12.5,
                      weight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.request.passportType,
                    textAlign: TextAlign.right,
                    style: EPassportTextStyles.body(
                      size: 11,
                      color: EPassportColors.muted,
                      weight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 9),
                  _RequestMetaText(request: widget.request),
                ],
              ),
            ),
          ],
        ),
        if (_expanded) ...[
          const SizedBox(height: 16),
          TrackingTimeline(request: widget.request, compact: true),
          if (widget.request.rejectionReason != null) ...[
            const SizedBox(height: 12),
            RejectionReasonBox(
              reason: widget.request.rejectionReason!,
              compact: true,
            ),
          ],
        ],
      ],
    );
  }
}

class _ExpandToggle extends StatelessWidget {
  const _ExpandToggle({required this.expanded, required this.onTap});

  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      tooltip: expanded ? 'إخفاء التفاصيل' : 'عرض التفاصيل',
      icon: Icon(
        expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
        color: EPassportColors.muted,
        size: 24,
      ),
    );
  }
}

class _RequestMetaPanel extends StatelessWidget {
  const _RequestMetaPanel({required this.request});

  final PassportRequest request;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 178,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(right: BorderSide(color: EPassportColors.border)),
      ),
      child: _RequestMetaText(request: request),
    );
  }
}

class _RequestMetaText extends StatelessWidget {
  const _RequestMetaText({required this.request});

  final PassportRequest request;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'رقم الطلب:',
          textAlign: TextAlign.right,
          style: EPassportTextStyles.body(
            size: 10.5,
            color: EPassportColors.muted,
            weight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          request.requestNumber,
          textAlign: TextAlign.right,
          style: EPassportTextStyles.body(
            size: 12,
            color: EPassportColors.ink,
            weight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'تاريخ التقديم:',
          textAlign: TextAlign.right,
          style: EPassportTextStyles.body(
            size: 10.5,
            color: EPassportColors.muted,
            weight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          request.submittedAt,
          textAlign: TextAlign.right,
          style: EPassportTextStyles.body(
            size: 11.5,
            color: EPassportColors.ink,
            weight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
