import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

class AmountText extends StatelessWidget {
  const AmountText(
    this.amount, {
    super.key,
    this.style,
    this.prefix = '',
    this.color,
    this.showDecimals = false,
  });

  final num amount;
  final TextStyle? style;
  final String prefix;
  final Color? color;
  final bool showDecimals;

  String get formatted {
    return NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: showDecimals ? 2 : 0,
    ).format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '$prefix$formatted',
      style: (style ?? AppTextStyles.amountMedium).copyWith(
        color: color ?? AppColors.textPrimary,
      ),
    );
  }
}
