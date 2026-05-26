import 'package:am_i_cooked/config/api_config.dart';
import 'package:am_i_cooked/models/recipe_model.dart';
import 'package:am_i_cooked/providers/comments_provider.dart';
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
  bool _isSending = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitComment(int recipeId) async {
    final text = _commentController.text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() => _isSending = true);

    final success = await ref.read(commentServiceProvider).postComment(recipeId, text);

    if (mounted) {
      setState(() => _isSending = false);
      if (success) {
        _commentController.clear();
        ref.invalidate(commentsProvider(recipeId));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Commentaire envoyé !')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de l\'envoi')),
        );
      }
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

    final authorAsync = ref.watch(userByIdProvider(recipe.idUser ?? 0));
    final commentsAsync = ref.watch(commentsProvider(recipe.id ?? 0));

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
              author: authorAsync.when(
                data: (user) => user.username ?? "Inconnu",
                loading: () => "Chargement...",
                error: (_, __) => "Utilisateur n°${recipe.idUser}",
              ),
              prepTime: recipe.preparationTime ?? 0,
              cookTime: recipe.cookingTime ?? 0,
              servings: 1,
              difficulty: recipe.difficulty ?? "Non définie",
              xp: recipe.xpWinnable,
              ingredient: resolvedIngredients,
              comment: commentsAsync.maybeWhen(
                data: (list) => list.map((c) => c.content).toList(),
                orElse: () => [],
              ),
              userNameComment: commentsAsync.maybeWhen(
                data: (list) => list.map((c) => c.username ?? "Anonyme").toList(),
                orElse: () => [],
              ),
            ),

            if (recipe.description != null && recipe.description!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Description / Instructions",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      recipe.description!,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ],
                ),
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
                          enabled: !_isSending,
                          decoration: InputDecoration(
                            hintText: "Votre avis...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _isSending 
                        ? const CircularProgressIndicator()
                        : IconButton.filled(
                            onPressed: () => _submitComment(recipe.id ?? 0),
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
