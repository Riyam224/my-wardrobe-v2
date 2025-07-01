// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:my_wordrobe_v2/core/utils/app_colors.dart';
import 'package:my_wordrobe_v2/features/data/db_helper.dart';
import 'package:my_wordrobe_v2/features/data/item_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class AddItemView extends StatefulWidget {
  const AddItemView({super.key});

  @override
  State<AddItemView> createState() => _AddItemViewState();
}

class _AddItemViewState extends State<AddItemView> {
  File? _pickedImage;
  final _picker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();

  Future<void> _pickImage() async {
    try {
      final picked = await _picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        final tempFile = File(picked.path);

        // ✅ Save image to a permanent directory
        final appDir = await getApplicationDocumentsDirectory();
        final imageDir = Directory('${appDir.path}/images');
        if (!await imageDir.exists()) {
          await imageDir.create(recursive: true);
        }

        // ✅ Generate unique name and copy file
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${path.basename(picked.path)}';
        final savedImage = await tempFile.copy('${imageDir.path}/$fileName');

        // ✅ Update state with permanent image file
        setState(() {
          _pickedImage = savedImage;
        });

        print('✅ Image saved at: ${savedImage.path}');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to pick image: $e")));
    }
  }

  Future<void> _saveItem() async {
    if (_pickedImage == null ||
        _nameController.text.isEmpty ||
        _colorController.text.isEmpty ||
        _typeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields and pick an image."),
        ),
      );
      return;
    }

    final newItem = ItemModel(
      name: _nameController.text.trim(),
      color: _colorController.text.trim(),
      type: _typeController.text.trim(),
      imagePath: _pickedImage!.path, // ✅ correct
      isPicked: false,
    );

    await DBHelper.insertItem(newItem);

    // ✅ Navigate back to home
    if (!mounted) return;
    GoRouter.of(context).go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColor,
        title: const Text('Add Item'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            GoRouter.of(context).go('/home');
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Image Picker
            GestureDetector(
              onTap: _pickImage,
              child: (_pickedImage != null && _pickedImage!.existsSync())
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _pickedImage!,
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      height: 250,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(child: Text("Tap to pick an image")),
                    ),
            ),
            const SizedBox(height: 20),

            // Name
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 10),

            // Color
            TextField(
              controller: _colorController,
              decoration: const InputDecoration(labelText: 'Color'),
            ),
            const SizedBox(height: 10),

            // Type
            TextField(
              controller: _typeController,
              decoration: const InputDecoration(
                labelText: 'Type (e.g., Shirt, Shoes)',
              ),
            ),
            const SizedBox(height: 30),

            // Save
            ElevatedButton(
              onPressed: _saveItem,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
              ),
              child: const Text(
                "Save Item",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
