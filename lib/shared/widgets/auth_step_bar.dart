import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AuthStepBar extends StatelessWidget {
  final int step;
  final int total;

  const AuthStepBar({super.key, required this.step, this.total = 6});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: Row(
        children: List.generate(total, (i) {
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(left: i == 0 ? 0 : 5),
              height: 4,
              decoration: BoxDecoration(
                color: i < step ? AppColors.primary : const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }
}
