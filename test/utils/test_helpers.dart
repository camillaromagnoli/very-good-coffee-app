import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:very_good_coffee_app/l10n/app_localizations.dart';

Widget createTestWidget({required Widget child, List<GoRoute>? routes}) {
  final localizationsDelegates = const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  if (routes != null) {
    return MaterialApp.router(
      routerConfig: GoRouter(routes: routes),
      localizationsDelegates: localizationsDelegates,
      supportedLocales: const [Locale('en', '')],
    );
  }

  return MaterialApp(
    home: child,
    localizationsDelegates: localizationsDelegates,
    supportedLocales: const [Locale('en', '')],
  );
}
