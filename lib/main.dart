import 'package:base_app/home/home_screen.dart';
import 'package:base_app/login/login_screen.dart';
import 'package:base_app/login/signup_screen.dart';
import 'package:base_app/model/base_app_user.dart';
import 'package:flutter/material.dart';

Color defaultColor = Colors.red;
var kColorScheme = ColorScheme.fromSeed(seedColor: defaultColor);
var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: defaultColor,
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode themeMode = ThemeMode.light;
  BaseAppUser? loginUser;
  String successMessage = '';
  var isNewUser = false;
  var successfulRegistration = false;

  void switchTheme() {
    setState(() {
      if (themeMode == ThemeMode.light) {
        themeMode = ThemeMode.dark;
      } else {
        themeMode = ThemeMode.light;
      }

      successfulRegistration = false;
    });
  }

  void logout() {
    setState(() {
      loginUser = null;
      successfulRegistration = false;
    });
  }

  void goToHome(BaseAppUser currentUser) {
    setState(() {
      loginUser = currentUser;
    });
  }

  void goToRegister() {
    setState(() {
      isNewUser = true;
    });
  }

  void cancelRegister() {
    setState(() {
      isNewUser = false;
      successfulRegistration = false;
    });
  }

  void successRegister(String message) {
    setState(() {
      successMessage = message;
      isNewUser = false;
      successfulRegistration = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = LoginScreen(
      switchTheme,
      successfulRegistration,
      successMessage,
      goToHome: goToHome,
      goToRegister: goToRegister,
    );

    if (loginUser != null) {
      content = HomeScreen(
        switchTheme,
        currentUser: loginUser!,
        logout: logout,
      );
    } else if (isNewUser) {
      content = SignupScreen(
        switchTheme,
        successRegister: (String message) {
          successRegister(message);
        },
        cancelRegister: cancelRegister,
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: kDarkColorScheme,
        scaffoldBackgroundColor: kDarkColorScheme.primaryContainer,
        appBarTheme: AppBarTheme().copyWith(
          backgroundColor: kDarkColorScheme.primaryContainer,
          foregroundColor: kDarkColorScheme.onPrimaryContainer,
        ),
        cardTheme: CardThemeData().copyWith(
          color: kDarkColorScheme.secondaryContainer,
          margin: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kDarkColorScheme.onPrimaryContainer,
            foregroundColor: kDarkColorScheme.primaryContainer,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            backgroundColor: kDarkColorScheme.primaryContainer,
            foregroundColor: kDarkColorScheme.onPrimaryContainer,
          ),
        ),
        textTheme: ThemeData().textTheme.copyWith(
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold,
            color: kDarkColorScheme.onSecondaryContainer,
            fontSize: 14,
          ),
          titleMedium: TextStyle(
            fontWeight: FontWeight.normal,
            color: kDarkColorScheme.onSecondaryContainer,
            fontSize: 14,
          ),
        ),
      ),
      theme: ThemeData().copyWith(
        colorScheme: kColorScheme,
        scaffoldBackgroundColor: kColorScheme.primaryContainer,
        appBarTheme: AppBarTheme().copyWith(
          backgroundColor: kColorScheme.primaryContainer,
          foregroundColor: kColorScheme.onPrimaryContainer,
        ),
        cardTheme: CardThemeData().copyWith(
          color: kColorScheme.secondaryContainer,
          margin: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kColorScheme.onPrimaryContainer,
            foregroundColor: kColorScheme.primaryContainer,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            backgroundColor: kColorScheme.primaryContainer,
            foregroundColor: kColorScheme.onPrimaryContainer,
          ),
        ),
        textTheme: ThemeData().textTheme.copyWith(
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold,
            color: kColorScheme.onSecondaryContainer,
            fontSize: 14,
          ),
          titleMedium: TextStyle(
            fontWeight: FontWeight.normal,
            color: kColorScheme.onSecondaryContainer,
            fontSize: 14,
          ),
        ),
      ),
      themeMode: themeMode,
      home: content,
    );
  }
}
