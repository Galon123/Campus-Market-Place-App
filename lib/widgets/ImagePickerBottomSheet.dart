import 'package:e_commerce_refactor/services/ImagePickerService.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerBottomSheet extends StatelessWidget {
  final void Function(XFile image) onImagePicked;

  const ImagePickerBottomSheet({super.key, required this.onImagePicked});

  static void show(BuildContext context, void Function(XFile image) onImagePicked) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12))
      ), 
      builder: (_) => ImagePickerBottomSheet(onImagePicked: onImagePicked)
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2)
              ),
            ),
            SizedBox(height: 16,),
            Text('Select Image', style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),),
            SizedBox(height: 12,),

            ListTile(
              leading: Icon(Icons.photo_library, color: Colors.indigo,),
              title: Text("Choose from Gallery"),
              onTap: () async {
                Navigator.pop(context);
                final image = await ImagePickerService.pickFromGallery();
                if(image!=null) onImagePicked(image);
              },
            ),

            ListTile(
              leading: Icon(Icons.camera_alt, color: Colors.indigo,),
              title: Text("Take a Photo"),
              onTap: () async {
                Navigator.pop(context);
                final image = await ImagePickerService.pickFromCamera();
                if(image!=null) onImagePicked(image);
              },
            )
          ],
        ),
      )
    );
  }
}