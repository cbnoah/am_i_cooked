import 'dart:io';
import 'dart:typed_data';
import 'package:am_i_cooked/components/profil_picture_container.dart';
import 'package:am_i_cooked/service/auth_service.dart';
import 'package:am_i_cooked/utils/profile_scrapper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:am_i_cooked/utils/snack_bar_handler.dart';
import 'package:am_i_cooked/utils/http_helper.dart';

class ProfileEditingPage extends StatefulWidget {
  const ProfileEditingPage({super.key});

  @override
  State<ProfileEditingPage> createState() => _ProfileEditingPageState();
}

class _ProfileEditingPageState extends State<ProfileEditingPage> {
  Uint8List? _currentImageBlob;
  String? _pendingImagePath;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  final AuthService _authService = AuthService(Dio());
  int? _userId;

  // Form controllers
  late final TextEditingController _pseudonymeController;
  String _originalUsername = '';

  @override
  void initState() {
    super.initState();
    _pseudonymeController = TextEditingController();
    _initUserAndLoadProfile();
  }

  Future<void> _initUserAndLoadProfile() async {
    final sessionId = await _authService.getSessionId();
    final parsedUserId = sessionId != null ? int.tryParse(sessionId) : null;

    if (!mounted) return;

    if (parsedUserId == null) {
      showErrorSnackbar('Session utilisateur introuvable', context);
      return;
    }

    setState(() => _userId = parsedUserId);
    await _loadUserProfile();
  }

  @override
  void dispose() {
    _pseudonymeController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    final userId = _userId;
    if (userId == null) return;

    try {
      final scrapper = ProfileScrapper();
      final user = await scrapper.fetchAllUserData(userId);
      if (mounted) {
        setState(() {
          _currentImageBlob = user.profilePicture?.imgBlob;
          _pseudonymeController.text = user.username ?? '';
          // Store original image blob
          _originalUsername = user.username ?? ''; // Store original username
        });
      }
    } catch (e) {
      debugPrint('Error loading user profile: $e');
    }
  }

  Future<void> _saveProfile() async {
    final userId = _userId;
    if (userId == null) {
      showErrorSnackbar('Session utilisateur introuvable', context);
      return;
    }
    if (_pseudonymeController.text.isEmpty && _pendingImagePath == null) {
      showErrorSnackbar('Veuillez remplir modifier un des champs', context);
      return;
    }

    setState(() => _isLoading = true);

    // Upload image if a new one was selected
    if (_pendingImagePath != null) {
      final imageSuccess = await HttpHelper.uploadUserImage(
        userId,
        _pendingImagePath!,
        context: context,
        isMounted: () => mounted,
      );
      if (!imageSuccess) {
        if (mounted) {
          setState(() => _isLoading = false);
        }
        return; // Stop if image upload failed
      }
      _pendingImagePath = null; // Clear pending image after successful upload
    }

    if (_pseudonymeController.text != _originalUsername) {
      final profileSuccess = await HttpHelper.saveUserProfile(
        userId,
        _pseudonymeController.text,
        context: context,
        isMounted: () => mounted,
      );
      if (!profileSuccess) {
        if (mounted) {
          setState(() => _isLoading = false);
        }
        return; // Stop if profile save failed
      }
    }
    if (mounted) {
      setState(() => _isLoading = false);
      // Update originals after successful save
      _originalUsername = _pseudonymeController.text;
    }
  }

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
                if (image != null) {
                  try {
                    final file = File(image.path);
                    final bytes = await file.readAsBytes();
                    setState(() {
                      _currentImageBlob = bytes;
                      _pendingImagePath = image.path;
                    });
                  } catch (e) {
                    debugPrint('Error reading selected image: $e');
                  }
                }
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
                if (image != null) {
                  try {
                    final file = File(image.path);
                    final bytes = await file.readAsBytes();
                    setState(() {
                      _currentImageBlob = bytes;
                      _pendingImagePath = image.path;
                    });
                  } catch (e) {
                    debugPrint('Error reading selected image: $e');
                  }
                }
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
          imageBlob: _currentImageBlob,
          isEditIconVisible: false,
          onEditPressed: _isLoading ? null : _pickImage,
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: _isLoading ? null : _pickImage,
          child: Text(
            "Modifier votre photo",
            style: TextStyle(
              fontFamily: "nunito",
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Theme.of(context).colorScheme.onSurface,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Add good color for AppBar
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          "Modification du profil",
          style: TextStyle(fontFamily: "bbh_sans_hegarty", fontSize: 22),
        ),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(75.0),
              child: _buildProfileSection(),
            ),
            Stack(
              alignment: AlignmentGeometry.topCenter,
              children: <Widget>[
                Container(
                  width: 375,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(100),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20.0,
                        left: 15.0,
                        right: 15.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25.0,
                            ),
                            child: TextField(
                              controller: _pseudonymeController,
                              decoration: InputDecoration(
                                label: const Text("Username"),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  borderSide: BorderSide(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primaryContainer,
                                    width: 2,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: _isLoading ? null : _saveProfile,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30.0,
                                vertical: 20.0,
                              ),
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.save,
                                  size: 20,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Sauvegarder',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
