import 'dart:convert';
import 'dart:io';
import 'package:am_i_cooked/components/profil_picture_container.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:am_i_cooked/config/api_config.dart';
import 'package:http/http.dart' as http;

class ProfileEditingPage extends StatefulWidget {
  const ProfileEditingPage({super.key});

  @override
  State<ProfileEditingPage> createState() => _ProfileEditingPageState();
}

class _ProfileEditingPageState extends State<ProfileEditingPage> {
  String _imagePath = "https://i.redd.it/jqop4dqqmdx91.jpg";
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  final int _userId = ApiConfig.defaultUserId;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    if (!mounted) return;

    setState(() => _isLoading = true);

    try {
      // 1. Get user data to find profile picture ID
      final userResponse = await http
          .get(Uri.parse(ApiConfig.getUserUrl(_userId)))
          .timeout(const Duration(seconds: 15));

      if (!mounted) return;

      if (userResponse.statusCode == 200) {
        final userData = jsonDecode(userResponse.body);
        final pictureId = userData['profile_picture_id'];

        if (pictureId != null) {
          // 2. Get the picture URL using the picture ID
          final picResponse = await http
              .get(Uri.parse('${ApiConfig.baseUrl}/pictures/$pictureId'))
              .timeout(const Duration(seconds: 15));

          if (!mounted) return;

          if (picResponse.statusCode == 200) {
            final picData = jsonDecode(picResponse.body);
            setState(() => _imagePath = picData['url']);
          }
        }
      } else {
        if (mounted) {
          _showErrorSnackbar('Error: ${userResponse.statusCode}');
        }
      }
    } on SocketException catch (e) {
      if (mounted) {
        _showErrorSnackbar('Network error: ${e.message}');
      }
      debugPrint('Socket error: $e');
    } catch (e) {
      if (mounted) {
        _showErrorSnackbar('Error: $e');
      }
      debugPrint('Error loading profile : $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _uploadImage(String filePath) async {
    if (!mounted) return;

    setState(() => _isLoading = true);

    try {
      final uri = Uri.parse(ApiConfig.getUploadUrl(_userId));
      final request = http.MultipartRequest('POST', uri);

      request.files.add(
        await http.MultipartFile.fromPath(
          'avatar', // must match the name in multerUploadConf.single('avatar')
          filePath,
        ),
      );

      final response = await request.send().timeout(
        const Duration(seconds: 30),
      );

      final body = await response.stream.bytesToString();
      final data = jsonDecode(body);

      if (!mounted) return;

      if (response.statusCode == 201) {
        setState(() => _imagePath = data['url']);
        if (mounted) {
          _showSuccessSnackbar('Image uploaded with success!');
        }
      } else {
        if (mounted) {
          _showErrorSnackbar('Upload error: ${response.statusCode}');
        }
        debugPrint('Error uploading image : $body');
      }
    } on SocketException catch (e) {
      if (mounted) {
        _showErrorSnackbar('Network error: ${e.message}');
      }
      debugPrint('Socket error upload: $e');
    } catch (e) {
      if (mounted) {
        _showErrorSnackbar('Error: $e');
      }
      debugPrint('Exception upload : $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
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
                if (image != null) await _uploadImage(image.path);
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
                if (image != null) await _uploadImage(image.path);
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
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: _buildProfileSection(),
            ),
            Stack(
              alignment: AlignmentGeometry.topCenter,
              children: <Widget>[
                Container(
                  width: 350,
                  height: 425,
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
                              decoration: InputDecoration(
                                label: const Text("Pseudonyme"),
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
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25.0,
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                label: const Text("Nom d'utilisateur"),
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
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25.0,
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                label: const Text("Nom d'utilisateur"),
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
                      padding: const EdgeInsets.only(top: 100.0),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: save profile changes
                            _showSuccessSnackbar(
                              'Profil mis à jour avec succès!',
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50.0,
                              vertical: 25.0,
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
                                size: 24,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Sauvegarder',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
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
