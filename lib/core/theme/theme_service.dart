import 'package:flutter/material.dart';

class ThemeService extends ChangeNotifier {
  static final ThemeService _instance = ThemeService._internal();

  factory ThemeService() {
    return _instance;
  }

  ThemeService._internal();

  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void toggleTheme() {
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  // BACKGROUND
  Color get dialogBackgroundColor =>
    isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFF6E9E1);

Color get inputFillColor =>
    isDarkMode ? const Color(0xFF2A2A2A) : const Color(0xFFFFF7F0);

Color get inputBorderColor =>
    isDarkMode ? Colors.grey.shade600 : Colors.grey.shade500;
  Color get backgroundColor =>
      isDarkMode ? const Color(0xFF121212) : const Color(0xFFF6E9E1);

  Color get cardColor =>
      isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;

  Color get secondaryColor =>
      isDarkMode ? const Color(0xFF2A2A2A) : const Color(0xFFFFE0C6);
  
// Q-CONSUL
Color get consulSearchColor =>
    isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;

Color get consulCardColor =>
    isDarkMode ? const Color(0xFF243447) : const Color(0xFFD7EAF8);

Color get consulButtonColor =>
    isDarkMode ? const Color(0xFF314A5F) : const Color(0xFFFFEFD6);

Color get consulAvatarColor =>
    isDarkMode ? const Color(0xFF1A2633) : Colors.white;

Color get consulShadowColor =>
    isDarkMode ? Colors.black.withOpacity(0.35) : Colors.black12;

// Q-QUOTES
Color get quotesCardColor =>
    isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;

Color get quotesControlColor =>
    isDarkMode ? const Color(0xFF243447) : const Color(0xFF1976D2);

Color get quotesButtonColor =>
    isDarkMode ? const Color(0xFF314A5F) : Colors.white;

Color get quotesButtonIconColor =>
    isDarkMode ? Colors.white : const Color(0xFF1976D2);

Color get quotesSliderInactive =>
    isDarkMode ? Colors.white24 : Colors.white30;

// Q-TIPS
Color get tipsHeaderCardColor =>
    isDarkMode ? const Color(0xFF243447) : const Color(0xFFFFEFD6);

Color get tipsIntroSadColor =>
    isDarkMode ? const Color(0xFF1F3547) : const Color.fromARGB(255, 184, 218, 242);

Color get tipsIntroAngryColor =>
    isDarkMode ? const Color(0xFF4A2C33) : const Color(0xFFF2BDC3);

Color get tipsIntroCalmColor =>
    isDarkMode ? const Color(0xFF243D32) : const Color.fromARGB(255, 188, 242, 205);

Color get tipsAyatCardColor =>
    isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;

Color get tipsShortcutColor =>
    isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;

Color get tipsShortcutIconBg =>
    isDarkMode ? const Color(0xFF314A5F) : const Color(0xFFE3F2FD);

  // PRIMARY
  Color get primaryColor =>
      isDarkMode ? const Color(0xFFFFC59E) : const Color(0xFFFF8A5B);

  Color get buttonColor =>
      isDarkMode ? const Color(0xFFFFC59E) : const Color(0xFFFF8A5B);

  Color get buttonTextColor =>
      isDarkMode ? Colors.black : Colors.white;

  // TEXT
  Color get textPrimaryColor =>
      isDarkMode ? Colors.white : const Color(0xFF1F1B18);

  Color get textSecondaryColor =>
      isDarkMode ? Colors.grey.shade400 : Colors.black54;

  Color get hintTextColor =>
      isDarkMode ? Colors.grey.shade500 : Colors.grey.shade600;

  // ICON
  Color get iconColor =>
      isDarkMode ? Colors.white : const Color(0xFF1F1B18);

  Color get iconSoftColor =>
      isDarkMode ? const Color(0xFFFFC59E) : const Color(0xFFFF8A5B);
  
  // INFO SHEET
Color get infoSheetBackground =>
    isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFF6E9E1);

Color get infoSheetIconColor =>
    isDarkMode ? const Color(0xFFFFC59E) : const Color(0xFFFF8A5B);

Color get infoSheetButtonColor =>
    isDarkMode ? const Color(0xFFFF8A5B) : const Color(0xFFFF8A5B);

