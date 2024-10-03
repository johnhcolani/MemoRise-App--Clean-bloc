import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'background_image_event.dart';
import 'background_image_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class BackgroundImageBloc extends HydratedBloc<BackgroundImageEvent, BackgroundImageState> {
  final ImagePicker _imagePicker = ImagePicker();

  BackgroundImageBloc() : super(DefaultBackground()) {
    on<ChangeBackgroundImage>((event, emit) async {
      try {
        final XFile? pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);

        if (pickedImage != null) {
          final permanentPath = await _saveImagePermanently(pickedImage);

          // Check if the image file exists before emitting the new background state
          if (File(permanentPath).existsSync()) {
            emit(NewBackground(permanentPath));
          } else {
            emit(DefaultBackground());
          }
        } else {
          emit(DefaultBackground());
        }
      } catch (e) {
        print('Error picking image: $e');
        emit(DefaultBackground());
      }
    });

    on<SetDefaultBackground>((event, emit) {
      // Emit the default background state
      emit(DefaultBackground());
    });
  }

  // Method to copy the image to the app's documents directory
  Future<String> _saveImagePermanently(XFile pickedImage) async {
    final directory = await getApplicationDocumentsDirectory();
    final imageName = path.basename(pickedImage.path);
    final newPath = path.join(directory.path, imageName);

    // Copy the file to the new path
    try{
    final newImage = await File(pickedImage.path).copy(newPath);


      return newImage.path;
    } catch(e) {
      print('Error saving image to documents directory: $e');

      throw Exception('Failed to save image to the documents directory.');
    }
  }

  @override
  BackgroundImageState? fromJson(Map<String, dynamic> json) {
    try {
      // Check if there is a saved image path
      final imagePath = json['imagePath'] as String?;
      if (imagePath != null && imagePath.isNotEmpty) {
        return NewBackground(imagePath);
      } else {
        return DefaultBackground();
      }
    } catch (e) {
      print('Error deserializing background image state: $e');
      return DefaultBackground();
    }
  }

  @override
  Map<String, dynamic>? toJson(BackgroundImageState state) {
    try {
      if (state is NewBackground) {
        return {'imagePath': state.imagePath};
      } else {
        return {'imagePath': ''}; // Save an empty path for the default background
      }
    } catch (e) {
      print('Error serializing background image state: $e');
      return null;
    }
  }
}
