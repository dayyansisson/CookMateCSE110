import 'dart:convert';
import 'package:cookmate/cookbook.dart';
import 'package:http/http.dart' as http;

class BackendRequest {

  static const int _INFORMATIONAL = 1;
  static const int _SUCCESS = 2;
  static const int _REDIRECT = 3;
  static const int _CLIENT = 4;
  static const int _SERVER = 5;

  static const String _FAIL_LOGIN = "Unable to log in with provided credentials.";

  final String _authToken;
  final String _userID;
  BackendRequest (String authToken, int userID) : _authToken = authToken, _userID = userID.toString();

  /* Method: createUser
   * Arg(s):
   *    - email: the user's email
   *    - username: the user's username
   *    - password: the user's password
   * 
   * Return:
   *    - success: ID of the new user
   *    - failure: null
   * 
   * Notes: This method does not do any validation except checking if a username
   *        is unique or not. All other validation must be done beforehand.
   */
  static Future<int> createUser (String email, String username, String password) async {

    print("Creating new user...");
      
    // Make API call
    final response = await http.post(
      "https://thecookmate.com/auth/users/", 
      body: {
        "email":email,
        "username":username,
        "password":password
      }
    );

    // Validate return
    int statusCode = response.statusCode ~/ 100;
    if(statusCode != _SUCCESS)
    {
      print(_interpretStatus(statusCode, response.statusCode, response.body));
      return null;
    }

    var data = jsonDecode(response.body);
    print("User successfully created with ID ${data["id"]}");
    return data["id"];
  }

  /* Method: getUser
   * Arg(s):
   * 
   * Return:
   *    - success: ID of the new user
   *    - failure: null
   */
  Future<int> getUser () async {

    print("Getting user info ($_authToken)...");
      
    // Make API call
    final response = await http.get(
      "https://thecookmate.com/auth/users/me", 
      headers: { "Authorization":"Token $_authToken" }
    );

    // Validate return
    int statusCode = response.statusCode ~/ 100;
    if(statusCode != _SUCCESS)
    {
      print(_interpretStatus(statusCode, response.statusCode, response.body));
      return null;
    }

    var data = jsonDecode(response.body);
    print("User found, returning user ID ${data["id"]}");
    return data["id"];
  }

  /* Method: deleteUser
   * Arg(s):
   *    - password: the user's password
   * 
   * Return:
   *    - success: true
   *    - failure: false
   */
  Future<bool> deleteUser (String password) async {

    print("Deleting user ($_authToken, $password)...");

    // Make API call
    final client = http.Client();
    var rq = http.Request("DELETE", Uri.parse("https://thecookmate.com/auth/users/me/"));
    rq.bodyFields = {"current_password":password};
    rq.headers.addAll({"Authorization":"Token $_authToken"});
    var response = await client.send(rq);
    client.close();

    // Validate return
    int statusCode = response.statusCode ~/ 100;
    if(statusCode != _SUCCESS)
    {
      print(_interpretStatus(statusCode, response.statusCode, await response.stream.bytesToString()));
      return false;
    }

    print("User deletion successful");
    return true;
  }

