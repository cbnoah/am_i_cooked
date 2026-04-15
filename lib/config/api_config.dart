class ApiConfig {
  // URL for API endpoints
  static const String baseUrl = "http://localhost:3001";
  
  // ID utilisateur par défaut
  static const int defaultUserId = 1;
  
  // Timeouts (en secondes)
  static const int connectTimeout = 15;
  static const int uploadTimeout = 30;
  
  // Endpoints - Users
  static String getUserUrl(int userId) => "$baseUrl/users/$userId";
  
  // Endpoints - Pictures
  static String getUploadUrl(int userId) => "$baseUrl/users/$userId/picture";
  static String getPictureUrl(int pictureId) => "$baseUrl/pictures/$pictureId";
  
  // Endpoints - Recettes (à ajouter plus tard)
  static String getRecipesUrl(int userId) => "$baseUrl/recipes/user/$userId";
  static String getRecipeUrl(int recipeId) => "$baseUrl/recipes/$recipeId";

  // Endpoints - Authentication
  static String getLoginUrl() => "$baseUrl/users/login";
  static String getRefreshUrl() => "$baseUrl/users/refresh";
  static String getLogoutUrl() => "$baseUrl/users/logout";
  static String getRegisterUrl() => "$baseUrl/users";
}