import 'package:flutter/material.dart';

import '../utils/nav_bar_switcher.dart';
import '../components/recipe_container.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Widget> _buildTestListForCarousel(String prefix) {
    return List.generate(5, (index) {
      return RecipeContainer(
        key: ValueKey('$prefix-$index'),
        path:
            "https://www.apero-bordeaux.fr/wp-content/uploads/2024/02/20240216_65cfa1ce1fa54-1024x683.jpg",
        isBookmarked: true,
        showBookmarkIcon: true,
        recipeTitle: 'Poulet Roti',
        recipePage: Placeholder(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Am I Cooked ?",
          style: TextStyle(fontFamily: "bbh_sans_hegarty"),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                "Enfin de retour 👋!",
                style: TextStyle(
                  fontFamily: "nunito",
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  fontSize: 36,
                ),
                textAlign: TextAlign.left,
              ),
              Text(
                "Voici quelques nouvelles recettes à tester",
                style: TextStyle(fontFamily: "nunito", fontSize: 24),
                textAlign: TextAlign.left,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30.0,
                  vertical: 15.0,
                ),
                child: Divider(),
              ),
              Text(
                "Recommendations : ",
                style: TextStyle(
                  fontFamily: "nunito",
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                ),
                textAlign: TextAlign.left,
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 180,
                  maxWidth: MediaQuery.of(context).size.width,
                ),
                child: CarouselView.weighted(
                  itemSnapping: true,
                  // WARNING : flexWeights makes the carousel moves very fast if the weights in the beginning are low (flutter bug still not fixed
                  // see https://github.com/flutter/flutter/issues/160350)
                  flexWeights: [2, 7, 2],
                  children: _buildTestListForCarousel('forYou'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30.0,
                  vertical: 5.0,
                ),
                child: Divider(),
              ),
              Text(
                "Tendance : ",
                style: TextStyle(
                  fontFamily: "nunito",
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                ),
                textAlign: TextAlign.left,
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 180,
                  maxWidth: MediaQuery.of(context).size.width,
                ),
                child: CarouselView.weighted(
                  itemSnapping: true,
                  // WARNING : flexWeights makes the carousel moves very fast if the weights in the beginning are low (flutter bug still not fixed
                  // see https://github.com/flutter/flutter/issues/160350)
                  flexWeights: [2, 7, 2],
                  children: _buildTestListForCarousel('trends'),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBarSwitcher(),
    );
  }
}