  /* Method: updateUser
   * Arg(s):
   *    - currentUsername (optional): The user's current username
   *    - currentPassword (optional): The user's current password
   *    - newUsername (optional): The user's requested new username
   *    - newPassword (optional): The user's requested new password
   *    - newEmail (optional): The user's requested new email
   * 
   * Return:
   *    - success: true, if ALL requested updates are successful
   *    - failure: false, if ANY of the requested updates fail
   * 
   * Notes: To update the username, both newUsername and currentUsername 
   *        need to be supplied, and correct. Same for passwords. To 
   *        update the email, you just need to supply the new email.
   */
  Future<bool> updateUser ({String currentUsername, String currentPassword, String newUsername, String newPassword, String newEmail}) async {

    bool updateStatus = true;
    
    // Update username
    if(currentUsername != null && newUsername != null) {
      print("Updating username from $currentUsername to $newUsername...");
      
      // Make API call
      final response = await http.post(
        "https://thecookmate.com/auth/users/set_username/", 
        headers: { "Authorization":"Token $_authToken" },
        body: {"new_username":newUsername, "current_username":currentUsername}
      );

      // Validate return
      int statusCode = response.statusCode ~/ 100;
      if(statusCode != _SUCCESS) {
        print(_interpretStatus(statusCode, response.statusCode, response.body));
        updateStatus = false;
      } else {
        print("Username successfully updated to $newUsername");
      }
    }

    // Update password
    if(currentPassword != null && newPassword != null) {
      print("Updating password from $currentPassword to $newPassword...");
      
      // Make API call
      final response = await http.post(
        "https://thecookmate.com/auth/users/set_password/", 
        headers: { "Authorization":"Token $_authToken" },
        body: { "new_password":newPassword, "current_password":currentPassword }
      );

      // Validate return
      int statusCode = response.statusCode ~/ 100;
      if(statusCode != _SUCCESS) {
        print(_interpretStatus(statusCode, response.statusCode, response.body));
        updateStatus = false;
      } else {
        print("Password successfully updated to $newPassword");
      }
    }

    // Update email
    if(newEmail != null) {
      print("Updating email to $newEmail...");

      // Make API call
      final response = await http.patch(
        "https://thecookmate.com/auth/users/me/", 
        headers: { "Authorization":"Token $_authToken" },
        body: { "email":newEmail }
      );

      // Validate return
      int statusCode = response.statusCode ~/ 100;
      if(statusCode != _SUCCESS) {
        print(_interpretStatus(statusCode, response.statusCode, response.body));
        updateStatus = false;
      } else {
        print("Email successfully updated to $newEmail");
      }
    }

    return updateStatus;
  }

  /* Method: login
   * Arg(s):
   *    - username: the user's username
   *    - password: the user's password
   * 
   * Return:
   *    - success: the auth token
   *    - failure: the error message
   */
  static Future<String> login (String username, String password) async {

    print("Logging in ($username, $password)...");
      
    // Make API call
    final response = await http.post(
      "https://thecookmate.com/auth/token/login", 
      body: {
        "username":username,
        "password":password
      }
    );

    // Validate return
    var data = jsonDecode(response.body);
    int statusCode = response.statusCode ~/ 100;
    if(statusCode != _SUCCESS)
    {
      List<dynamic> loginError = data["non_field_errors"];
      if(loginError != null && loginError[0] == _FAIL_LOGIN) {
        print("Log in failed, invalid credentials");
        return loginError[0];
      }

      print(_interpretStatus(statusCode, response.statusCode, response.body));
      return null;
    }

    print("Log in successful, with token ${data["auth_token"]}");
    return data["auth_token"];
  }

  /* Method: logout
   * Arg(s):
   * 
   * Return:
   *    - success: true
   *    - failure: false
   */
  Future<bool> logout () async {

    print("Logging out ($_authToken)...");
      
    // Make API call
    final response = await http.post(
      "https://thecookmate.com/auth/token/logout", 
      headers: { "Authorization":"Token $_authToken" },
    );

    // Validate return
    int statusCode = response.statusCode ~/ 100;
    if(statusCode != _SUCCESS)
    {
      print(_interpretStatus(statusCode, response.statusCode, response.body));
      return false;
    }

    print("Log out successful");
    return true;
  }

  /* Method: getUserProfile
   * Arg(s):
   * 
   * Return:
   *    - success: The UserProfile associated with the userID
   *    - failure: null
   */
  Future<UserProfile> getUserProfile () async {

    print("Getting user profile (User ID: $_userID, $_authToken)...");
      
    // Make API call
    final response = await http.get(
      "https://thecookmate.com/auth/user-profile/$_userID/", 
      headers: { "Authorization":"Token $_authToken" }
    );

    // Validate return
    int statusCode = response.statusCode ~/ 100;
    if(statusCode != _SUCCESS)
    {
      print(_interpretStatus(statusCode, response.statusCode, response.body));
      return null;
    }

    print("User profile found, returning profile for $_userID");
    UserProfile profile = UserProfile.fromJSON(jsonDecode(response.body));
    print(profile.toString());
    return profile;
  }

