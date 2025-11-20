// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get coffeePageTitle => 'Very Good Coffee';

  @override
  String get favoritesPageTitle => 'Favorites';

  @override
  String get coffeeViewerPageTitle => 'Coffee';

  @override
  String get newCoffeeButton => 'New Coffee';

  @override
  String get saveButton => 'Save';

  @override
  String get retryButton => 'Retry';

  @override
  String get savedToFavorites => 'Saved to favorites';

  @override
  String get failedToDisplayImage => 'Failed to display image';

  @override
  String get noCoffeeYet => 'No coffee yet. Try loading one!';

  @override
  String get noFavoritesYet =>
      'No favorites yet.\nSave coffees you like to see them here.';

  @override
  String get errorLoadingCoffee => 'Something went wrong loading coffee.';

  @override
  String get errorLoadingFavorites => 'Something went wrong loading favorites.';

  @override
  String get errorSavingCoffee => 'Failed to save coffee. Please try again.';

  @override
  String get offlineMessage =>
      'It seems like you\'re offline. You can still access your favorite coffee images.';

  @override
  String get viewFavoritesButton => 'View Favorites';

  @override
  String get unexpectedError =>
      'An unexpected error occurred. Please try again.';
}
