import 'package:flutter_bloc/flutter_bloc.dart';
import 'background_image_event.dart';
import 'background_image_state.dart';
import 'package:image_picker/image_picker.dart';

class BackgroundImageBloc extends Bloc<BackgroundImageEvent, BackgroundImageState> {
  final ImagePicker _imagePicker = ImagePicker();

  BackgroundImageBloc() : super(DefaultBackground()) {
    on<ChangeBackgroundImage>((event, emit) async {
      try {
        final XFile? pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);

        if (pickedImage != null) {
          emit(NewBackground(pickedImage.path)); // Emit the new background image
        } else {
          // Handle the case when no image is picked
          emit(DefaultBackground());
        }
      } catch (e) {
        // Handle error or permission issues
        print('Error picking image: $e');
        emit(DefaultBackground());
      }
    });
    on<SetDefaultBackground>((event, emit) {
      // Emit the default background state
      emit(DefaultBackground());
    });
  }
}
