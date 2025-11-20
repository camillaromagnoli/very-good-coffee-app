import 'package:flutter/material.dart';
import 'package:very_good_coffee_app/l10n/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
