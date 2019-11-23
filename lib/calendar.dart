
import 'package:cookmate/cookbook.dart';
import 'package:cookmate/util/backendRequest.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class MyCalendar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Calendar2State();
  }

}

class Calendar2State extends State<MyCalendar> {
  CalendarController _controller;
  BackendRequest backendRequest;
  List<Meal> ml;
  bool isDateSet;
  Date st;
  Date en;
  Date selectedDay;
  String selectedDayString;
  int d;
  int m;
  int y;
  int ts;
  bool isDeleted;
  //int l;

  String timeStamp;

  DateTime today;
  DateTime start;
  DateTime end;
  List<Recipe> rl;
  //List<Recipe> todayRecipes;
  Calendar2State(){
    this.backendRequest= new BackendRequest("e27dc27ab455de7a3afa076e09e0eacff2b8eefb", 6);
    this.today = new DateTime.now();
    this.start = today.subtract(new Duration(days: 7 ));
    this.end = today.add(new Duration(days: 14 ));
    this.st =  new Date(start.year, start.month, start.day);
    this.en  = new Date(end.year, end.month, end.day);
    rl = [];
    ml =[];
    this.isDateSet = isDateSet;
    backendRequest.getMeals(startDate: st, endDate: en).then((list){
      for ( int i = 0; i < list.length; i++) {
        Meal m  =  new Meal(list[i].id, list[i].recipe, list[i].date);
        ml.add(m);
        //print(ml[i].recipe.title);
      }
      //print(ml[0].recipe.title);
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

      backgroundColor: Colors.blue,
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
                    formatButtonVisible: false,
                ),
                onDaySelected: (date, events) {
                  setState(() {
                    rl.clear();
                    selectedDay = new Date(date.day, date.month, date.year);
                    selectedDayString = "${date.year}-${date.month}-${date.day}";
                    //selectedDayString = date.year.toString() + "_" + date.month.toString() + "_" + date.day.toString();
                    for (Meal meal in ml){
                     //print("1" + meal.date.getDate);
                     //print("2" + selectedDayString);
                      if (meal.date.getDate.compareTo(selectedDayString) == 0) {
                        rl.add(meal.recipe);
                      }
                    }
                  });
                  /*Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RecipeList( )));*/
                },
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.00),
                height: 200,
                color: Colors.red,
                child: rl.isNotEmpty ? ListView.builder(

          itemCount: rl.length,
                  itemBuilder: (context, index){
                    return Container(
                      height: 100,
                      width: 100,
                      child: Wrap(
                        children: <Widget>[

                          rl[index].image,
                          Text(rl[index].title),
                          FlatButton(
                            child: Text("X"),
                            onPressed: () {
                              setState(() {
                                backendRequest.deleteMealFromCalendar(meal: ml[index]).then((isDeleted){
                                  this.isDeleted = isDeleted;

                                });
                                this.rl.clear();
                                this.ml.clear();
                                backendRequest.getMeals(startDate: st, endDate: en).then((list){
                                  for ( int i = 0; i < list.length; i++) {
                                    Meal m  =  new Meal(list[i].id, list[i].recipe, list[i].date);
                                    ml.add(m);
                                    //print(ml[i].recipe.title);
                                  }
                                  //print(ml[0].recipe.title);
                                });
                              });
                            },


                          ),

                        ],
                      )
                    );
                    //Image(image: images[index]);
                  },
                  scrollDirection: Axis.horizontal,

                ):
                Container(
                  //height: 100,
                  //width: 100,
                  child: ListTile(
                    title: Text("No Meals"),
                  )
                ),
              ),
              ListTile(
                title: Text("Add Meals"),
                onTap: (){

                  Recipe recipe1 = new Recipe(716429
                      ,"Pasta with Garlic, Scallions, Cauliflower & Breadcrumbs", "https://spoonacular.com/recipeImages/716429-312x231.jpg"  );
                  Recipe recipe2 = new Recipe(73420, "Apple Or Peach Strudel", "https://spoonacular.com/recipeImages/73420-312x231.jpg");
                  Recipe recipe3 = new Recipe(73420, "Apple Or Peach Strudel", "https://spoonacular.com/recipeImages/73420-312x231.jpg");
                  DateTime dt1 = start.add(new Duration(days: 1));
                  DateTime dt2 = start.add(new Duration(days: 2));
                  DateTime dt3 = start.add(new Duration(days: 3));
                  Date d1 = new Date(dt1.year, dt1.month, dt1.day);
                  Date d2 = new Date(dt2.year, dt2.month, dt2.day);
                  Date d3 = new Date(dt3.year, dt3.month, dt3.day);

                  setState(() {
                    backendRequest.addMealToCalendar(recipe1, d1);
                    backendRequest.addMealToCalendar(recipe2, d2);
                    backendRequest.addMealToCalendar(recipe3, d3);
                  });
                },
              ),

            ],
          ),
         /* Row(
            children: <Widget>[
              FlatButton(onPressed: null, child: Text('Add'))
            ],
          ),

          ],
        )*/
    ));
  }

}