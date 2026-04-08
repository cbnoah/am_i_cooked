import 'package:flutter/material.dart';

import '../utils/nav_bar_switcher.dart';
import '../components/recipe_container.dart';
import 'recipes_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final Map<String, bool> _bookmarks = {};

  List<Widget> _buildTestListForCarousel(String prefix) {
    return List.generate(5, (index) {
      final key = '$prefix-$index';
      final recipeTitle = 'Poulet Roti';
      final imagePath =
          "https://www.apero-bordeaux.fr/wp-content/uploads/2024/02/20240216_65cfa1ce1fa54-1024x683.jpg";
      return RecipeContainer(
        key: ValueKey(key),
        path: imagePath,
        isBookmarked: _bookmarks[key] ?? true,
        showBookmarkIcon: true,
        recipeTitle: 'Poulet Roti',
        recipePage: RecipesPage(),
        heroTag: key,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => RecipesPage(
                recipeTitle: recipeTitle,
                imagePath: imagePath,
                criteria: ['Végétarien', 'Rapide', '< 30 min'],
                author: 'Chef Jean',
                prepTime: 15,
                cookTime: 45,
                servings: 4,
                difficulty: 'Facile',
              ),
            ),
          );
        },
        onBookmarkChanged: (isBookmarked) {
          setState(() {
            _bookmarks[key] = isBookmarked;
          });
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Am I Cooked ?",
          style: TextStyle(
            fontFamily: "bbh_sans_hegarty",
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
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
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.left,
              ),
              Text(
                "Voici quelques nouvelles recettes à tester",
                style: TextStyle(
                  fontFamily: "nunito",
                  fontSize: 24,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.left,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30.0,
                  vertical: 15.0,
                ),
                child: Divider(color: Theme.of(context).colorScheme.outline),
              ),
              Text(
                "Recommendations : ",
                style: TextStyle(
                  fontFamily: "nunito",
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  color: Theme.of(context).colorScheme.onSurface,
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
                  flexWeights: [2, 7, 2],
                  children: _buildTestListForCarousel('forYou'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30.0,
                  vertical: 5.0,
                ),
                child: Divider(color: Theme.of(context).colorScheme.outline),
              ),
              Text(
                "Tendance : ",
                style: TextStyle(
                  fontFamily: "nunito",
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  color: Theme.of(context).colorScheme.onSurface,
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
                  flexWeights: [2, 7, 2],
                  children: _buildTestListForCarousel('trends'),
                ),
              ),
              FilledButton(onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => RecipesPage(),
                  ),
                );
              }, child: Text("Recette test") ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBarSwitcher(),
    );
  }
}