import 'package:am_i_cooked/components/profil_picture_container.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:am_i_cooked/config/api_config.dart';
import 'package:am_i_cooked/utils/snack_bar_handler.dart';
import 'package:am_i_cooked/utils/http_helper.dart';


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

  // Form controllers
  late final TextEditingController _pseudonymeController;
  late final TextEditingController _nomUtilisateurController;

  @override
  void initState() {
    super.initState();
    _pseudonymeController = TextEditingController();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _pseudonymeController.dispose();
    _nomUtilisateurController.dispose();
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

    final imageUrl = await HttpHelper.uploadUserImage(
      _userId,
      filePath,
      context: context,
      isMounted: () => mounted,
    );

    if (mounted) {
      if (imageUrl != null) setState(() => _imagePath = imageUrl);
      setState(() => _isLoading = false);
    }
  }


  Future<void> _saveProfile() async {
    if (_pseudonymeController.text.isEmpty ||
        _nomUtilisateurController.text.isEmpty) {
      showErrorSnackbar('Veuillez remplir tous les champs', context);
      return;
    }

    setState(() => _isLoading = true);

    await HttpHelper.saveUserProfile(
      _userId,
      _pseudonymeController.text,
      context: context,
      isMounted: () => mounted,
    );

    if (mounted) {
      setState(() => _isLoading = false);
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
                      child: Center(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _saveProfile,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40.0,
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
