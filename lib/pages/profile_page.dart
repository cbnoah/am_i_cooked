import 'dart:convert';
import 'dart:io';
import 'package:am_i_cooked/pages/profil_editing.dart';
import 'package:am_i_cooked/components/my_recipes_listview.dart';
import 'package:am_i_cooked/components/profil_picture_container.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:am_i_cooked/config/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:am_i_cooked/utils/http_helper.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _myRecipesExpanded = false;
  String _imagePath = "https://i.redd.it/jqop4dqqmdx91.jpg";
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  final int _userId = ApiConfig.defaultUserId;

  // Form controllers
  late final TextEditingController _pseudonymeController;

  @override
  void initState() {
    super.initState();
    _pseudonymeController = TextEditingController();
    _loadUserProfile();
  }


  @override
  void dispose() {
    _pseudonymeController.dispose();
    super.dispose();
  }

    Future<void> _loadUserProfile() async {
    final imageUrl = await HttpHelper.loadUserProfile(
      _userId,
      context: context,
      isMounted: () => mounted,
    );
    if (mounted && imageUrl != null) {
      setState(() => _imagePath = imageUrl);
    }
  }

    Future<void> _uploadImage(String filePath) async {
    setState(() => _isLoading = true);

    final success = await HttpHelper.uploadUserImage(
      _userId,
      filePath,
      context: context,
      isMounted: () => mounted,
    );

    if (mounted) {
      if (success) {
        // Display local file path while waiting for BLOB conversion
        setState(() => _imagePath = filePath);
      }
      setState(() => _isLoading = false);
    }
  }

  void _toggleMyRecipesExpanded() {
    setState(() => _myRecipesExpanded = !_myRecipesExpanded);
  }

  bool _getMyRecipesExpanded() => _myRecipesExpanded;

  Widget _buildProfileSection() {
    return Column(
      children: [
        ProfilePictureContainer(
          pathImage: _imagePath,
          isEditIconVisible: true,
          onEditPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileEditingPage()),
            ).then((_) {
              // Reload profile image after returning from editing page
              // Add small delay to ensure server has processed the image
              Future.delayed(const Duration(milliseconds: 500), () {
                if (mounted) {
                  _loadUserProfile();
                }
              });
            });
          },
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
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(
              _myRecipesExpanded ? 12.0 : 20.0,
            ).copyWith(top: _myRecipesExpanded ? 8.0 : 0),
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
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
