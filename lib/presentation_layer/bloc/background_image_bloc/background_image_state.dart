abstract class BackgroundImageState {}

class DefaultBackground extends BackgroundImageState {}

class NewBackground extends BackgroundImageState {
  final String imagePath;

  NewBackground(this.imagePath);
}
