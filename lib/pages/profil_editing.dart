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
        onEditPressed: _isLoading ? null : _pickImage,  // <- appelle _pickImage au clic
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
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: _buildProfileSection(),
          ),
          Stack(
            alignment: AlignmentGeometry.center,
            children: <Widget>[
              Container(color: Colors.white, width: 350, height: 425),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        color: Colors.blueGrey,
                        padding: const EdgeInsets.all(12.0),
                        width: 300,
                        height: 100,
                        child: const Center(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Pseudonyme",
                              border: OutlineInputBorder(),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.blueGrey,
                        padding: const EdgeInsets.all(12.0),
                        width: 300,
                        height: 100,
                        child: const Center(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Nom d'utilisateur",
                              border: OutlineInputBorder(),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.blueGrey,
                        padding: const EdgeInsets.all(12.0),
                        width: 300,
                        height: 100,
                        child: const Center(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Description",
                              border: OutlineInputBorder(),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    color: Colors.blueGrey,
                    padding: const EdgeInsets.all(12.0),
                    width: 300,
                    height: 100,
                    child: const Center(
                      child: Text(
                        "Cette page est en cours de développement, vous pouvez cependant changer votre photo de profil en cliquant dessus.",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
