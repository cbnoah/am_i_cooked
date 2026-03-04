import 'package:flutter/material.dart';

import '../components/profil_picture_container.dart';
import '../components/xp_bar_widget.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profil",
          style: TextStyle(
            fontFamily: "bbh_sans_hegarty",
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const ProfilPictureContainer(),
              const SizedBox(height: 8),
              XpBar(
                level: 5,
                currentXP: 350,
                maxXP: 500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}