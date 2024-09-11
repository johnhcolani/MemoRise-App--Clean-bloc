import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  bool isDarkTheme = false;

  ThemeBloc() : super(LightThemeState()) {
    on<ToggleTheme>((event, emit) {
      isDarkTheme = !isDarkTheme;
      if (isDarkTheme) {
        emit(DarkThemeState());
      } else {
        emit(LightThemeState());
      }
    });
  }
}

// Define your light theme data
final ThemeData _lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0x7511433E),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: const Color(0x7511433E), // AppBar background color for light theme
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: const Color(0x7511433E),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: const Color(0x7511433E),
    textTheme: ButtonTextTheme.primary,
  ),
);

// Define your dark theme data
final ThemeData _darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.orange,
  scaffoldBackgroundColor: Colors.black87,
  appBarTheme: AppBarTheme(
    color: Color(0x35010E0D), // AppBar background color for dark theme
    iconTheme: IconThemeData(color: Colors.orange),
    titleTextStyle: TextStyle(color: Colors.orange, fontSize: 20),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.orange,
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.orange,
    textTheme: ButtonTextTheme.primary,
  ),
);
