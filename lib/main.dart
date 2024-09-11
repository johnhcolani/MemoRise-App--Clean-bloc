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
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Folder Manager',
            theme: state.themeData, // Use the current theme from ThemeBloc
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
