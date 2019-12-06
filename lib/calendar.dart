import 'package:cookmate/cookbook.dart';
import 'package:cookmate/recipe.dart';
import 'package:cookmate/search.dart';
import 'package:cookmate/util/backendRequest.dart';
import 'package:cookmate/util/cookmateStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cookmate/util/localStorage.dart' as LS;

/*
  File: calendar.dart
  Functionality: This page displays the calendar for the user. It displays 
  a week at a time and a user can select a day and the meals that they have 
  added for that day will load. It allows for the user to remove and add 
  recipes to the calendar.
*/

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
  List<Meal> ml;
  List<Meal> todayMeals;
  List<Meal> dayML;
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
  bool firstTime;
  Future<bool>_getUserInfo() async {
    int userID = await LS.LocalStorage.getUserID();
    String token = await LS.LocalStorage.getAuthToken();
    backendRequest= BackendRequest(token, userID);
    if (backendRequest == null) {
      return false;
    }
    else {
      return true;
    }
  }
  Calendar(Recipe recipe) {
    if (recipe != null){
      this.addRecipe = recipe;
    }
    //firstTime = false;
    this.today = new DateTime.now();
    this.start = today.subtract(new Duration(days: 7));
    this.end = today.add(new Duration(days: 14));
    this.st = new Date(start.year, start.month, start.day);
    this.en = new Date(end.year, end.month, end.day);
    this.dayML = [];
    this.ml = [];
    this.todayMeals = [];
  }
  @override
  void initState() {
    super.initState();
    this.firstTime = true;
    selectedDay = new Date(today.year, today.month, today.day);
    selectedDayString = "${today.year}-${today.month}-${today.day}";
    _controller = CalendarController();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: NavBar(title: "Calendar", titleSize: 16, hasReturn: true, isCalendar: true,),
        body:
        SingleChildScrollView(
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TableCalendar(
                calendarController: _controller,
                initialCalendarFormat: CalendarFormat.twoWeeks,
                initialSelectedDay: today,
                startDay: start,
                endDay: end,
                calendarStyle: CalendarStyle(
                    selectedColor: Colors.redAccent
                ),
                headerStyle: HeaderStyle(
                  formatButtonShowsNext: false,
                  centerHeaderTitle: true,
                  formatButtonVisible: false,
                ),
                onDaySelected: (date, events) {
                  setState(() {
                    selectedDay = new Date(date.year, date.month, date.day);
                    if (addRecipe != null){
                      backendRequest.addMealToCalendar(addRecipe, selectedDay);
                      ml.add(new Meal(99, addRecipe, selectedDay));
                      addRecipe = null;
                    }
                    this.firstTime = false;
                    this.selectedDayString =
                    "${date.year}-${date.month}-${date.day}";
                  });
                },
              ),
              showTotalMeals(),
              //showMeals(),
              /*FloatingActionButton(
                child: Icon(Icons.add),
                backgroundColor: Colors.redAccent,
                onPressed: (){
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) =>
                      new SearchPage()));
                },
              ),*/
            ],
          ),
        ));
  }

  Widget showTotalMeals() {
    print(selectedDayString);
    if (firstTime) {
      return FutureBuilder(
        future: _getUserInfo(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return CookmateStyle.loadingIcon("Checking user ...");
            case ConnectionState.done:
              return FutureBuilder(
                future: this.backendRequest.getMeals(
                    startDate: st, endDate: en),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return CookmateStyle.loadingIcon("Getting meals ...");
                    case ConnectionState.done:
                      this.ml = snapshot.data;
                      if (ml.isNotEmpty) {
                        print("MEAL LIST SIZE: " + ml.length.toString());
                      }
                      this.todayString =
                      "${today.year}-${today.month}-${today.day}";
                      for (Meal meal in this.ml){
                        if (meal.date.getDate.compareTo(todayString) == 0) {
                          this.todayMeals.add(meal);
                        }
                      }
                      if (this.todayMeals.isNotEmpty) {
                        print("TODAY LIST SIZE: " + todayMeals.length.toString());
                      }
                      return showAll();
                    default:
                      return Text("error");
                  }
                },
              );
            default:
              return Text("error");
          }
        },
      );
    }
    else {
      return showAll();
    }
  }
  Widget showAll(){
    dayML.clear();
    for (Meal meal in ml) {
      if (meal.date.getDate.compareTo(selectedDayString) == 0) {
        dayML.add(meal);
      }
    }
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              height: 30,
              margin: EdgeInsets.all(10),
              child: Text("Total Meals: " +
                  (dayML.isNotEmpty ? (dayML.length.toString()) : "0")),
            ),
            Container(
              height: 30,
              margin: EdgeInsets.all(10),
              child: (addRecipe != null) ? Text(
                message, style: TextStyle(fontSize: 14),) : Text(""),
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
              return Container(
                  padding: EdgeInsets.all(4.00),
                  height: 250,
                  width: 190,
                  child: Column(
                    children: <Widget>[
                      FlatButton(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: dayML[index].recipe.image,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RecipeDisplay("${dayML[index].recipe.apiID}"))
                          );
                        },
                      ),
                      Text(dayML[index].recipe.title),
                      FloatingActionButton(
                        child: Wrap(
                          children: <Widget>[
                            Container(
                              //margin: EdgeInsets.symmetric(vertical: 5.00, horizontal: 20.00),
                              padding: EdgeInsets.all(4.0),
                              child: Icon(Icons.remove, color: Colors.black,),
                            )
                          ],
                        ),
                        backgroundColor: Colors.white,
                        onPressed: () {
                          setState(() {
                            backendRequest.deleteMealFromCalendar(meal: dayML[index]);
                            ml.remove(dayML[index]);
                            dayML.removeAt(index);
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
        )
      ],
    );
  }
}


