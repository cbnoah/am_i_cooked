import 'package:am_i_cooked/components/my_recipes_listview.dart';
import 'package:am_i_cooked/components/profil_picture_container.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _myRecipesExpanded = false;

  void _toggleMyRecipesExpanded() {
    setState(() {
      _myRecipesExpanded = !_myRecipesExpanded;
    });
  }

  bool _getMyRecipesExpanded() {
    return _myRecipesExpanded;
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
        title: Center(
          child: Text(
            "Votre Profil",
            style: TextStyle(fontFamily: "bbh_sans_hegarty", fontSize: 22),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: EdgeInsets.only(
          left: _myRecipesExpanded ? 12.0 : 20.0,
          right: _myRecipesExpanded ? 12.0 : 20.0,
          bottom: _myRecipesExpanded ? 12.0: 20.0,
          top: _myRecipesExpanded ? 8.0 : 0,
        ),
        child: Column(
          children: [
            AnimatedSize(
              duration: Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 200),
                opacity: _myRecipesExpanded ? 0.0 : 1.0,
                child: _myRecipesExpanded
                    ? SizedBox.shrink()
                    : Column(
                        children: [
                          ProfilePictureContainer(
                            pathImage: "https://i.redd.it/jqop4dqqmdx91.jpg",
                            isEditIconVisible: true,
                          ),
                          SizedBox(height: 10),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "LVL 4",
                                    style: TextStyle(
                                      fontFamily: "bbh_sans_hegarty",
                                      fontSize: 16,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  Text(
                                    "20%",
                                    style: TextStyle(
                                      fontFamily: "bbh_sans_hegarty",
                                      fontSize: 16,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                              LinearProgressIndicator(
                                value: 0.2,
                                minHeight: 8,
                                color: Theme.of(context).colorScheme.primary,
                                year2023: false,
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
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