  /* Method: updateUserProfile
   * Arg(s):
   * 
   * Return:
   *    - success: ID of the new user
   *    - failure: null
   */
  Future<bool> updateUserProfile (UserProfile userProfile) async {

    print("Updating user profile (User ID: ${userProfile.id}, $_authToken)...");

    String allergens = "[ ";
    for(Map<String, dynamic> allergen in userProfile.allergens)
    {
      allergens += "${jsonEncode(allergen["id"])}, ";
    }
    allergens = allergens.substring(0, allergens.length - 2);
    allergens += " ]";
      
    // Make API call
    final response = await http.put(
      "https://thecookmate.com/auth/user-profile/${userProfile.id}/update/", 
      headers: { "Authorization":"Token $_authToken", "Content-Type":"application/json" },
      body: "{\"diet\":${userProfile.diet["id"]},\"allergens\":$allergens }"
    );

    // Validate return
    int statusCode = response.statusCode ~/ 100;
    if(statusCode != _SUCCESS)
    {
      print(_interpretStatus(statusCode, response.statusCode, response.body));
      return false;
    }

    print("Update Successful! Request returned ${response.body}");

    return true;
  }

  /* Method: getIngredientList
   * Arg(s):
   * 
   * Return:
   *    - success: A list of ingredients
   *    - failure: null
   */
  Future<List<Ingredient>> getIngredientList () async {

    print("Getting ingredient list...");

    // Make API call
    final response = await http.get(
      "https://thecookmate.com/api/recipe/ingredient", 
      headers: { "Authorization":"Token $_authToken" }
    );

    // Validate return
    int statusCode = response.statusCode ~/ 100;
    if(statusCode != _SUCCESS) {
      print("Request for ingredient list failed");
      print(_interpretStatus(statusCode, response.statusCode, response.body));
      return null;
    }

    // Parse JSON & build ingredient list
    List<dynamic> data = jsonDecode(response.body);
    List<Ingredient> ingredients = new List<Ingredient>();
    Ingredient ingredient;
    for(int i = 0; i < data.length; i++)
    {
      ingredient = Ingredient.fromJSON(data[i]);
      ingredients.add(ingredient);
    }

    return ingredients;
  }

  /* Method: getDietList
   * Arg(s):
   * 
   * Return:
   *    - success: A list of diets
   *    - failure: null
   */
  Future<List<Diet>> getDietList () async {

    print("Getting full list of diets...");

    // Make API call
    final response = await http.get(
      "https://thecookmate.com/api/recipe/diet",
      headers: { "Authorization":"Token $_authToken" }
    );

    // Validate return
    int statusCode = response.statusCode ~/ 100;
    if(statusCode != _SUCCESS)
    {
      print("Request for diet list failed");
      print(_interpretStatus(statusCode, response.statusCode, response.body));
      return null;
    }

    // Parse JSON & build ingredient list
    List<dynamic> data = jsonDecode(response.body);
    List<Diet> diets = new List<Diet>();
    Diet diet;
    for(int i = 0; i < data.length; i++)
    {
      diet = Diet.fromJSON(data[i]);
      diets.add(diet);
    }

    return diets;
  }
  /* Method: getCuisineList
   * Arg(s):
   *
   * Return:
   *    - success: A list of cuisines
   *    - failure: null
   */
  Future<List<Cuisine>> getCuisineList () async {

    print("Getting full list of cuisines...");

    // Make API call
    final response = await http.get(
        "https://thecookmate.com/api/recipe/cuisine",
        headers: { "Authorization":"Token $_authToken" }
    );

    // Validate return
    int statusCode = response.statusCode ~/ 100;
    if(statusCode != _SUCCESS)
    {
      print("Request for cuisine list failed");
      print(_interpretStatus(statusCode, response.statusCode, response.body));
      return null;
    }

    // Parse JSON & build ingredient list
    List<dynamic> data = jsonDecode(response.body);
    List<Cuisine> cuisines = new List<Cuisine>();
    Cuisine cuisine;
    for(int i = 0; i < data.length; i++)
    {
      cuisine = Cuisine.fromJSON(data[i]);
      cuisines.add(cuisine);
    }

    return cuisines;
  }

