import 'dart:io';
import 'package:am_i_cooked/components/my_recipes_listview.dart';
import 'package:am_i_cooked/components/profil_picture_container.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _myRecipesExpanded = false;
  String _imagePath = "https://i.redd.it/jqop4dqqmdx91.jpg";
  final ImagePicker _picker = ImagePicker();

  void _toggleMyRecipesExpanded() {
    setState(() => _myRecipesExpanded = !_myRecipesExpanded);
  }

  bool _getMyRecipesExpanded() => _myRecipesExpanded;

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galerie'),
              onTap: () async {
                Navigator.pop(context);
                final image = await _picker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 80,
                  maxWidth: 512,
                );
                if (image != null) setState(() => _imagePath = image.path);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Caméra'),
              onTap: () async {
                Navigator.pop(context);
                final image = await _picker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 80,
                  maxWidth: 512,
                );
                if (image != null) setState(() => _imagePath = image.path);
              },
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildProfileSection() {
    return Column(
      children: [
        ProfilePictureContainer(
          pathImage: _imagePath,
          isEditIconVisible: true,
          onEditPressed: _pickImage,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "LVL 4",
              style: TextStyle(
                fontFamily: "bbh_sans_hegarty",
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              "20%",
              style: TextStyle(
                fontFamily: "bbh_sans_hegarty",
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        LinearProgressIndicator(
          value: 0.2,
          minHeight: 8,
          year2023: false,
          color: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          "Votre Profil",
          style: TextStyle(fontFamily: "bbh_sans_hegarty", fontSize: 22),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: EdgeInsets.all(_myRecipesExpanded ? 12.0 : 20.0).copyWith(
          top: _myRecipesExpanded ? 8.0 : 0,
        ),
        child: Column(
          children: [
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _myRecipesExpanded ? 0.0 : 1.0,
                child: _myRecipesExpanded
                    ? const SizedBox.shrink()
                    : _buildProfileSection(),
              ),
            ),
            Expanded(
              child: MyRecipesListview(
                toggleMyRecipesExpanded: _toggleMyRecipesExpanded,
                getMyRecipesExpanded: _getMyRecipesExpanded,
              ),
            ),
          ],
        ),
      ),
    );
  }
}