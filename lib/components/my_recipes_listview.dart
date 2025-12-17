import 'package:am_i_cooked/components/recipe_container.dart';
import 'package:flutter/material.dart';

class MyRecipesListview extends StatefulWidget {
  final dynamic toggleMyRecipesExpanded;
  const MyRecipesListview({super.key, required this.toggleMyRecipesExpanded});

  @override
  State<MyRecipesListview> createState() => _MyRecipesListviewState();
}

class _MyRecipesListviewState extends State<MyRecipesListview> {
  _togleMyRecipesExpanded() {
    widget.toggleMyRecipesExpanded();
  }
  final Map<String, bool> _bookmarks = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.keyboard_arrow_up, size: 35),
          style: ButtonStyle(
            padding: WidgetStateProperty.all<EdgeInsets>(
              EdgeInsets.zero,
            ),
            minimumSize: WidgetStateProperty.all<Size>(
              Size(double.infinity, 30),
            ),
          ),
          color: Theme.of(
            context,
          ).colorScheme.onSurfaceVariant,
          onPressed: () => setState(() {
            _togleMyRecipesExpanded();
          }),
        ),
        Text(
          "Mes Recettes",
          style: TextStyle(
            fontFamily: "bbh_sans_hegarty",
            fontSize: 22,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: ListView.separated(
              scrollDirection: Axis.vertical,
              itemCount: 5,
              separatorBuilder: (context, index) => SizedBox(height: 20),
              itemBuilder: (context, index) {
                final key = 'profile-recipe-$index';
                return SizedBox(
                  height: 200,
                  child: RecipeContainer(
                    key: ValueKey(key),
                    path:
                    "https://www.apero-bordeaux.fr/wp-content/uploads/2024/02/20240216_65cfa1ce1fa54-1024x683.jpg",
                    isBookmarked: _bookmarks[key] ?? true,
                    showBookmarkIcon: true,
                    recipeTitle: 'Poulet Roti',
                    recipePage: Placeholder(),
                    heroTag: key,
                    onTap: () {
                      Navigator.of(
                        context,
                      ).push(MaterialPageRoute(builder: (_) => Placeholder()));
                    },
                    onBookmarkChanged: (isBookmarked) {
                      setState(() {
                        _bookmarks[key] = isBookmarked;
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
