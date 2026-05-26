import 'package:am_i_cooked/config/api_config.dart';
import 'package:am_i_cooked/models/recipe_model.dart';
import 'package:am_i_cooked/providers/recipes_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../components/criteria_bar.dart';
import '../components/recipe_details.dart';

class RecipesPage extends ConsumerStatefulWidget {
  final RecipeModel? recipe;
  final String heroTag;
  final int id;

  const RecipesPage({
    super.key,
    this.id = 0,
    this.recipe,
    required this.heroTag,
  });

  @override
  ConsumerState<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends ConsumerState<RecipesPage> {
  final TextEditingController _commentController = TextEditingController();

  // On initialise avec des listes vides pour n'utiliser que les données réelles
  List<String> localComments = [];
  List<String> localUserNames = [];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitComment() {
    if (_commentController.text.trim().isNotEmpty) {
      setState(() {
        localComments.add(_commentController.text.trim());
        localUserNames.add("Moi");
      });
      _commentController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Commentaire envoyé !')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final recipeFromApi = ref.watch(recipeByIdProvider(widget.id));
    final recipe = widget.recipe ?? recipeFromApi;

    if (recipe == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final String resolvedTitle = recipe.name ?? "Recette sans nom";
    final List<String> resolvedCriteria = [
      recipe.difficulty ?? "Inconnue",
      '${recipe.preparationTime ?? 0} min',
      '${recipe.cookingTime ?? 0} min',
    ];

    final List<String> resolvedIngredients = (recipe.description == null || recipe.description!.isEmpty)
        ? ['Aucun ingrédient renseigné']
        : recipe.description!.split(',').map((e) => e.trim()).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(resolvedTitle),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: widget.heroTag,
              child: Image.network(
                // On utilise l'URL de l'API pour l'image
                ApiConfig.getRecipePictureUrl(recipe.id ?? 0),
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 250,
                  color: Colors.grey[200],
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.restaurant, size: 50, color: Colors.grey),
                      SizedBox(height: 8),
                      Text("Aucune image disponible", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            RecipeCriteriaBar(criteria: resolvedCriteria),
            const SizedBox(height: 8),
            RecipeDetails(
              recipeName: resolvedTitle,
              author: "Utilisateur n°${recipe.idUser ?? '?'}",
              prepTime: recipe.preparationTime ?? 0,
              cookTime: recipe.cookingTime ?? 0,
              servings: 1,
              difficulty: recipe.difficulty ?? "Non définie",
              ingredient: resolvedIngredients,
              comment: localComments,
              userNameComment: localUserNames,
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Commentaires",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          decoration: InputDecoration(
                            hintText: "Votre avis...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        onPressed: _submitComment,
                        icon: const Icon(Icons.send),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}