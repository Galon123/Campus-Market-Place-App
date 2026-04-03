import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  static final ImagePicker _picker = ImagePicker();

  static Future<XFile?> pickFromGallery() async {
    try{
      return await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1080
      );
    } catch(e) {
      return null;
    }
  }

  static Future<XFile?> pickFromCamera() async {
    try{
      return await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1080
      );
    } catch(e) {
      return null;
    }
  }

}