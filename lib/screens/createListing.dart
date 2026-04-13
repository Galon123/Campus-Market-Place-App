import 'dart:ffi';

import 'package:e_commerce_refactor/providers/UserProvider.dart';
import 'package:e_commerce_refactor/theme/AppTheme.dart';
import 'package:e_commerce_refactor/widgets/ImagePreviewWidget.dart';
import 'package:flutter/material.dart' hide Size;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreateListing extends StatefulWidget {
  const CreateListing({super.key});

  @override
  State<CreateListing> createState() => _CreateListingState();
}

class _CreateListingState extends State<CreateListing> {

  final List<String> condition =['New', 'Lightly_Used' , 'Heavily_Used'];
  final List<String> all_categories = ["Electronics", "Stationary", "Accessories", "Rent", "Miscellaneous"];

  final _formkey = GlobalKey<FormState>();

  bool isLoading = false;

  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();

  String _selectedCondition = "New";
  List<String> _selectedCategories = [];
  XFile? _image;

  
  Future<void> handleItemCreate() async{

    if(!_formkey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try{
      final userProvider = Provider.of<UserProvider>(context,listen: false);

      final success = await userProvider.createItem(
        _image, 
        _titleController.text.trim(), 
        double.parse(_priceController.text.trim()), 
        int.parse(_quantityController.text.trim()), 
        _selectedCondition, 
        _descController.text.trim(),
        _selectedCategories
      );

      if(success == true){
        debugPrint("Item created Successfully");
      }
      else{
        debugPrint("Item creation not successful");
      }
    } catch (e) {
      debugPrint("Item Creation Error : $e");
    }

  }


  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Create", style: text.titleLarge,),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImagePreviewWidget(
              image: _image, 
              onImagePicked: (image) => setState(() => _image = image)
            ),
            SizedBox(height: 16,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              height: 450,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: colors.onPrimary),
                borderRadius: BorderRadius.circular(12),
                color: colors.surfaceDim,
              ),
              child: Form(
                key: _formkey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FractionallySizedBox(
                        widthFactor: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Item Title', style: text.bodyMedium,),
                            SizedBox(height: 4,),
                            TextFormField(
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 0,
                                  horizontal: 10
                                ),
                                hintText: 'Eg: Calculator',
                                hintStyle: text.bodyMedium,
                                fillColor: colors.surface,
                                filled: true,
                                border: OutlineInputBorder(borderSide: BorderSide(color: colors.secondary),borderRadius: BorderRadius.circular(12))
                              ),
                              controller: _titleController,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      FractionallySizedBox(
                        widthFactor: 1,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Item Price', style: text.bodySmall,),
                                  SizedBox(height: 4,),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 0,
                                        horizontal: 10
                                      ),
                                      hintText: '999.99',
                                      hintStyle: text.bodyMedium,
                                      fillColor: colors.surface,
                                      filled: true,
                                      border: OutlineInputBorder(borderSide: BorderSide(color: colors.secondary),borderRadius: BorderRadius.circular(12))
                                    ),
                                    keyboardType: TextInputType.number,
                                    controller: _priceController,
                                  ),
                                ],
                              ),
                            ),                            
                            SizedBox(width: 10,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Quantity', style: text.bodySmall,),
                                  SizedBox(height: 4,),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 0,
                                        horizontal: 10
                                      ),
                                      hintText: '1',
                                      hintStyle: text.bodyMedium,
                                      fillColor: colors.surface,
                                      filled: true,
                                      border: OutlineInputBorder(borderSide: BorderSide(color: colors.secondary),borderRadius: BorderRadius.circular(12))
                                    ),
                                    keyboardType: TextInputType.number,
                                    controller: _quantityController,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),

                      Text('Item Condition', style: text.bodySmall,),
                      SizedBox(height: 4,),
                      DropdownButtonFormField(
                        initialValue: condition[0],
                        decoration: InputDecoration(
                          fillColor: colors.surface,
                          filled: true,
                          border: OutlineInputBorder(borderSide: BorderSide(color: colors.secondary),borderRadius: BorderRadius.circular(12))
                        ),
                        borderRadius: BorderRadius.circular(24),
                        dropdownColor: colors.secondary,
                        style: text.bodyMedium,
                        isExpanded: false,
                        items: condition.map((c) => DropdownMenuItem(
                          value: c,
                          child: Text(c.replaceAll("_", " "))
                        )).toList(), 
                        onChanged: (value) => {setState( () => _selectedCondition = value!)},
                      ),
                      
                      SizedBox(height: 10,),
                      FractionallySizedBox(
                        widthFactor: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Item Description', style: text.bodyMedium,),
                            SizedBox(height: 4,),
                            TextFormField(
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 10
                                ),
                                hintText: 'Write some description about the item here.....',
                                hintStyle: text.bodyMedium,
                                fillColor: colors.surface,
                                filled: true,
                                border: OutlineInputBorder(borderSide: BorderSide(color: colors.secondary),borderRadius: BorderRadius.circular(12)),
                              ),
                              maxLines: 4,
                              controller: _descController,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ),
            ),
            SizedBox(height: 4,),
            Container(
              margin: EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                    backgroundColor: colors.primary,
                    padding: EdgeInsets.all(8.0),
                    elevation: 10
                  ),
                  onPressed: isLoading ? null : handleItemCreate, 
                  child: isLoading
                  ? CircularProgressIndicator(color: Colors.white,)
                  : Text("Create Item", style: context.buttonText,)
                ),
              ),
            ),
            SizedBox(height: 150,)
          ],
        ),
      ),
    );
  }
}