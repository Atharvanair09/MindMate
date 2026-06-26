import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi')
  ];

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'HOME'**
  String get navHome;

  /// No description provided for @navChat.
  ///
  /// In en, this message translates to:
  /// **'CHAT'**
  String get navChat;

  /// No description provided for @navJournal.
  ///
  /// In en, this message translates to:
  /// **'JOURNAL'**
  String get navJournal;

  /// No description provided for @navMessages.
  ///
  /// In en, this message translates to:
  /// **'MESSAGES'**
  String get navMessages;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'PROFILE'**
  String get navProfile;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'PROFILE'**
  String get profileTitle;

  /// No description provided for @systemSettings.
  ///
  /// In en, this message translates to:
  /// **'SYSTEM SETTINGS'**
  String get systemSettings;

  /// No description provided for @emergencyHotline.
  ///
  /// In en, this message translates to:
  /// **'EMERGENCY HOTLINE: 988 // ALWAYS AVAILABLE'**
  String get emergencyHotline;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'UNKNOWN'**
  String get unknown;

  /// No description provided for @enrolledDate.
  ///
  /// In en, this message translates to:
  /// **'ENROLLED: SEPT 2024'**
  String get enrolledDate;

  /// No description provided for @securityClearance.
  ///
  /// In en, this message translates to:
  /// **'SECURITY CLEARANCE'**
  String get securityClearance;

  /// No description provided for @clearanceLevel.
  ///
  /// In en, this message translates to:
  /// **'LEVEL 03 - VETERAN'**
  String get clearanceLevel;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'VERIFIED'**
  String get verified;

  /// No description provided for @privacyTitle.
  ///
  /// In en, this message translates to:
  /// **'PRIVACY (ON-DEVICE ONLY)'**
  String get privacyTitle;

  /// No description provided for @privacySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Encryption protocol: RSA-4096'**
  String get privacySubtitle;

  /// No description provided for @dataStorageTitle.
  ///
  /// In en, this message translates to:
  /// **'DATA Storage (RAW)'**
  String get dataStorageTitle;

  /// No description provided for @dataStorageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Format: .JSON / .CSV'**
  String get dataStorageSubtitle;

  /// No description provided for @resetIdentityTitle.
  ///
  /// In en, this message translates to:
  /// **'RESET IDENTITY'**
  String get resetIdentityTitle;

  /// No description provided for @resetIdentitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Warning: IRREVERSIBLE ACTION'**
  String get resetIdentitySubtitle;

  /// No description provided for @focusTime.
  ///
  /// In en, this message translates to:
  /// **'FOCUS TIME'**
  String get focusTime;

  /// No description provided for @moodScoreTitle.
  ///
  /// In en, this message translates to:
  /// **'MOOD SCORE'**
  String get moodScoreTitle;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'LOGOUT'**
  String get logout;

  /// No description provided for @logOutDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'LOG OUT?'**
  String get logOutDialogTitle;

  /// No description provided for @logOutDialogContent.
  ///
  /// In en, this message translates to:
  /// **'You\'ll need your recovery phrase to log back in. Make sure you have it saved.'**
  String get logOutDialogContent;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'CANCEL'**
  String get cancel;

  /// No description provided for @logOutConfirm.
  ///
  /// In en, this message translates to:
  /// **'LOG OUT'**
  String get logOutConfirm;

  /// No description provided for @languageTitle.
  ///
  /// In en, this message translates to:
  /// **'LANGUAGE'**
  String get languageTitle;

  /// No description provided for @languageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageSubtitle;

  /// No description provided for @languageSelectorTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get languageSelectorTitle;

  /// No description provided for @splashSubtitle1.
  ///
  /// In en, this message translates to:
  /// **'AN HONEST COMPANION.'**
  String get splashSubtitle1;

  /// No description provided for @splashSubtitle2.
  ///
  /// In en, this message translates to:
  /// **'NO PRETENDING.'**
  String get splashSubtitle2;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'GET STARTED'**
  String get getStarted;

  /// No description provided for @restoreAccess.
  ///
  /// In en, this message translates to:
  /// **'RESTORE ACCESS'**
  String get restoreAccess;

  /// No description provided for @anonymityFirst.
  ///
  /// In en, this message translates to:
  /// **'ANONYMITY FIRST'**
  String get anonymityFirst;

  /// No description provided for @secureAuth.
  ///
  /// In en, this message translates to:
  /// **'SECURE AUTH'**
  String get secureAuth;

  /// No description provided for @homeHowAreYouFeeling.
  ///
  /// In en, this message translates to:
  /// **'HOW ARE YOU FEELING?'**
  String get homeHowAreYouFeeling;

  /// No description provided for @homeBurnoutRisk.
  ///
  /// In en, this message translates to:
  /// **'BURNOUT RISK'**
  String get homeBurnoutRisk;

  /// No description provided for @homeStudentResources.
  ///
  /// In en, this message translates to:
  /// **'STUDENT RESOURCES'**
  String get homeStudentResources;

  /// No description provided for @homeBurnoutRiskCalc.
  ///
  /// In en, this message translates to:
  /// **'CALC...'**
  String get homeBurnoutRiskCalc;

  /// No description provided for @homeReflectionFollowUp.
  ///
  /// In en, this message translates to:
  /// **'✨ REFLECTION FOLLOW-UP'**
  String get homeReflectionFollowUp;

  /// No description provided for @homeTellMeMore.
  ///
  /// In en, this message translates to:
  /// **'TELL ME MORE'**
  String get homeTellMeMore;

  /// No description provided for @homeKeepCurrentMood.
  ///
  /// In en, this message translates to:
  /// **'KEEP CURRENT MOOD'**
  String get homeKeepCurrentMood;

  /// No description provided for @homeDismiss.
  ///
  /// In en, this message translates to:
  /// **'DISMISS'**
  String get homeDismiss;

  /// No description provided for @homeSaveContext.
  ///
  /// In en, this message translates to:
  /// **'SAVE CONTEXT'**
  String get homeSaveContext;

  /// No description provided for @homeChangeMood.
  ///
  /// In en, this message translates to:
  /// **'CHANGE MOOD'**
  String get homeChangeMood;

  /// No description provided for @homeTodaysMood.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Mood:'**
  String get homeTodaysMood;

  /// No description provided for @homeTypeContext.
  ///
  /// In en, this message translates to:
  /// **'Type optional context...'**
  String get homeTypeContext;

  /// No description provided for @wellnessScore.
  ///
  /// In en, this message translates to:
  /// **'WELLNESS SCORE'**
  String get wellnessScore;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'TODAY'**
  String get today;

  /// No description provided for @dailyCheckIn.
  ///
  /// In en, this message translates to:
  /// **'DAILY CHECK-IN'**
  String get dailyCheckIn;

  /// No description provided for @logMood.
  ///
  /// In en, this message translates to:
  /// **'LOG MOOD'**
  String get logMood;

  /// No description provided for @viewLogs.
  ///
  /// In en, this message translates to:
  /// **'VIEW LOGS'**
  String get viewLogs;

  /// No description provided for @weeklyReflection.
  ///
  /// In en, this message translates to:
  /// **'WEEKLY REFLECTION'**
  String get weeklyReflection;

  /// No description provided for @generateNewReflection.
  ///
  /// In en, this message translates to:
  /// **'GENERATE NEW REFLECTION'**
  String get generateNewReflection;

  /// No description provided for @dominantThemes.
  ///
  /// In en, this message translates to:
  /// **'DOMINANT THEMES'**
  String get dominantThemes;

  /// No description provided for @keyInsights.
  ///
  /// In en, this message translates to:
  /// **'KEY INSIGHTS'**
  String get keyInsights;

  /// No description provided for @actionableAdvice.
  ///
  /// In en, this message translates to:
  /// **'ACTIONABLE ADVICE'**
  String get actionableAdvice;

  /// No description provided for @wellnessTimeline.
  ///
  /// In en, this message translates to:
  /// **'WELLNESS TIMELINE'**
  String get wellnessTimeline;

  /// No description provided for @moodDistribution.
  ///
  /// In en, this message translates to:
  /// **'MOOD DISTRIBUTION'**
  String get moodDistribution;

  /// No description provided for @moodTrends.
  ///
  /// In en, this message translates to:
  /// **'MOOD TRENDS'**
  String get moodTrends;

  /// No description provided for @chatHistoryFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load history'**
  String get chatHistoryFailed;

  /// No description provided for @voiceCallingDisabled.
  ///
  /// In en, this message translates to:
  /// **'Voice calling is temporarily disabled.'**
  String get voiceCallingDisabled;

  /// No description provided for @microphonePermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission is required for voice calls.'**
  String get microphonePermissionRequired;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'ERROR'**
  String get errorTitle;

  /// No description provided for @chatNotFound.
  ///
  /// In en, this message translates to:
  /// **'Chat not found.'**
  String get chatNotFound;

  /// No description provided for @journalNotFound.
  ///
  /// In en, this message translates to:
  /// **'Journal not found.'**
  String get journalNotFound;

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'RENAME'**
  String get rename;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'DELETE'**
  String get delete;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'SAVE'**
  String get save;

  /// No description provided for @renameChatTitle.
  ///
  /// In en, this message translates to:
  /// **'RENAME CHAT'**
  String get renameChatTitle;

  /// No description provided for @deleteChatTitle.
  ///
  /// In en, this message translates to:
  /// **'DELETE CHAT?'**
  String get deleteChatTitle;

  /// No description provided for @actionCannotBeUndone.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get actionCannotBeUndone;

  /// No description provided for @fontStyle.
  ///
  /// In en, this message translates to:
  /// **'Font Style'**
  String get fontStyle;

  /// No description provided for @fontSize.
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get fontSize;

  /// No description provided for @journalCreationComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Journal creation coming soon.'**
  String get journalCreationComingSoon;

  /// No description provided for @couldNotOpenGallery.
  ///
  /// In en, this message translates to:
  /// **'Could not open gallery.'**
  String get couldNotOpenGallery;

  /// No description provided for @usernameCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Username cannot be empty'**
  String get usernameCannotBeEmpty;

  /// No description provided for @uploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Upload failed'**
  String get uploadFailed;

  /// No description provided for @syncFailed.
  ///
  /// In en, this message translates to:
  /// **'Sync failed'**
  String get syncFailed;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageHindi.
  ///
  /// In en, this message translates to:
  /// **'हिन्दी'**
  String get languageHindi;

  /// No description provided for @moodGreat.
  ///
  /// In en, this message translates to:
  /// **'GREAT'**
  String get moodGreat;

  /// No description provided for @moodGood.
  ///
  /// In en, this message translates to:
  /// **'GOOD'**
  String get moodGood;

  /// No description provided for @moodOkay.
  ///
  /// In en, this message translates to:
  /// **'OKAY'**
  String get moodOkay;

  /// No description provided for @moodLow.
  ///
  /// In en, this message translates to:
  /// **'LOW'**
  String get moodLow;

  /// No description provided for @moodBad.
  ///
  /// In en, this message translates to:
  /// **'BAD'**
  String get moodBad;

  /// No description provided for @wellnessScoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Wellness Score'**
  String get wellnessScoreTitle;

  /// No description provided for @lowRisk.
  ///
  /// In en, this message translates to:
  /// **'LOW RISK'**
  String get lowRisk;

  /// No description provided for @doingWell.
  ///
  /// In en, this message translates to:
  /// **'Doing well this week 🌱'**
  String get doingWell;

  /// No description provided for @todaysCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Check-in'**
  String get todaysCheckIn;

  /// No description provided for @reflect.
  ///
  /// In en, this message translates to:
  /// **'REFLECT'**
  String get reflect;

  /// No description provided for @whatsWeighing.
  ///
  /// In en, this message translates to:
  /// **'\"What\'s weighing on your mind today?\"'**
  String get whatsWeighing;

  /// No description provided for @writeItOut.
  ///
  /// In en, this message translates to:
  /// **'Write it out'**
  String get writeItOut;
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
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
