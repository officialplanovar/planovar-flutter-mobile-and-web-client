import 'package:flutter/material.dart';
import '../../../core/mock/mock_payment_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/models/transaction_model.dart';
import '../../../shared/widgets/shimmer_list.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/status_chip.dart';
import '../../../core/utils/formatters.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  final _paymentService = MockPaymentService();
  List<TransactionModel> _transactions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final txns = await _paymentService.getTransactions();
    setState(() {
      _transactions = txns;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payments')),
      body: _loading
          ? const Padding(padding: EdgeInsets.all(16), child: ShimmerList(itemCount: 3))
          : _transactions.isEmpty
              ? const EmptyState(icon: Icons.payment_outlined, title: 'No payments yet')
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _transactions.length,
                  itemBuilder: (context, i) {
                    return _TransactionCard(transaction: _transactions[i]);
                  },
                ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final TransactionModel transaction;

  const _TransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isPayment = transaction.type == 'payment';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isPayment ? AppColors.primaryLight : const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isPayment ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
              color: isPayment ? AppColors.primary : AppColors.success,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isPayment ? 'Payment' : 'Refund',
                  style: AppTextStyles.label,
                ),
                Text(
                  'Booking #${transaction.bookingId.substring(transaction.bookingId.length - 3)}',
                  style: AppTextStyles.caption,
                ),
                Text(Formatters.date(transaction.createdAt), style: AppTextStyles.caption),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                Formatters.currency(transaction.amount),
                style: AppTextStyles.label.copyWith(
                  color: isPayment ? AppColors.textPrimary : AppColors.success,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              StatusChip(status: transaction.status),
            ],
          ),
        ],
      ),
    );
  }
}
