import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

/// Logo textual QBonita — até você adicionar imagem em assets.
class QBonitaLogo extends StatelessWidget {
  const QBonitaLogo({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final prefix = TextStyle(
      fontSize: compact ? 20 : 24,
      fontWeight: FontWeight.w800,
      color: AppTheme.primaryPink,
      letterSpacing: -0.5,
    );
    final suffix = TextStyle(
      fontSize: compact ? 20 : 24,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF374151),
      letterSpacing: -0.5,
    );
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: 'Q', style: prefix),
          TextSpan(text: 'Bonita', style: suffix),
        ],
      ),
    );
  }
}
