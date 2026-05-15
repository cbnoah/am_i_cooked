import 'dart:io';
import 'package:am_i_cooked/models/user_model.dart';
import 'package:am_i_cooked/pages/profil_editing.dart';
import 'package:am_i_cooked/components/my_recipes_listview.dart';
import 'package:am_i_cooked/components/profil_picture_container.dart';
import 'package:am_i_cooked/providers/recipes_provider.dart';
import 'package:am_i_cooked/service/auth_service.dart';
import 'package:am_i_cooked/utils/profile_scrapper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';


class ProfilePage extends ConsumerStatefulWidget {
  final int? userId;

  const ProfilePage({super.key, this.userId});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  bool _myRecipesExpanded = false;

  int? _userId;
  late final Dio _dio;
  late final AuthService _authService;
  late Future<UserModel?> _futureUser;

  @override
  void initState() {
    super.initState();
    _dio = Dio();
    _authService = AuthService(_dio);
    _futureUser = _initUser();
  }

  Future<void> _pullRefresh() async {
    setState(() {
      _futureUser = _initUser();
    });

    await _futureUser;

    if (_userId != null) {
      final refreshedRecipes = ref.refresh(
        userRecipesProvider(_userId!).future,
      );
      await refreshedRecipes;
    }
  }

  Widget _buildRefreshableState(Widget child) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Center(child: child),
        ),
      ],
    );
  }

  void showErrorSnackbar(String message) {
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

  Future<UserModel?> _initUser() async {
    if (widget.userId != null) {
      _userId = widget.userId;
      return _loadUserProfile(_userId!);
    }

    final sessionId = await _authService.getSessionId();
    if (sessionId == null) {
      return null;
    }

    final parsedUserId = int.tryParse(sessionId);
    if (parsedUserId == null) {
      return null;
    }

    _userId = parsedUserId;
    return _loadUserProfile(parsedUserId);
  }

  Future<UserModel?> _loadUserProfile(int id) async {
    if (!mounted) return null;

    try {
      ProfileScrapper scrapper = ProfileScrapper();
      return await scrapper.fetchAllUserData(id);
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
    }
    return null;
  }

  void _toggleMyRecipesExpanded() {
    setState(() => _myRecipesExpanded = !_myRecipesExpanded);
  }

  bool _getMyRecipesExpanded() => _myRecipesExpanded;

  Widget _buildProfileSection(AsyncSnapshot<UserModel?> asyncSnapshot) {
    return Column(
      children: [
        ProfilePictureContainer(
          imageBlob: asyncSnapshot.data?.profilePicture?.imgBlob,
          isEditIconVisible: widget.userId == null,
          onEditPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfileEditingPage()),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "LVL ${asyncSnapshot.data?.lVL ?? 0}",
              style: TextStyle(
                fontFamily: "bbh_sans_hegarty",
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              "${asyncSnapshot.data?.xP}%",
              style: TextStyle(
                fontFamily: "bbh_sans_hegarty",
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        LinearProgressIndicator(
          value: asyncSnapshot.data?.xP != null
              ? asyncSnapshot.data!.xP! / 100
              : 0,
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
      appBar: widget.userId == null
          ? AppBar(
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
                  onPressed: () async {
                    await _authService.logout();
                  },
                  icon: const Icon(Icons.settings_outlined),
                ),
              ],
            )
          : AppBar(
              surfaceTintColor: Colors.transparent,
              leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back),
              ),
              title: FutureBuilder(
                future: _futureUser,
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return _buildRefreshableState(
                      const LinearProgressIndicator(),
                    );
                  }
                  if (asyncSnapshot.hasError) {
                    return _buildRefreshableState(
                      Text(
                        'Erreur',
                        style: TextStyle(
                          fontFamily: "Nunito",
                          fontWeight: FontWeight.w300,
                          fontStyle: FontStyle.italic,
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    );
                  }

                  return Text(
                    asyncSnapshot.data!.username == null
                        ? "Nom d'utilisateur indisponible"
                        : asyncSnapshot.data!.username!,
                    style: TextStyle(
                      fontFamily: "bbh_sans_hegarty",
                      fontSize: 22,
                    ),
                  );
                },
              ),
              centerTitle: true,
              actions: [
                FutureBuilder(
                  future: _futureUser,
                  builder: (context, asyncSnapshot) {
                    return PopupMenuButton(
                      icon: const Icon(Icons.more_vert),
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem(
                            onTap: () => SharePlus.instance.share(
                              ShareParams(
                                uri: Uri.parse(
                                  // TODO: need to change this url when deep link will be ready
                                  "https://am-i-cooked.com/profile/${asyncSnapshot.data?.id}",
                                ),
                              ),
                            ),
                            child: Row(
                              spacing: 8.0,
                              children: [
                                Icon(
                                  Icons.share_outlined,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                                Text(
                                  'Partager le profil',
                                  style: TextStyle(
                                    fontFamily: "Nunito",
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // TODO: add role verification to only show this option to admins
                          PopupMenuItem(
                            child: Row(
                              spacing: 8.0,
                              children: [
                                Icon(
                                  Icons.delete,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                                Text(
                                  'Supprimer l\'utilisateur',
                                  style: TextStyle(
                                    fontFamily: "Nunito",
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ];
                      },
                    );
                  },
                ),
              ],
            ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: FutureBuilder<UserModel?>(
          future: _futureUser,
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.connectionState == ConnectionState.waiting) {
              return _buildRefreshableState(const CircularProgressIndicator());
            }

            if (asyncSnapshot.hasError) {
              return _buildRefreshableState(
                Text(
                  'Erreur lors du chargement du profil 🤨',
                  style: TextStyle(
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w300,
                    fontStyle: FontStyle.italic,
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              );
            }

            final user = asyncSnapshot.data;
            if (user == null || _userId == null) {
              return _buildRefreshableState(
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Utilisateur introuvable 😵‍💫',
                        style: TextStyle(
                          fontFamily: "Nunito",
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'L\'utilisateur que vous essayez de consulter n\'existe pas ou a été supprimé.',
                        style: TextStyle(
                          fontFamily: "Nunito",
                          fontWeight: FontWeight.w300,
                          fontStyle: FontStyle.italic,
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            return Stack(
              children: [
                Padding(
                  padding: EdgeInsets.all(
                    _myRecipesExpanded ? 12.0 : 20.0,
                  ).copyWith(top: _myRecipesExpanded ? 8.0 : 0),
                  child: Column(
                    children: [
                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: _myRecipesExpanded ? 0.0 : 1.0,
                          child: _myRecipesExpanded
                              ? const SizedBox.shrink()
                              : _buildProfileSection(asyncSnapshot),
                        ),
                      ),
                      Expanded(
                        child: MyRecipesListview(
                          userId: _userId!,
                          toggleMyRecipesExpanded: _toggleMyRecipesExpanded,
                          getMyRecipesExpanded: _getMyRecipesExpanded,
                          context: context, isOthersProfile: widget.userId != null,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
