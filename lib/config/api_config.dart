class ApiConfig {
  // Server URL
  static const String baseUrl = String.fromEnvironment("API_URL");
  
  // Timeouts (en secondes)
  static const int connectTimeout = 15;
  static const int uploadTimeout = 30;
  
  // Endpoints - Users
  static String getUsersUrl() => "$baseUrl/users";
  static String getUserUrl(int userId) => "$baseUrl/users/$userId";
  
  // Endpoints - Pictures
  static String getProfilePictureUrl(int userId) => "${getUsersUrl()}/$userId/picture";
  static String getRecipePictureUrl(int recipeId) => "${getRecipeUrl(recipeId)}/picture";
  
  // Endpoints - Recipes
  static String getAllRecipesUrl() => "$baseUrl/recipes";
  static String getRecipesUrl(int userId) => "$baseUrl/recipes/user/$userId";
  static String getRecipeUrl(int recipeId) => "$baseUrl/recipes/$recipeId";

  // Endpoints - Authentication
  static String getLoginUrl() => "$baseUrl/users/login";
  static String getRefreshUrl() => "$baseUrl/users/refresh";
  static String getLogoutUrl() => "$baseUrl/users/logout";
  static String getRegisterUrl() => "$baseUrl/users";

  // Endpoints - Favorites
  static String getFavoritesUrl() => "$baseUrl/favorites";
  static String getUserFavoritesUrl(int userId) => "$baseUrl/favorites/users/$userId";
  static String getSpecificFavoriteUrl(int userId, int recipeId) => "$baseUrl/favorites/users/$userId/recipes/$recipeId";
}