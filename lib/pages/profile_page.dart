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
      body: _myRecipesExpanded
          ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: MyRecipesListview(toggleMyRecipesExpanded: _toggleMyRecipesExpanded,),
          )
          : Padding(
              padding: const EdgeInsets.only(
                left: 12.0,
                right: 12.0,
                bottom: 12.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                spacing: 10.0,
                children: [
                  ProfilePictureContainer(
                    pathImage: "https://i.redd.it/jqop4dqqmdx91.jpg",
                    isEditIconVisible: true,
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.onSurfaceVariant,
                        year2023: false,
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30),
                          bottom: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withAlpha(100),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 15.0,
                          right: 15.0,
                          bottom: 5.0,
                        ),
                        child: MyRecipesListview(toggleMyRecipesExpanded: _toggleMyRecipesExpanded,),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
