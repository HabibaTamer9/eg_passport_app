import 'package:eg_passport_app/features/e_passport/presentation/widgets/e_passport_design.dart';
import 'package:eg_passport_app/features/requests/data/passport_request.dart';
import 'package:eg_passport_app/features/requests/presentation/widgets/request_status_badge.dart';
import 'package:flutter/material.dart';

class TrackingTimeline extends StatelessWidget {
  const TrackingTimeline({
    super.key,
    required this.request,
    required this.compact,
  });

  static const List<String> steps = [
    'تم استلام الطلب',
    'قيد المراجعة',
    'تمت الموافقة',
    'تم الإصدار',
  ];

  final PassportRequest request;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          textDirection: TextDirection.rtl,
          children: List.generate(steps.length, (index) {
            return Expanded(
              child: _TimelineMarker(
                color: _stageColor(index),
                lineBeforeColor: _lineColor(index - 1),
                lineAfterColor: _lineColor(index),
                first: index == 0,
                last: index == steps.length - 1,
              ),
            );
          }),
        ),
        const SizedBox(height: 7),
        Row(
          textDirection: TextDirection.rtl,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(steps.length, (index) {
            return Expanded(
              child: Column(
                children: [
                  Text(
                    steps[index],
                    maxLines: compact ? 2 : 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: EPassportTextStyles.body(
                      size: compact ? 9.5 : 10.5,
                      color: _stageColor(index),
                      weight: index == request.currentStageIndex
                          ? FontWeight.w800
                          : FontWeight.w600,
                    ),
                  ),
                  if (request.stageDates[index].isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      request.stageDates[index],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: EPassportTextStyles.body(
                        size: compact ? 8.5 : 9.5,
                        color: EPassportColors.muted,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  Color _stageColor(int index) {
    if (request.status == PassportRequestStatus.rejected) {
      if (index < request.currentStageIndex) return EPassportColors.approved;
      if (index == request.currentStageIndex) return EPassportColors.rejected;
      return EPassportColors.border;
    }

    if (index <= request.currentStageIndex) {
      return requestStatusColor(request.status);
    }
    return EPassportColors.border;
  }

  Color _lineColor(int index) {
    if (index < 0 || index >= steps.length - 1) return Colors.transparent;
    if (request.status == PassportRequestStatus.rejected) {
      if (index < request.currentStageIndex - 1) {
        return EPassportColors.approved;
      }
      if (index == request.currentStageIndex - 1) {
        return EPassportColors.rejected;
      }
      return EPassportColors.border;
    }
    return index < request.currentStageIndex
        ? requestStatusColor(request.status)
        : EPassportColors.border;
  }
}

class _TimelineMarker extends StatelessWidget {
  const _TimelineMarker({
    required this.color,
    required this.lineBeforeColor,
    required this.lineAfterColor,
    required this.first,
    required this.last,
  });

  final Color color;
  final Color lineBeforeColor;
  final Color lineAfterColor;
  final bool first;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final active = color != EPassportColors.border;
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 2,
            color: first ? Colors.transparent : lineBeforeColor,
          ),
        ),
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: active ? color : EPassportColors.surface,
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Icon(
            active ? Icons.check_rounded : Icons.circle,
            size: active ? 13 : 7,
            color: active ? EPassportColors.surface : color,
          ),
        ),
        Expanded(
          child: Container(
            height: 2,
            color: last ? Colors.transparent : lineAfterColor,
          ),
        ),
      ],
    );
  }
}
