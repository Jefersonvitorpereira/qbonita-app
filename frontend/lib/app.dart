import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_theme.dart';
import 'presentation/shell/main_shell.dart';

/// Raiz do aplicativo: tema, localização pt-BR e tela principal com menu inferior.
class QBonitaApp extends StatelessWidget {
  const QBonitaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QBonita',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [Locale('pt', 'BR')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const MainShell(),
    );
  }
}
