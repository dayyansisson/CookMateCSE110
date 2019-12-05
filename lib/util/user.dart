class UserProfile {

  String authToken;
  int id;
  String email;
  String username;
  String password;
  Map<String, dynamic> diet;
  List<Map<String, dynamic>> allergens;

  UserProfile(
    int id, 
    Map<String, 
    dynamic> diet, 
    List<Map<String, dynamic>> allergens
    ) : 
      this.allergens = allergens, this.diet = diet, this.id = id;

  UserProfile.fromJSON(Map<String, dynamic> json) {
    
    id = json['id'];
    var diet = json['diet'];
    if(diet != null)
    {
      this.diet = diet;
    } else {
      this.diet = Map<String, dynamic>();
    }
    var allergens = json['allergens'];
    if(allergens != null)
    {
      this.allergens = List<Map<String, dynamic>>.from(allergens);
    } else {
      this.allergens = List<Map<String, dynamic>>();
    }
  }

  @override String toString() {

    String string = "\n\nUser $id\n-------------";
    string += "\nDiet: ${diet.toString()}";
    string += "\nAllergens: ";
    for(int i = 0; i < allergens.length; i++)
    {
      string += "(${allergens[i]["name"]}, ${allergens[i]["id"]}), ";
    }
    return string;
  }
}