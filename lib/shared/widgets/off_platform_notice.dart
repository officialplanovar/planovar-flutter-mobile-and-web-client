import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

/// Small amber banner reminding the user that payment is arranged directly
/// with the vendor, off-platform. Rendered wherever a quote/invoice/schedule
/// is shown so the off-platform model is unmistakable.
class OffPlatformPaymentNotice extends StatelessWidget {
  final EdgeInsetsGeometry margin;

  const OffPlatformPaymentNotice({super.key, this.margin = EdgeInsets.zero});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Container(
      margin: margin,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, size: 16, color: Color(0xFF92400E)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              t.paymentArrangedNotice,
              style: const TextStyle(fontSize: 12.5, color: Color(0xFF92400E), height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
