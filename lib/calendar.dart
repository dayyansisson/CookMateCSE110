
import 'package:cookmate/cookbook.dart';
import 'package:cookmate/recipe.dart';
import 'package:cookmate/searchResultPage.dart';
import 'package:cookmate/util/backendRequest.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

// ignore: must_be_immutable
class MyCalendar extends StatefulWidget {
  Recipe recipe;
  MyCalendar({Key key, this.recipe}): super(key: key);
  @override
  State<StatefulWidget> createState() {
    return Calendar(recipe);
  }
}

class Calendar extends State<MyCalendar> {
  CalendarController _controller;
  BackendRequest backendRequest;
  Future <List<Meal>> mealFuture;
  Future<Meal> mealListFuture;
  Future<bool> deleteFuture;
  List<Meal> ml;
  //List<Meal> temp;
  List<Meal> todayMeals;
  List<Meal> dayML;
  bool isDateSet;
  Date st;
  Date en;
  Meal meal;
  Recipe addToCalendar;
  Date selectedDay;
  String selectedDayString;
  DateTime today;
  DateTime start;
  DateTime end;
  String message = "Select a day";
  Recipe addRecipe;

  Calendar(Recipe recipe) {
    if (recipe != null){
      this.addRecipe = new Recipe(recipe.apiID);
      this.addRecipe.title = recipe.title;
      this.addRecipe.imageURL = "https://spoonacular.com/recipeImages/" + addRecipe.apiID.toString() + "-312x231.jpg";
      //this.addRecipe.image =
      //this.addRecipe.image =
      //this.addRecipe.apiID = null;
    }
    this.backendRequest =
      new BackendRequest("e27dc27ab455de7a3afa076e09e0eacff2b8eefb", 6);
    this.today = new DateTime.now();
    this.start = today.subtract(new Duration(days: 7));
    this.end = today.add(new Duration(days: 14));
    this.st = new Date(start.year, start.month, start.day);
    this.en = new Date(end.year, end.month, end.day);
    this.dayML = [];
    this.ml = [];
    backendRequest.getMeals(startDate: st, endDate: en).then((list) {
      for (int i = 0; i < list.length; i++) {
        Meal m = new Meal(list[i].id, list[i].recipe, list[i].date);
        ml.add(m);
      }
    });
    /*this.dayML.clear();
    selectedDayString =
    "${today.year}-${today.month}-${today.day}";
    for (Meal meal in ml) {
      if (meal.date.getDate.compareTo(selectedDayString) == 0) {
        this.dayML.add(meal);
      }
    }*/
  }
  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Calendar"),
        ),
        body: SingleChildScrollView(
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TableCalendar(
                calendarController: _controller,
                initialCalendarFormat: CalendarFormat.week,
                startDay: start,
                endDay: end,
                headerStyle: HeaderStyle(
                  formatButtonShowsNext: false,
                  centerHeaderTitle: true,
                  formatButtonVisible: true,
                ),
                onDaySelected: (date, events) {
                    if (addRecipe != null){
                      //print("ID:" + addRecipe.id.toString());
                      //print("ImageURL: " + addRecipe.imageURL);
                      //print("Title: " +addRecipe.title);
                      //print("apiID: " + addRecipe.apiID.toString());
                      //print("Image: " +((addRecipe.image == null) ? "Null" : "Not Null"));
                      //print("Calories: " + this.addRecipe.calories.toString());
                      //print("cookTime: " +this.addRecipe.cookTime.toString());
                      //print("Ingredients: " + (addRecipe.getIngredients() == null ? "Null" : "Not Null"));
                      //print("Instructions: " + (addRecipe.getInstructions() == null ? "Null" : "Not Null"));
                      backendRequest.addMealToCalendar(addRecipe, new Date(date.year, date.month, date.day)).then((meal){
                          /*print("Returned Meal");
                          print(meal.recipe.title);
                          print(meal.recipe.imageURL);
                          print(meal.recipe.id.toString());*/
                          /*setState(() {
                            if (ml.isNotEmpty){
                              for (int i = 0; i < ml.length; i++) {
                                this.temp.add(ml[i]);
                              }
                              ml.clear();
                              for (int i = 0; i < ml.length; i++) {
                                this.ml.add(temp[i]);
                              }
                            }
                            ml.add(meal);
                          });*/
                         backendRequest.getMeals(startDate: st, endDate: en).then((list) {
                            /*print("----------List--------------");
                            for (int i = 0; i < list.length; i++) {
                              print(list[i].recipe.title);
                            }
                            print("----------------------------");*/
                            setState(() {
                              ml.clear();
                              for (int i = 0; i < list.length; i++) {
                                Meal m = new Meal(list[i].id, list[i].recipe, list[i].date);
                                ml.add(m);
                              }
                              /*print("-------------ML------------");
                              for (int i = 0; i < ml.length; i++) {
                                print(ml[i].recipe.title);
                              }*/
                              this.dayML.clear();
                              selectedDayString =
                              "${date.year}-${date.month}-${date.day}";
                              for (Meal meal in ml) {
                                if (meal.date.getDate.compareTo(selectedDayString) == 0) {
                                  this.dayML.add(meal);
                                }
                              }
                             addRecipe = null;
                            });
                          });
                      });
                    }
                    else {
                      setState(() {
                        this.dayML.clear();
                        selectedDayString =
                        "${date.year}-${date.month}-${date.day}";
                        for (Meal meal in ml) {
                          if (meal.date.getDate.compareTo(selectedDayString) == 0) {
                            this.dayML.add(meal);
                          }
                        }
                      });
                    }
                },
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.00),
                height: 250,
                color: Colors.white,
                child: dayML.isNotEmpty
                    ? ListView.builder(
                        itemCount: dayML.length,
                        itemBuilder: (context, index) {
                          print("In List view");
                          print(dayML[index].recipe.imageURL);
                          print(dayML[index].recipe.title);
                          return Container(
                              padding: EdgeInsets.all(4.00),
                              height: 180,
                              width: 160,
                              child: Wrap(
                                children: <Widget>[
                                  //Image.network(dayML[index].recipe.imageURL),
                                  FlatButton(
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),

                                        child: Image.network(
                                            dayML[index].recipe.imageURL,
                                            width: 160
                                        )
                                    ),
                                    onPressed: () {
                                    },
                                  ),
                                  //dayML[index].recipe.image,
                                  Text(dayML[index].recipe.title),
                                  FloatingActionButton(
                                    child: Icon(Icons.remove),
                                    backgroundColor: Colors.redAccent,
                                    onPressed: () {
                                      backendRequest.deleteMealFromCalendar(meal: dayML[index]).then((deleted){
                                        print("deleted");
                                        setState(() {
                                          ml.remove(dayML[index]);
                                          dayML.removeAt(index);
                                        });
                                      });
                                    },
                                  ),
                                ],
                              ));
                        },
                        scrollDirection: Axis.horizontal,
                      )
                    : Container(
                        child: ListTile(
                        title: Text("No Meals"),
                      )),
              ),
              /*ListTile(
                title: Text("Add Meals"),
                onTap: () {
                  Recipe recipe1 = new Recipe(716429);
                  recipe1.title = "Pasta with Garlic, Scallions, Cauliflower & Breadcrumbs";
                  recipe1.imageURL = "https://spoonacular.com/recipeImages/716429-312x231.jpg";
                  Recipe recipe2 = new Recipe(73420);
                  recipe2.title = "Apple Or Peach Strudel";
                  recipe2.imageURL = "https://spoonacular.com/recipeImages/73420-312x231.jpg";
                  DateTime dt1 = start.add(new Duration(days: 1));
                  DateTime dt2 = start.add(new Duration(days: 2));
                  DateTime dt3 = start.add(new Duration(days: 3));
                  Date d1 = new Date(dt1.year, dt1.month, dt1.day);
                  Date d2 = new Date(dt2.year, dt2.month, dt2.day);
                  Date d3 = new Date(dt3.year, dt3.month, dt3.day);

                  backendRequest.addMealToCalendar(recipe1, d1).then((meal){
                    backendRequest.addMealToCalendar(recipe2, d2).then((meal){
                      setState(() {
                          ml.add(new Meal(recipe1.apiID, recipe1, d1));
                          ml.add(new Meal(recipe2.apiID, recipe2, d2));
                          backendRequest.getMeals(startDate: st, endDate: en).then((list) {
                            ml.clear();
                            dayML.clear();
                            for (int i = 0; i < list.length; i++) {
                              Meal m = new Meal(list[i].id, list[i].recipe, list[i].date);
                              ml.add(m);
                            }
                          });
                        });
                    });
                  });
                },
              ),*/
              ListTile(
                title: (addRecipe != null) ? Text(message): Text(""),
              ),
              FloatingActionButton(
                child: Icon(Icons.add),

                backgroundColor: Colors.redAccent,
                onPressed: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) =>
                          SearchResultPage(
                              backendRequest.recipeSearch(
                                  ingredients: ["Mozzarella"],
                                  maxCalories: 1000))));
                },
              ),
              Container(
                child: (widget.recipe != null) ? widget.recipe.image : Text("No Image"),

              )
            ],
          ),
        ));
  }
}
