import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// Title shown in the AppBar of the Coffee Page
  ///
  /// In en, this message translates to:
  /// **'Very Good Coffee'**
  String get coffeePageTitle;

  /// Title shown in the AppBar of the Favorites Page
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favoritesPageTitle;

  /// Title shown in the AppBar of the Coffee Viewer Page
  ///
  /// In en, this message translates to:
  /// **'Coffee'**
  String get coffeeViewerPageTitle;

  /// Label for the button that loads a new random coffee
  ///
  /// In en, this message translates to:
  /// **'New Coffee'**
  String get newCoffeeButton;

  /// Label for the button that saves the current coffee to favorites
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButton;

  /// Label for the retry button when an error occurs
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryButton;

  /// Message shown when a coffee is successfully saved to favorites
  ///
  /// In en, this message translates to:
  /// **'Saved to favorites'**
  String get savedToFavorites;

  /// Error message shown when an image fails to display
  ///
  /// In en, this message translates to:
  /// **'Failed to display image'**
  String get failedToDisplayImage;

  /// Message shown when no coffee is loaded yet
  ///
  /// In en, this message translates to:
  /// **'No coffee yet. Try loading one!'**
  String get noCoffeeYet;

  /// Message shown when there are no saved favorite coffees
  ///
  /// In en, this message translates to:
  /// **'No favorites yet.\nSave coffees you like to see them here.'**
  String get noFavoritesYet;

  /// Generic error message when loading coffee fails
  ///
  /// In en, this message translates to:
  /// **'Something went wrong loading coffee.'**
  String get errorLoadingCoffee;

  /// Generic error message when loading favorites fails
  ///
  /// In en, this message translates to:
  /// **'Something went wrong loading favorites.'**
  String get errorLoadingFavorites;

  /// Error message when saving coffee fails
  ///
  /// In en, this message translates to:
  /// **'Failed to save coffee. Please try again.'**
  String get errorSavingCoffee;

  /// Message shown when the user is offline
  ///
  /// In en, this message translates to:
  /// **'It seems like you\'re offline. You can still access your favorite coffee images.'**
  String get offlineMessage;

  /// Button label to navigate to favorites page
  ///
  /// In en, this message translates to:
  /// **'View Favorites'**
  String get viewFavoritesButton;

  /// Generic error message for unexpected errors
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get unexpectedError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
