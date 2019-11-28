import 'package:cookmate/cookbook.dart';
import 'package:cookmate/util/backendRequest.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MyCalendar extends StatefulWidget {
  final Recipe recipe;
  MyCalendar({Key key, this.recipe}): super(key: key);
  @override
  State<StatefulWidget> createState() {
    return Calendar();
  }
}

class Calendar extends State<MyCalendar> {
  CalendarController _controller;
  BackendRequest backendRequest;
  List<Meal> ml;
  List<Meal> dayML;
  List<int> idL;
  bool isDateSet;
  Date st;
  Date en;
  Meal meal;
  Recipe addToCalendar;
  Date selectedDay;
  String selectedDayString;
  bool isDeleted;
  bool add;
  DateTime today;
  DateTime start;
  DateTime end;
  String message = "Select a day";

  Calendar() {
    add = true;
    //this.addToCalendar = widget.recipe;
    //if (widget.recipe != null) {
      //this.select = true;
      //this.message= "select a day";
    //}
    this.backendRequest =
      new BackendRequest("e27dc27ab455de7a3afa076e09e0eacff2b8eefb", 6);
    this.today = new DateTime.now();
    this.start = today.subtract(new Duration(days: 7));
    this.end = today.add(new Duration(days: 14));
    this.st = new Date(start.year, start.month, start.day);
    this.en = new Date(end.year, end.month, end.day);
    //rl = [];
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
        body: SingleChildScrollView(
          child: Column(
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
                  //print("A ${widget.recipe.title}");
                    if (widget.recipe != null && add){
                      /*setState(() {
                        dayML.add(new Meal(12231, widget.recipe, new Date(date.year, date.month, date.day)));
                      });*/
                      backendRequest.addMealToCalendar(widget.recipe, new Date(date.year, date.month, date.day)).then((meal){
                          backendRequest.getMeals(startDate: st, endDate: en).then((list) {
                            setState(() {
                              ml.clear();
                              for (int i = 0; i < list.length; i++) {
                                Meal m = new Meal(list[i].id, list[i].recipe, list[i].date);
                                ml.add(m);
                              }
                              add = false;
                              this.dayML.clear();
                              selectedDayString =
                              "${date.year}-${date.month}-${date.day}";
                              for (Meal meal in ml) {
                                if (meal.date.getDate.compareTo(selectedDayString) == 0) {
                                  this.dayML.add(meal);
                                }
                              }
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
                height: 200,
                color: Colors.red,
                child: dayML.isNotEmpty
                    ? ListView.builder(
                        itemCount: dayML.length,
                        itemBuilder: (context, index) {
                          return Container(
                              height: 100,
                              width: 100,
                              child: Wrap(
                                children: <Widget>[
                                  dayML[index].recipe.image,
                                  Text(dayML[index].recipe.title),
                                  FlatButton(
                                    child: Text("X"),
                                    onPressed: () {
                                      //Meal m = new Meal(this.dayML[index].id, this.dayML[index].recipe, this.dayML[index].date );
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
              ListTile(
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
                          ml.add(new Meal(recipe1.id, recipe1, d1));
                          ml.add(new Meal(recipe2.id, recipe2, d2));
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
              ),
              ListTile(
                title: add ? Text(message): Text(""),
              ),
            ],
          ),
        ));
  }
}
