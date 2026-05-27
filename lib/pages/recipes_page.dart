import 'package:am_i_cooked/config/api_config.dart';
import 'package:am_i_cooked/models/recipe_model.dart';
import 'package:am_i_cooked/providers/favorites_provider.dart';
import 'package:am_i_cooked/providers/recipes_provider.dart';
import 'package:am_i_cooked/service/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
  Widget _buildImageError() {
    return Container(
      height: 250,
      color: Colors.grey[200],
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant, size: 50, color: Colors.grey),
          SizedBox(height: 8),
          Text(
            "Aucune image disponible",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
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
    final userIdAsync = ref.watch(userIdProvider);

    final String resolvedTitle = recipe.name ?? "Recette sans nom";
    final List<String> resolvedCriteria = [
      recipe.difficulty ?? "Inconnue",
      '${recipe.preparationTime ?? 0} min',
      '${recipe.cookingTime ?? 0} min',
    ];

    final List<String> resolvedIngredients =
        (recipe.description == null || recipe.description!.isEmpty)
        ? ['Aucun ingrédient renseigné']
        : recipe.description!.split(',').map((e) => e.trim()).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(resolvedTitle),
        actions: [
          userIdAsync.when(
            data: (userId) {
              debugPrint(
                'RecipesPage: Current User ID=$userId, Recipe Author ID=${recipe.idUser}',
              );
              Dio dio = Dio();
              AuthService authService = AuthService(dio);

              return FutureBuilder(
                future: authService.getSessionId(),
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const SizedBox.shrink();
                  }
                  if (asyncSnapshot.hasError) {
                    debugPrint(
                      'Error fetching session ID: ${asyncSnapshot.error}',
                    );
                    return const SizedBox.shrink();
                  }
                  final sessionId = int.parse(asyncSnapshot.data.toString());
                  debugPrint('Fetched session ID: $sessionId');
                  if (sessionId == recipe.idUser) {
                    return IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () =>
                          context.push('/recipe/${recipe.id}/edit'),
                    );
                  }

                  return const SizedBox.shrink();
                },
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: widget.heroTag,
              child:
                  (recipe.recipePicture?.imgBlob != null &&
                          recipe.recipePicture!.imgBlob!.isNotEmpty)
                      ? Image.memory(
                        recipe.recipePicture!.imgBlob!,
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => _buildImageError(),
                      )
                      : Image.network(
                        ApiConfig.getRecipePictureUrl(recipe.id ?? 0),
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => _buildImageError(),
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
                error: (err, stack) => "Utilisateur n°${recipe.idUser}",
              ),
              authorId: recipe.idUser,
              prepTime: recipe.preparationTime ?? 0,
              cookTime: recipe.cookingTime ?? 0,
              servings: 1,
              difficulty: recipe.difficulty ?? "Non définie",
              xp: recipe.xpWinnable,
              ingredient: resolvedIngredients,
            ),

            if (recipe.description != null && recipe.description!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Description / Instructions",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      recipe.description!,
                      style: const TextStyle(fontSize: 16, height: 1.5),
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
