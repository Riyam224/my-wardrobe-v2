import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:my_wordrobe_v2/core/utils/app_colors.dart';
import 'package:my_wordrobe_v2/features/data/db_helper.dart';
import 'package:my_wordrobe_v2/features/data/item_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class EditItemView extends StatefulWidget {
  final int itemId;

  const EditItemView({required this.itemId, super.key});

  @override
  State<EditItemView> createState() => _EditItemViewState();
}

class _EditItemViewState extends State<EditItemView> {
  ItemModel? item;
  File? _pickedImage;
  final _picker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadItem();
  }

  Future<void> loadItem() async {
    final items = await DBHelper.getAllItems();
    // Fix: Provide a valid fallback or handle null safely
    final currentItem = items.firstWhere(
      (e) => e.id == widget.itemId,
      orElse: () => throw Exception('Item not found'),
    );

    if (!mounted) return;

    setState(() {
      item = currentItem;
      _nameController.text = currentItem.name;
      _colorController.text = currentItem.color;
      _typeController.text = currentItem.type;
      _pickedImage = File(currentItem.imagePath);
      isLoading = false;
    });
  }

  Future<void> _pickImage() async {
    try {
      final picked = await _picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        final tempFile = File(picked.path);

        final appDir = await getApplicationDocumentsDirectory();
        final imageDir = Directory('${appDir.path}/images');
        if (!await imageDir.exists()) {
          await imageDir.create(recursive: true);
        }

        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${path.basename(picked.path)}';
        final savedImage = await tempFile.copy('${imageDir.path}/$fileName');

        setState(() {
          _pickedImage = savedImage;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to pick image: $e")));
      }
    }
  }

  Future<void> _saveChanges() async {
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

    final updatedItem = ItemModel(
      id: item!.id,
      name: _nameController.text.trim(),
      color: _colorController.text.trim(),
      type: _typeController.text.trim(),
      imagePath: _pickedImage!.path,
      isPicked: item!.isPicked,
    );

    await DBHelper.updateItem(updatedItem);

    if (!mounted) return;
    GoRouter.of(context).go('/home');
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColor,
        title: const Text('Edit Item'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => GoRouter.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _pickImage,
              child: (_pickedImage != null && _pickedImage!.existsSync())
                  ? Image.file(_pickedImage!, height: 250, fit: BoxFit.cover)
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
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _colorController,
              decoration: const InputDecoration(labelText: 'Color'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _typeController,
              decoration: const InputDecoration(
                labelText: 'Type (e.g., Shirt, Shoes)',
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
              ),
              child: const Text(
                "Save Changes",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
