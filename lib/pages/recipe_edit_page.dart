import 'dart:io';
import 'package:am_i_cooked/models/ingredient_model.dart';
import 'package:am_i_cooked/models/recipe_model.dart';
import 'package:am_i_cooked/providers/favorites_provider.dart';
import 'package:am_i_cooked/providers/recipes_provider.dart';
import 'package:am_i_cooked/utils/http_helper.dart';
import 'package:am_i_cooked/utils/snack_bar_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class RecipeEditPage extends ConsumerStatefulWidget {
  final int? id;

  const RecipeEditPage({super.key, this.id});

  @override
  ConsumerState<RecipeEditPage> createState() => _RecipeEditPageState();
}

class _RecipeEditPageState extends ConsumerState<RecipeEditPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController cookingTimeController = TextEditingController();
  TextEditingController preparationTimeController = TextEditingController();
  String? difficulty;

  List<IngredientModel> ingredientsList = [];

  bool isLoading = false;

  Uint8List? _currentImageBlob;
  String? _pendingImagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final recipeData = ref.read(recipeByIdProvider(widget.id!));
        if (recipeData != null) {
          setState(() {
            titleController.text = recipeData.name ?? '';
            descriptionController.text = recipeData.description ?? '';
            cookingTimeController.text =
                recipeData.cookingTime?.toString() ?? '';
            preparationTimeController.text =
                recipeData.preparationTime?.toString() ?? '';
            difficulty = recipeData.difficulty;
            _currentImageBlob = recipeData.recipePicture?.imgBlob;
            ingredientsList = List.from(recipeData.ingredients ?? []);
          });
        }
      });
    }
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galerie'),
              onTap: () async {
                Navigator.pop(context);
                final image = await _picker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 80,
                  maxWidth: 512,
                );
                if (image != null) {
                  try {
                    final file = File(image.path);
                    final bytes = await file.readAsBytes();
                    setState(() {
                      _currentImageBlob = bytes;
                      _pendingImagePath = image.path;
                    });
                  } catch (e) {
                    debugPrint('Error reading selected image: $e');
                  }
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Caméra'),
              onTap: () async {
                Navigator.pop(context);
                final image = await _picker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 80,
                  maxWidth: 512,
                );
                if (image != null) {
                  try {
                    final file = File(image.path);
                    final bytes = await file.readAsBytes();
                    setState(() {
                      _currentImageBlob = bytes;
                      _pendingImagePath = image.path;
                    });
                  } catch (e) {
                    debugPrint('Error reading selected image: $e');
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _addIngredient() {
    setState(() {
      ingredientsList.add(IngredientModel(name: '', quantity: 1, unit: ''));
    });
  }

  Future<void> _saveRecipe() async {
    if (!_formKey.currentState!.validate()) return;

    if (ingredientsList.isEmpty) {
      showErrorSnackbar("Veuillez ajouter au moins un ingrédient", context);
      return;
    }

    setState(() => isLoading = true);

    try {
      final userIdAsync = await ref.read(userIdProvider.future);
      RecipeModel? savedRecipe;

      if (widget.id == null) {
        savedRecipe = await ref
            .read(recipesProvider.notifier)
            .createRecipe(
              name: titleController.text,
              description: descriptionController.text,
              cookingTime: int.tryParse(cookingTimeController.text),
              preparationTime: int.tryParse(preparationTimeController.text),
              difficulty: difficulty,
              idUser: userIdAsync,
              ingredients: ingredientsList,
            );
        if (mounted) {
          showSuccessSnackbar("Recette créée avec succès !", context);
        }
      } else {
        savedRecipe = await ref
            .read(recipesProvider.notifier)
            .updateRecipe(
              id: widget.id!,
              name: titleController.text,
              description: descriptionController.text,
              cookingTime: int.tryParse(cookingTimeController.text),
              preparationTime: int.tryParse(preparationTimeController.text),
              difficulty: difficulty,
              ingredients: ingredientsList,
            );
        if (mounted) {
          showSuccessSnackbar("Recette mise à jour avec succès !", context);
        }
      }

      if (savedRecipe.id != null && _pendingImagePath != null) {
        if (mounted) {
          await HttpHelper.uploadRecipeImage(
            savedRecipe.id!,
            _pendingImagePath!,
            context: context,
            isMounted: () => mounted,
          );
        }
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        showErrorSnackbar("Erreur lors de l'enregistrement", context);
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _deleteRecipe() async {
    if (widget.id == null) return;

    setState(() => isLoading = true);

    try {
      await ref.read(recipesProvider.notifier).deleteRecipe(widget.id!);
      if (mounted) {
        showSuccessSnackbar("Recette supprimée avec succès !", context);
        context.go("/");
      }
    } catch (e) {
      print(e);
      if (mounted) {
        showErrorSnackbar("Erreur lors de la suppression", context);
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SafeArea(
            child: Column(
              spacing: 20.0,
              children: [
                Stack(
                  children: [
                    GestureDetector(
                      onTap: isLoading ? null : _pickImage,
                      child: Container(
                        height: MediaQuery.sizeOf(context).height / 4,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Theme.of(context).colorScheme.surface,
                          image: _currentImageBlob != null
                              ? DecorationImage(
                                  image: MemoryImage(_currentImageBlob!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _currentImageBlob == null
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.photo_camera,
                                      size: 45.0,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                                    Text(
                                      widget.id == null
                                          ? "Ajouter une photo"
                                          : "Modifier la photo",
                                      style: TextStyle(
                                        fontFamily: "nunito",
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : null,
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: IconButton.filled(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                        style: IconButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        spacing: 12.0,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTextField(
                            "Titre de la recette",
                            titleController,
                            "Ex: Poulet rôti",
                          ),
                          _buildTextField(
                            "Description",
                            descriptionController,
                            "Une délicieuse recette...",
                            maxLines: 3,
                          ),

                          Row(
                            children: [
                              Expanded(
                                child: _buildNumberField(
                                  "Prép. (min)",
                                  preparationTimeController,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildNumberField(
                                  "Cuisson (min)",
                                  cookingTimeController,
                                ),
                              ),
                            ],
                          ),

                          Text("Difficulté", style: _labelStyle()),
                          DropdownButtonFormField<String>(
                            initialValue: difficulty,
                            items: ["easy", "medium", "hard"]
                                .map(
                                  (d) => DropdownMenuItem(
                                    value: d,
                                    child: Text(d),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) =>
                                setState(() => difficulty = val),
                            decoration: _inputDecoration("Choisir"),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Ingrédients", style: _labelStyle()),
                              IconButton.filledTonal(
                                onPressed: _addIngredient,
                                icon: const Icon(Icons.add),
                              ),
                            ],
                          ),

                          ...ingredientsList.asMap().entries.map((entry) {
                            int idx = entry.key;
                            IngredientModel ing = entry.value;
                            return _buildIngredientRow(idx, ing);
                          }),

                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
                                foregroundColor: Theme.of(
                                  context,
                                ).colorScheme.onPrimary,
                              ),
                              onPressed: isLoading ? null : _saveRecipe,
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      widget.id == null
                                          ? "CRÉER LA RECETTE"
                                          : "METTRE À JOUR",
                                      style: TextStyle(
                                        fontFamily: "Nunito",
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.surface,
                                      ),
                                    ),
                            ),
                          ),
                          ?widget.id != null
                              ? SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      backgroundColor: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      foregroundColor: Theme.of(
                                        context,
                                      ).colorScheme.onPrimary,
                                    ),
                                    onPressed: isLoading ? null : _deleteRecipe,
                                    child: isLoading
                                        ? const CircularProgressIndicator(
                                            color: Colors.white,
                                          )
                                        : Text(
                                            "SUPPRIMER LA RECETTE",
                                            style: TextStyle(
                                              fontFamily: "Nunito",
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.surface,
                                            ),
                                          ),
                                  ),
                                )
                              : null,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextStyle _labelStyle() => const TextStyle(
    fontFamily: "nunito",
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  InputDecoration _inputDecoration(String hint) => InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  );

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _labelStyle()),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: _inputDecoration(hint),
          validator: (val) => (val == null || val.isEmpty) ? "Requis" : null,
        ),
      ],
    );
  }

  Widget _buildNumberField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _labelStyle()),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: _inputDecoration("0"),
        ),
      ],
    );
  }

  Widget _buildIngredientRow(int index, IngredientModel ing) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextFormField(
            initialValue: ing.name,
            onChanged: (val) => ing.name = val,
            decoration: _inputDecoration("Nom"),
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          flex: 2,
          child: TextFormField(
            initialValue: ing.quantity?.toString(),
            keyboardType: TextInputType.number,
            onChanged: (val) => ing.quantity = double.tryParse(val),
            decoration: _inputDecoration("Qté"),
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          flex: 2,
          child: TextFormField(
            initialValue: ing.unit,
            onChanged: (val) => ing.unit = val,
            decoration: _inputDecoration("Unité"),
          ),
        ),
        IconButton(
          onPressed: () => setState(() => ingredientsList.removeAt(index)),
          icon: const Icon(Icons.delete, color: Colors.red),
        ),
      ],
    );
  }
}
