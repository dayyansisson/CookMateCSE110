import 'package:cookmate/cookbook.dart';
import 'package:cookmate/recipe.dart';
import 'package:cookmate/search.dart';
import 'package:cookmate/searchResultPage.dart';
import 'package:cookmate/util/backendRequest.dart';
import 'package:cookmate/util/cookmateStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart' as prefix0;
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
  List<Meal> todayMeals;
  List<Meal> dayML;
  bool isDateSet;
  Date st;
  Date en;
  Meal meal;
  Recipe addToCalendar;
  Date selectedDay;
  String selectedDayString;
  String todayString;
  DateTime today;
  DateTime start;
  DateTime end;
  String message = "Select a day";
  Recipe addRecipe;

  Calendar(Recipe recipe) {
    if (recipe != null){
      this.addRecipe = recipe;
      //print(this.addRecipe.imageURL);
      /*this.addRecipe = new Recipe(recipe.apiID);
      this.addRecipe.title = recipe.title;
      this.addRecipe.imageURL = "https://spoonacular.com/recipeImages/" + addRecipe.apiID.toString() + "-312x231.jpg";*/
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
        body:
        SingleChildScrollView(
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TableCalendar(
                calendarController: _controller,
                initialCalendarFormat: CalendarFormat.week,
                initialSelectedDay: today,
                startDay: start,
                endDay: end,
                calendarStyle: CalendarStyle(
                  //todayColor: Colors.green,
                  selectedColor: Colors.redAccent
                ),
                daysOfWeekStyle: DaysOfWeekStyle(

                ),
                headerStyle: HeaderStyle(
                  formatButtonShowsNext: false,
                  centerHeaderTitle: true,
                  formatButtonVisible: false,
                ),
                onDaySelected: (date, events) {
                    if (addRecipe != null){
                      backendRequest.addMealToCalendar(addRecipe, new Date(date.year, date.month, date.day)).then((meal){
                         backendRequest.getMeals(startDate: st, endDate: en).then((list) {
                            setState(() {
                              ml.clear();
                              for (int i = 0; i < list.length; i++) {
                                Meal m = new Meal(list[i].id, list[i].recipe, list[i].date);
                                ml.add(m);
                              }
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

              /*FutureBuilder(
                future: mealFuture,
                builder: (futureContext, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting: // this handles waiting for the async call
                      return CookmateStyle.loadingIcon("Loading recipe...");
                    case ConnectionState.done:
                    default:
                      return Text("error");
                  }
                },
              ),*/
              Row(
                children: <Widget>[
                  Container(
                    height: 30,
                    margin: EdgeInsets.all(10),
                    child: Text("Total Meals: " + (dayML.isNotEmpty ? (dayML.length.toString()) : "0")),
                  ),
                  Container(
                    height: 30,
                    margin: EdgeInsets.all(10),
                    child: (addRecipe != null) ? Text(message, style: TextStyle(fontSize: 14),): Text(""),
                    //child: (addRecipe != null) ? showDialog(context: context, child :new AlertDialog(content: Text(message),)) : Text("")
                  ),
                ],
              ),

              Container(
                //margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.00),
                height: 280,
                color: Colors.white,
                child: dayML.isNotEmpty
                    ? ListView.builder(
                        itemCount: dayML.length,
                        itemBuilder: (context, index) {
                          print("In List view");
                          print(dayML[0].date.getDate);
                          print(dayML[index].recipe.imageURL);
                          print(dayML[index].recipe.title);
                          return Container(
                              padding: EdgeInsets.all(2.00),
                              height: 240,
                              width: 182,
                              child: Column(
                                children: <Widget>[
                                  //Image.network(dayML[index].recipe.imageURL),
                                  FlatButton(
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: dayML[index].recipe.image,
                                        /*child: Image.network(
                                            dayML[index].recipe.imageURL,
                                            width: 160
                                        )*/
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => RecipeDisplay(backendRequest.getRecipe("${dayML[index].recipe.apiID}")))
                                      );
                                    },
                                  ),
                                  //dayML[index].recipe.image,
                                  Text(dayML[index].recipe.title),
                                  /*ListTile(
                                    trailing: Icon(Icons.remove_circle),
                                    onTap: (){
                                      backendRequest.deleteMealFromCalendar(meal: dayML[index]).then((deleted){
                                        print("deleted");
                                        setState(() {
                                          ml.remove(dayML[index]);
                                          dayML.removeAt(index);
                                        });
                                      });
                                    },
                                  ),*/
                                 FloatingActionButton(
                                    child: Wrap(
                                      children: <Widget>[
                                        Container(
                                          //margin: EdgeInsets.symmetric(vertical: 5.00, horizontal: 20.00),
                                          padding: EdgeInsets.all(4.0),
                                          child: Icon(Icons.remove),
                                        )
                                        //,
                                      ],

                                    ),
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
                ),
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
                  Date d3 = new Date(today.year, today.month, today.day);

                  backendRequest.addMealToCalendar(recipe1, d1).then((meal){
                    backendRequest.addMealToCalendar(recipe2, d2).then((meal){
                      backendRequest.addMealToCalendar(recipe2, d3).then((meal){
                        setState(() {
                          ml.add(new Meal(recipe1.apiID, recipe1, d1));
                          ml.add(new Meal(recipe2.apiID, recipe2, d2));
                          ml.add(new Meal(recipe2.apiID, recipe2, d3));
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
                  });
                },
              ),*/
              FloatingActionButton(
                child: Icon(Icons.add),
                backgroundColor: Colors.redAccent,
                onPressed: (){
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) =>
                          new SearchPage()));
                },
              ),
              /*Container(
                child: (widget.recipe != null) ? widget.recipe.image : Text("No Image"),

              )*/
            ],
          ),
        ));
  }
}
