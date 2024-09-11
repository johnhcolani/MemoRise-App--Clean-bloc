part of 'theme_bloc.dart';


abstract class ThemeState {
 final ThemeData themeData;

 ThemeState(this.themeData);
}

 class LightThemeState extends ThemeState {
 LightThemeState() :super(_lightTheme);
 }

class DarkThemeState extends ThemeState{
 DarkThemeState() : super(_darkTheme);
}