  /* Method: getBreadcrumbs
   * Arg(s):
   *    - barcode: The UPC of the item scanned
   * 
   * Return:
   *    - success: A list of breadcrumbs
   *    - failure: null
   */
  Future<List<String>> getBreadcrumbs (String barcode) async {

    print("Getting ingredient breadcrumbs from barcode $barcode");

    // Make API call
    var params = { "barcode":barcode };
    final uri = Uri.https("thecookmate.com", "/api/barcode/", params);
    final response = await http.get(uri, headers: { "Authorization":"Token $_authToken" });

    // Validate return
    int statusCode = response.statusCode ~/ 100;
    if(statusCode != _SUCCESS)
    {
      print("Request for ingredient failed");
      print(_interpretStatus(statusCode, response.statusCode, response.body));
      return null;
    }

    // Parse JSON & build ingredient list
    var data = jsonDecode(response.body);
    List<dynamic> dataValues = data['label'];
    List<String> breadcrumbs = new List(dataValues.length);
    for(int i = 0; i < dataValues.length; i++)
    {
      print("Breadcrumb ${i + 1}: ${dataValues[i].toString()}");
      breadcrumbs[i] = dataValues[i].toString();
    }

    return breadcrumbs;
  }

  /*Future<Recipe> getRecipe (String apiID) async {

    print("Getting recipe with api id $apiID...");

    // Make API call
    final response = await http.get(
      "https://thecookmate.com/api/recipe/recipeInfo?recipe_id=$recipeID", 
      headers: { "Authorization":"Token $_authToken" }
    );

    // Validate return
    int statusCode = response.statusCode ~/ 100;
    if(statusCode != _SUCCESS)
    {
      print("Request for recipe failed");
      print(_interpretStatus(statusCode, response.statusCode, response.body));
      return null;
    }

    return Recipe.complete(jsonDecode(response.body));
  }*/

  void getPopularRecipes () async {

    print("Getting full list of popular recipes...");

    // Make API call
    final response = await http.get(
      "https://thecookmate.com/api/recipe/popular/", 
      headers: { "Authorization":"Token $_authToken" }
    );

    // Validate return
    int statusCode = response.statusCode ~/ 100;
    if(statusCode != _SUCCESS)
    {
      print("Request for popular recipes failed");
      print(_interpretStatus(statusCode, response.statusCode, response.body));
      return null;
    }

    print(response.body);
  }

  /* Method: addMealToCalendar
   * Arg(s):
   *    - recipeID: The id of the recipe to add
   *    - day: The day to add to
   *    - month: The month to add to
   *    - year: The year to add to
   * 
   * Return:
   *    - success: ID of the calendar meal
   *    - failure: null
   */
  Future<Meal> addMealToCalendar (Recipe recipe, Date date) async {

    print("Adding ${recipe.title} to ${date.getDate}");

    // Make API call
    final response = await http.post(
      "https://thecookmate.com/api/calendar/", 
      headers: { "Authorization":"Token $_authToken" },
      body: {
        "user":"$_userID",
        "recipe":recipe.id.toString(),
        "date":"${date.getDate}"
      }
    );

    // Validate return
    int statusCode = response.statusCode ~/ 100;
    if(statusCode != _SUCCESS)
    {
      print(_interpretStatus(statusCode, response.statusCode, response.body));
      return null;
    }

    var data = jsonDecode(response.body);
    print("Added meal succesfully, meal has ID ${data['id']}");

    return Meal.fromJSON(recipe, data);
  }

  /* Method: getMeals
   * Arg(s):
   *    - startDate: The beginning of the calendar range to get meals from
   *    - endDate: The end of the calendar range to get meals from
   * 
   * Return:
   *    - success: ID of the calendar meal
   *    - failure: null
   */
  Future<List<Meal>> getMeals ({Date startDate, Date endDate}) async {

    int _paramCount = 0;
    if(startDate != null) {
      _paramCount++;
    }
    if(endDate != null) {
      _paramCount++;
    }

    // Make API call
    var response;
    if(_paramCount == 0) { // Get all calendars
      print("Getting all meals for user $_userID");

      response = await http.get(
        "https://thecookmate.com/api/calendar/$_userID", 
        headers: { "Authorization":"Token $_authToken" }
      );
    } else if(_paramCount < 2) { // Error in param. passing
      print("ERROR: Must specify full date range");
      return null;
    } else { // Get calendars in specific date range
      print("Getting meals for user between ${startDate.getDate} and ${endDate.getDate}");

      // Make API call
      final url = "https://thecookmate.com/api/calendar/$_userID/range/?start=${startDate.getDate}&end=${endDate.getDate}";
      response = await http.get(url, headers: { "Authorization":"Token $_authToken" });
    }

    // Validate return
    int statusCode = response.statusCode ~/ 100;
    if(statusCode != _SUCCESS)
    {
      print(_interpretStatus(statusCode, response.statusCode, response.body));
      return null;
    }

    print("Meal request successful");

    List<Meal> meals = List<Meal>();
    var data = jsonDecode(response.body);
    String log = "\n\n MEALS \n------------";
    for(var meal in data) {
      Recipe recipe = Recipe.forCalendar(meal['recipe']);
      meals.add(Meal.fromJSON(recipe, meal));
      log += "\n\t${meal['id']}, ${meal['date']}";
    }

    print(log);
    return meals;
  }

