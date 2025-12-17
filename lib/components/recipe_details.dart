import 'package:flutter/material.dart';

class RecipeDetails extends StatelessWidget {
  final String recipeName;
  final String author;
  final int prepTime;
  final int cookTime;
  final int servings;
  final String difficulty;

  const RecipeDetails({
    super.key,
    required this.recipeName,
    required this.author,
    required this.prepTime,
    required this.cookTime,
    required this.servings,
    required this.difficulty,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                  color: Colors.grey[600],
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
              ),
              _buildInfoColumn(
                Icons.local_fire_department_outlined,
                '$cookTime min',
                'Cuisson',
              ),
              _buildInfoColumn(
                Icons.people_outline,
                '$servings pers.',
                'Portions',
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.signal_cellular_alt, size: 16, color: Colors.orange),
              SizedBox(width: 4),
              Text(
                'Difficulté : $difficulty',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Colors.deepPurple),
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
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