Color get infoSheetButtonText =>
    isDarkMode ? Colors.black : Colors.white;

  // BORDER
  Color get borderColor =>
      isDarkMode ? Colors.grey.shade700 : Colors.grey.shade400;

  // MOOD
  Color get moodGoodColor =>
      isDarkMode ? const Color(0xFF1B3D2A) : const Color(0xFFE8F5E9);

  Color get moodBadColor =>
      isDarkMode ? const Color(0xFF4A1F1F) : const Color(0xFFFFEBEE);

  Color get moodNeutralColor =>
      isDarkMode ? const Color(0xFF2A2A2A) : const Color(0xFFFFEFD6);

  // CHECKER
  Color get checkerBoxColor =>
      isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFFFE0C6);

  Color get checkerInputColor =>
      isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;

  Color get checkerResultGood =>
      isDarkMode ? Colors.greenAccent : Colors.green;

  Color get checkerResultBad =>
      isDarkMode ? Colors.redAccent : Colors.red;

  Color get checkerResultWarning =>
      isDarkMode ? Colors.orangeAccent : Colors.orange;

  // ARTICLE
  Color get articlePlaceholderColor =>
      isDarkMode ? const Color(0xFF2A2A2A) : const Color(0xFFD6EAF8);

  Color get articleIndicatorActive =>
      isDarkMode ? const Color(0xFFFFC59E) : const Color(0xFFFF8A5B);

  Color get articleIndicatorInactive =>
      isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400;

  // HOME
Color get homeMenuBoxColor =>
    isDarkMode ? const Color(0xFF3A3A3A) : const Color(0xFFE5E5E5);

Color get homeMoodEmptyBoxColor =>
    isDarkMode ? const Color(0xFF3A3A3A) : const Color(0xFFE5E5E5);

Color get homeMoodTodayBorderColor =>
    isDarkMode ? const Color(0xFFFFC59E) : const Color(0xFFFF8A5B);

// BOTTOM NAV
Color get bottomNavColor =>
    isDarkMode ? const Color(0xFF58A6F0) : const Color(0xFF58A6F0);

Color get bottomNavActiveIconColor =>
    Colors.white;

Color get bottomNavInactiveIconColor =>
    isDarkMode ? Colors.white54 : Colors.white.withOpacity(0.5);

Color get bottomNavShadowColor =>
    isDarkMode ? const Color(0xFFB3E5FC) : const Color(0xFFB3E5FC);

// SETTINGS
Color get settingsCardColor =>
    isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFFFEFD6);

Color get settingsExpansionColor =>
    isDarkMode ? const Color(0xFF243447) : Colors.white;

Color get settingsIconBoxColor =>
    isDarkMode ? const Color(0xFF314A5F) : const Color(0xFFFFF7C2);

Color get settingsLogoutColor =>
    isDarkMode ? const Color(0xFFB84848) : const Color(0xFFEB5757);

Color get settingsLogoutTextColor => Colors.white; 

// DRAWER
Color get drawerBackgroundColor =>
    isDarkMode ? const Color(0xFF1F1F1F) : Colors.white;

Color get drawerHeaderColor =>
    isDarkMode ? const Color(0xFF243447) : const Color(0xFF58A6F0);

Color get drawerIconColor =>
    isDarkMode ? Colors.white : Colors.black87;

Color get drawerTextColor =>
    isDarkMode ? Colors.white : Colors.black87;

Color get drawerSubTextColor =>
    isDarkMode ? Colors.white70 : Colors.black54;

Color get drawerDividerColor =>
    isDarkMode ? Colors.white24 : Colors.black12;

Color get drawerAvatarBackground =>
    isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;

Color get drawerAvatarIconColor =>
    isDarkMode ? const Color(0xFFFFC59E) : const Color(0xFF58A6F0);

Color get drawerAboutDialogColor =>
    isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;

Color get drawerAboutIconColor =>
    isDarkMode ? const Color(0xFFFFC59E) : const Color(0xFF1E679F);

Color get drawerAboutButtonColor =>
    isDarkMode ? const Color(0xFF314A5F) : const Color(0xFF58A6F0);

Color get drawerDeveloperCircleColor =>
    isDarkMode
        ? const Color(0xFF314A5F)
        : const Color(0xFF58A6F0).withOpacity(0.15);

Color get drawerDeveloperNumberColor =>
    isDarkMode ? Colors.white : const Color(0xFF58A6F0);

Color get drawerOverlayColor =>
    Colors.black.withOpacity(0.4);

Color get drawerExitColor =>
    Colors.redAccent;

// CHECKER PAGE
Color get checkerBackgroundColor =>
    isDarkMode ? const Color(0xFF121212) : const Color(0xFFF6E9E1);

Color get checkerAppBarColor =>
    isDarkMode ? const Color(0xFF1E1E1E) : Colors.transparent;

Color get checkerTitleColor =>
    isDarkMode ? Colors.white : const Color(0xFF1F1B18);

Color get checkerDateBoxColor =>
    isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;

Color get checkerDateTextColor =>
    isDarkMode ? Colors.white : Colors.black87;

Color get checkerMoodLabelColor =>
    isDarkMode ? Colors.white70 : Colors.black54;

Color get checkerMoodGoodColor =>
    isDarkMode ? Colors.greenAccent : Colors.green;