  /* Method: updateMealInCalendar
   * Arg(s):
   *    - meal: The meal to update
   *    - newRecipe (optional): The recipe to change the meal to
   *    - newDate (optional): The date to change the meal to
   * 
   * Return:
   *    - success: true
   *    - failure: fail
   * 
   * Note: Must pass in at least one of the optional arguments
   */
  /*Future<bool> updateMealInCalendar (Meal meal, { Recipe newRecipe, Date newDate }) async {

    if(newRecipe != null) {
      print("Changing meal ${meal.id} from ${meal.recipe.title} to ${newRecipe.title}");
    }

    if(newDate != null) {
      print("Changing meal ${meal.id} from ${meal.date.getDate} to ${newDate.getDate}");
    }

    String dateToPass = meal.date.getDate;
    String recipeToPass = meal.recipe.id.toString();

    if(newRecipe != null) {
      recipeToPass = newRecipe.id.toString();
    }

    if(newDate != null) {
      dateToPass = newDate.getDate;
    }

    print(recipeToPass);
    print(dateToPass);

    // Make API call
    final response = await http.put(
      "https://thecookmate.com/api/calendar/update/${meal.id}/", 
      headers: { "Authorization":"Token $_authToken" },
      body: {
        "recipe":recipeToPass,
        "date":dateToPass
      }
    );

    // Validate return
    int statusCode = response.statusCode ~/ 100;
    if(statusCode != _SUCCESS) {
      print(_interpretStatus(statusCode, response.statusCode, response.body));
      return false;
    }

    return true;
  }*/

  /* Method: deleteMealFromCalendar
   * Arg(s):
   *    - meal (optional): The meal to delete from the calendar
   *    - mealID (optional): The ID of the meal to delete from the calendar
   * 
   * Return:
   *    - success: true
   *    - failure: false
   *    - error: null
   * 
   * Note: Must pass either the meal or the mealID. If neither are passed in
   *       error. If meal is passed in, mealID will never be used.
   */
  Future<bool> deleteMealFromCalendar ({Meal meal, int mealID}) async {

    int id;
    if(meal != null) {
      print("Deleting ${meal.recipe.title} from ${meal.date.getDate}");
      id = meal.id;
    } else if (mealID != null) {
      print("Deleting $mealID from the calendar");
      id = mealID;
    } else {
      print("Error: Invalid parameters");
      return null;
    }

    // Make API call
    final response = await http.delete(
      "https://thecookmate.com/api/calendar/delete/$id/", 
      headers: { "Authorization":"Token $_authToken" }
    );

    // Validate return
    int statusCode = response.statusCode ~/ 100;
    if(statusCode != _SUCCESS)
    {
      print(_interpretStatus(statusCode, response.statusCode, response.body));
      return false;
    }

    print("Meal deleted from calendar");
    return true;
  }

  /* Method: _interpretStatus
   * Arg(s):
   *    - statusSode: The reduced code to determine error type
   *    - responseCode: The actual status code produced by the response
   * 
   * Return: the appropriate status notification/error message
   */
  static String _interpretStatus (int statusCode, int responseCode, String error) {

    String statusReport = "\n\n\t--- Backend Request Failed ---\n\tStatus code $responseCode\n";

    switch(statusCode) {
      case _INFORMATIONAL:
        statusReport = "\n\n\t--- Backend Request In Progress ---\n\tStatus code $statusCode, "; 
        break;
      case _REDIRECT:
        statusReport += "\tRedirect Error";
        break;
      case _CLIENT:
        statusReport += "\tClient Error";
        break;
      case _SERVER:
        statusReport += "\tServer Error";
        break;
    }

    var message = jsonDecode(error);
    statusReport += ": ${message['error']}";
    return statusReport;
  }
}