import 'package:flutter/material.dart';

class RecipeDetails extends StatelessWidget {


  void _showIngredientsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ingrédients'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: ingredient.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(ingredient[index]),
                  leading: const Icon(Icons.check_circle_outline),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

  final String recipeName;
  final String author;
  final int prepTime;
  final int cookTime;
  final int servings;
  final String difficulty;
  final List<String> ingredient;


  const RecipeDetails({
    super.key,
    required this.recipeName,
    required this.author,
    required this.prepTime,
    required this.cookTime,
    required this.servings,
    required this.difficulty,
    required this.ingredient,

  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            recipeName,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.person, size: 16, color: Colors.grey),
              SizedBox(width: 4),
              Text(
                'Par $author',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildInfoColumn(
                Icons.timer_outlined,
                '$prepTime min',
                'Préparation',
                context,
              ),
              _buildInfoColumn(
                Icons.local_fire_department_outlined,
                '$cookTime min',
                'Cuisson',
                context,
              ),
              _buildInfoColumn(
                Icons.people_outline,
                '$servings pers.',
                'Portions',
                context
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.signal_cellular_alt, size: 16, color: Colors.green),
              SizedBox(width: 4),
              Text(
                'Difficulté : $difficulty',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _showIngredientsDialog(context),
              child: const Text('Voir les ingrédients'),
            ),
          ),
        ],
      ),


    );

  }

  Widget _buildInfoColumn(IconData icon, String value, String label, BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
