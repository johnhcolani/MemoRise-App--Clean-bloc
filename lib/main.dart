// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:notes_for_everybody/presentation_layer/bloc/background_image_bloc/background_image_bloc.dart';
import 'package:notes_for_everybody/presentation_layer/bloc/folder_bloc/folder_bloc.dart';
import 'package:notes_for_everybody/presentation_layer/bloc/splash_bloc/splash_bloc.dart';
import 'package:notes_for_everybody/presentation_layer/bloc/theme_bloc/theme_bloc.dart';
import 'package:notes_for_everybody/presentation_layer/screens/splash_screen.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  HydratedBloc.storage = storage;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => FolderBloc(),
        ),
        BlocProvider(
          create: (_) => SplashBloc(),
        ),
        BlocProvider(
          create: (_) => ThemeBloc(),
        ),
        BlocProvider(
          create: (context) => BackgroundImageBloc(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MemoRise',
            theme: themeState is LightThemeState ? _lightTheme : _darkTheme, // Use the current theme from ThemeBloc
            home: const SplashScreen(),
          );
        },
      ),
    );
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
  scaffoldBackgroundColor: Colors.grey,
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
