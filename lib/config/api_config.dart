/// Configuration centralisée pour tous les appels API
class ApiConfig {
  // Server URL
  static const String baseUrl = "http://10.31.33.23:3001";

  // ID user by default (à remplacer par une gestion d'authentification plus tard)
  static const int defaultUserId = 1;
  
  // Timeouts (in seconds)
  static const int connectTimeout = 15;
  static const int uploadTimeout = 30;
  
  // Endpoints - Users
  static String getUserUrl(int userId) => "$baseUrl/users/$userId";
  
  // Endpoints - Photos
  static String getUploadUrl(int userId) => "$baseUrl/pictures/upload/profile/$userId";
  static String getPictureUrl(int pictureId) => "$baseUrl/pictures/$pictureId";
  
  // Endpoints - Recipes
  static String getRecipesUrl(int userId) => "$baseUrl/recipes/user/$userId";
  static String getRecipeUrl(int recipeId) => "$baseUrl/recipes/$recipeId";

  // Endpoints - Authentication
  static String getLoginUrl() => "$baseUrl/login";
  static String getRegisterUrl() => "$baseUrl/users/";
}