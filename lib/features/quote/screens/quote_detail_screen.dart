import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/quote_service.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/models/quote_model.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/glossy_button.dart';

class QuoteDetailScreen extends StatefulWidget {
  final String quoteId;

  const QuoteDetailScreen({super.key, required this.quoteId});

  @override
  State<QuoteDetailScreen> createState() => _QuoteDetailScreenState();
}

class _QuoteDetailScreenState extends State<QuoteDetailScreen> {
  final _quoteService = QuoteService();
  QuoteModel? _quote;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final quote = await _quoteService.getQuote(widget.quoteId);
    setState(() {
      _quote = quote;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_quote == null) {
      return Scaffold(appBar: AppBar(), body: const EmptyState(icon: Icons.receipt_outlined, title: 'Quote not found'));
    }

    final quote = _quote!;
    final isExpired = quote.validUntil.isBefore(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text('Quote from ${quote.vendor?.businessName ?? 'Vendor'}'),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Validity chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isExpired ? const Color(0xFFFFEBEE) : const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isExpired ? Icons.timer_off_outlined : Icons.timer_outlined,
                    size: 14,
                    color: isExpired ? AppColors.error : AppColors.success,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isExpired
                        ? 'Expired on ${Formatters.date(quote.validUntil)}'
                        : 'Valid until ${Formatters.date(quote.validUntil)}',
                    style: AppTextStyles.caption(context).copyWith(
                      color: isExpired ? AppColors.error : AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Line items
            Container(
              decoration: BoxDecoration(
                color: context.c.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: context.c.border),
              ),
              child: Column(
                children: [
                  ...quote.lineItems.asMap().entries.map((entry) {
                    final item = entry.value;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              Expanded(child: Text(item.label, style: AppTextStyles.body2(context))),
                              Text(Formatters.currency(item.amount), style: AppTextStyles.body2(context)),
                            ],
                          ),
                        ),
                        if (entry.key < quote.lineItems.length - 1)
                          const Divider(height: 1),
                      ],
                    );
                  }),
                  const Divider(thickness: 2),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        Text('Total', style: AppTextStyles.heading4(context)),
                        const Spacer(),
                        Text(
                          Formatters.currency(quote.amount),
                          style: AppTextStyles.heading4(context).copyWith(color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (quote.description != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Notes from vendor', style: AppTextStyles.label(context)),
                    const SizedBox(height: 6),
                    Text(
                      quote.description!,
                      style: AppTextStyles.body2(context).copyWith(color: context.c.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
            if (quote.status == 'pending' && !isExpired) ...[
              const SizedBox(height: 32),
              GlossyButton(
                label: 'Accept & Book',
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Accept Quote?'),
                      content: Text('Are you sure you want to accept this quote for ${Formatters.currency(quote.amount)}?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text('Accept & Book'),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await _quoteService.acceptQuote(quote.id);
                    if (!mounted) return;
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Quote accepted! Proceeding to payment.'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                    // ignore: use_build_context_synchronously
                    context.push(AppRoutes.payments);
                  }
                },
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                ),
                onPressed: () async {
                  await _quoteService.rejectQuote(quote.id);
                  if (!mounted) return;
                  // ignore: use_build_context_synchronously
                  context.pop();
                },
                child: const Text('Decline'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
