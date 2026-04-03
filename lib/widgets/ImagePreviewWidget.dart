import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:e_commerce_refactor/widgets/ImagePickerBottomSheet.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePreviewWidget extends StatelessWidget {
  final XFile? image;
  final void Function(XFile image) onImagePicked;
  final double height;

  const ImagePreviewWidget({
    super.key,
    required this.image,
    required this.onImagePicked,
    this.height = 200
  });

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => ImagePickerBottomSheet.show(context, onImagePicked),
        child: DottedBorder(
          borderType: BorderType.RRect,
          radius: Radius.circular(16),
          dashPattern: [12,4],
          color: Colors.grey,
          strokeWidth: 1.5,
          child: Container(
            height: height,
            width: double.infinity,
            decoration: BoxDecoration(
              color: colors.surfaceDim,
              borderRadius: BorderRadius.circular(16),
            ),
            child: image != null
            ? ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(File(image!.path), fit: BoxFit.cover),
                
                  Positioned(
                    bottom: 8, right: 8,
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Icon(Icons.edit, color: Colors.white, size: 18,),
                      ),
                    )
                  )
                ],
              ),
            )
            : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_a_photo, size: 48, color: colors.onPrimary,),
                SizedBox(height: 8,),
                Text("Tap to add image", style: TextStyle(color: colors.onPrimary),)
              ],
            ),
            
          ),
        ),
      ),
    );
  }
}