class ApiConfig {
  // URL for API endpoints
  static const String baseUrl = "http://10.31.33.23:3001";
  
  // Default user ID for testing (to be replaced with real auth later)
  static const int defaultUserId = 1;
  
  // Timeouts for API calls (in seconds)
  static const int connectTimeout = 15;
  static const int uploadTimeout = 30;
  
  // Endpoints - Users
  static String getUserUrl(int userId) => "$baseUrl/users/$userId";
  
  // Endpoints - Pictures
  static String getUploadUrl(int userId) => "$baseUrl/pictures/upload/profile/$userId";
  static String getPictureUrl(int pictureId) => "$baseUrl/pictures/$pictureId";
  
  // Endpoints - Recipes (to be implemented)
  static String getRecipesUrl(int userId) => "$baseUrl/recipes/user/$userId";
  static String getRecipeUrl(int recipeId) => "$baseUrl/recipes/$recipeId";
}