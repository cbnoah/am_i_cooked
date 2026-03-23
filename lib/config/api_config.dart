/// Configuration centralisée pour tous les appels API
class ApiConfig {
  // URL de base du serveur
  static const String baseUrl = "http://10.31.33.23:3001";
  
  // ID utilisateur par défaut
  static const int defaultUserId = 1;
  
  // Timeouts (en secondes)
  static const int connectTimeout = 15;
  static const int uploadTimeout = 30;
  
  // Endpoints - Utilisateurs
  static String getUserUrl(int userId) => "$baseUrl/users/$userId";
  
  // Endpoints - Photos
  static String getUploadUrl(int userId) => "$baseUrl/pictures/upload/profile/$userId";
  static String getPictureUrl(int pictureId) => "$baseUrl/pictures/$pictureId";
  
  // Endpoints - Recettes (à ajouter plus tard)
  static String getRecipesUrl(int userId) => "$baseUrl/recipes/user/$userId";
  static String getRecipeUrl(int recipeId) => "$baseUrl/recipes/$recipeId";
}