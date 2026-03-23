import 'dart:convert';
import 'dart:io';
import 'package:am_i_cooked/components/my_recipes_listview.dart';
import 'package:am_i_cooked/components/profil_picture_container.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:am_i_cooked/config/api_config.dart';
import 'package:http/http.dart' as http;

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

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    if (!mounted) return;
    
    setState(() => _isLoading = true);
    
    try {
      // 1. Récupère l'utilisateur avec timeout
      final userResponse = await http.get(
        Uri.parse(ApiConfig.getUserUrl(_userId)),
      ).timeout(const Duration(seconds: 15));

      if (!mounted) return;

      if (userResponse.statusCode == 200) {
        final userData = jsonDecode(userResponse.body);
        final pictureId = userData['profile_picture_id'];

        if (pictureId != null) {
          // 2. Récupère l'URL de la photo
          final picResponse = await http.get(
            Uri.parse('${ApiConfig.baseUrl}/pictures/$pictureId'),
          ).timeout(const Duration(seconds: 15));

          if (!mounted) return;

          if (picResponse.statusCode == 200) {
            final picData = jsonDecode(picResponse.body);
            setState(() => _imagePath = picData['url']);
          }
        }
      } else {
        if (mounted) {
          _showErrorSnackbar('Erreur: ${userResponse.statusCode}');
        }
      }
    } on SocketException catch (e) {
      if (mounted) {
        _showErrorSnackbar('Erreur réseau: ${e.message}');
      }
      debugPrint('🔌 Erreur socket: $e');
    } catch (e) {
      if (mounted) {
        _showErrorSnackbar('Erreur: $e');
      }
      debugPrint('❌ Erreur chargement profil : $e');
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
          'avatar', // doit matcher le nom dans multerUploadConf.single('avatar')
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
          _showSuccessSnackbar('Image uploadée avec succès!');
        }
      } else {
        if (mounted) {
          _showErrorSnackbar('Erreur upload: ${response.statusCode}');
        }
        debugPrint('❌ Erreur upload : $body');
      }
    } on SocketException catch (e) {
      if (mounted) {
        _showErrorSnackbar('Erreur réseau: ${e.message}');
      }
      debugPrint('🔌 Erreur socket upload: $e');
    } catch (e) {
      if (mounted) {
        _showErrorSnackbar('Erreur: $e');
      }
      debugPrint('❌ Exception upload : $e');
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
          onEditPressed: _isLoading ? null : _pickImage,
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
        // ✅ CORRIGÉ: Supprimé 'year2023: false' qui n'existe pas
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
          // ✅ Loading overlay
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}