Color get checkerMoodBadColor =>
    isDarkMode ? Colors.redAccent : Colors.red;

Color get checkerTextFieldColor =>
    isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;

Color get checkerTextFieldTextColor =>
    isDarkMode ? Colors.white : Colors.black87;

Color get checkerTextFieldHintColor =>
    isDarkMode ? Colors.white54 : Colors.grey;

Color get checkerSaveButtonColor =>
    isDarkMode ? const Color(0xFF314A5F) : const Color(0xFF58A6F0);

Color get checkerSaveButtonTextColor => Colors.white;

// MOOD PAGE
Color get moodPageBackgroundColor =>
    isDarkMode ? const Color(0xFF121212) : const Color(0xFFF6E9E1);

Color get moodPageAppBarColor =>
    isDarkMode ? const Color(0xFF1E1E1E) : Colors.transparent;

Color get moodPageTitleColor =>
    isDarkMode ? Colors.white : Colors.black87;

Color get moodPageEmptyDayColor =>
    isDarkMode ? const Color(0xFF3A3A3A) : Colors.white.withOpacity(0.5);

Color get moodPageEmptyDayTextColor =>
    isDarkMode ? Colors.white70 : Colors.black54;

Color get moodPageGoodDayColor =>
    isDarkMode ? const Color(0xFF1B3D2A) : Colors.green.shade100;

Color get moodPageBadDayColor =>
    isDarkMode ? const Color(0xFF4A1F1F) : Colors.red.shade100;

Color get moodPageGoodBorderColor =>
    isDarkMode ? Colors.greenAccent.withOpacity(0.45) : Colors.green.shade200;

Color get moodPageBadBorderColor =>
    isDarkMode ? Colors.redAccent.withOpacity(0.45) : Colors.red.shade200;

Color get moodPageRecapTextColor =>
    isDarkMode ? Colors.white : Colors.black87;

Color get moodPageRecapSubTextColor =>
    isDarkMode ? Colors.white70 : Colors.black54;

Color get moodPageWeekTextColor =>
    isDarkMode ? Colors.white60 : Colors.grey;

Color get moodPageSheetColor =>
    isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;

// EDIT PROFILE
Color get editProfileBackgroundColor =>
    isDarkMode ? const Color(0xFF121212) : const Color(0xFFF6E9E1);

Color get editProfileAvatarBgColor =>
    isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;

Color get editProfileInputEnabledColor =>
    isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;

Color get editProfileInputDisabledColor =>
    isDarkMode ? const Color(0xFF151515) : const Color(0xFFEFEFEF);

Color get editProfileInputTextColor =>
    isDarkMode ? Colors.white : Colors.black87;

Color get editProfileDisabledTextColor => Colors.grey;

Color get editProfileIconColor =>
    isDarkMode ? const Color(0xFFFFC59E) : const Color(0xFF58A6F0);

Color get editProfileButtonColor =>
    isDarkMode ? const Color(0xFF314A5F) : const Color(0xFF58A6F0);

Color get editProfileButtonTextColor => Colors.white;

Color get editProfileInfoTextColor =>
    isDarkMode ? Colors.white54 : Colors.grey.shade600;

// LOGIN
Color get loginBackgroundColor =>
    isDarkMode ? const Color(0xFF121212) : Colors.white;

Color get loginInputColor =>
    isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFF8F8F8);

Color get loginInputBorderColor =>
    isDarkMode ? Colors.white.withOpacity(0.06) : Colors.transparent;

Color get loginInputShadowColor =>
    isDarkMode ? Colors.black.withOpacity(0.25) : Colors.black.withOpacity(0.05);

Color get loginTitleColor =>
    isDarkMode ? Colors.white : const Color(0xFF1F1B18);

Color get loginHintColor =>
    isDarkMode ? Colors.white54 : Colors.grey;

Color get loginIconColor =>
    isDarkMode ? Colors.white60 : Colors.grey;

Color get loginBottomTextColor =>
    isDarkMode ? Colors.white70 : Colors.black54;

Color get loginButtonColor =>
    const Color(0xFF1E679F);

Color get loginButtonTextColor =>
    Colors.white;

  // THEME DATA LIGHT
  ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF6E9E1),
      primaryColor: const Color(0xFFFF8A5B),
      fontFamily: 'Poppins',
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFF6E9E1),
        foregroundColor: Color(0xFF1F1B18),
        elevation: 0,
        centerTitle: true,
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFFF8A5B),
        brightness: Brightness.light,
      ),
    );
  }

  // THEME DATA DARK
  ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF121212),
      primaryColor: const Color(0xFFFFC59E),
      fontFamily: 'Poppins',
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF121212),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFFFC59E),
        brightness: Brightness.dark,
      ),
    );
  }
}