import 'package:calendar_strip/calendar_strip.dart';
import 'package:flutter/material.dart';
import 'package:mifadeschats/models/meal.dart';
import 'package:mifadeschats/models/mifa.dart';
import 'package:mifadeschats/services/database.dart';

class MealCalendar extends StatefulWidget {
  final Database database;
  final Mifa mifa;

  const MealCalendar({Key key, this.database, this.mifa}) : super(key: key);
  @override
  _MealCalendarState createState() => _MealCalendarState();
}

class _MealCalendarState extends State<MealCalendar> {
  bool _loading = true;
  DateTime _startDate = DateTime.now().subtract(Duration(days: 999));
  DateTime _endDate = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  List<DateTime> _markedDates = [];

  void _onSelect(data) {
    print("Selected Date -> $data");
  }

  @override
  void didChangeDependencies() async {
    List<Meal> meals = await widget.database.getMealFromMifa(widget.mifa.id);

    List<DateTime> mealsDates = meals.map((Meal meal) => meal.date).toList();

    setState(() {
      _loading = false;
      _markedDates = mealsDates;
      _startDate = mealsDates.first;
    });
  }

  Widget _monthNameWidget(monthName) {
    return Container(
      height: 10,
    );
    /*
    return Container(
      child: Text(monthName,
          style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              fontStyle: FontStyle.italic)),
      padding: EdgeInsets.only(top: 8, bottom: 4),
    );
    */
  }

  Widget _getMarkedIndicatorWidget() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        margin: EdgeInsets.only(left: 1, right: 1),
        width: 7,
        height: 7,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: Theme.of(context).accentColor),
      ),
    ]);
  }

  Widget _dateTileBuilder(
      date, selectedDate, rowIndex, dayName, isDateMarked, isDateOutOfRange) {
    bool isSelectedDate = date.compareTo(selectedDate) == 0;
    double opacity = isDateOutOfRange ? 0.4 : 1;
    Color fontColor = Theme.of(context).primaryColorLight;
    TextStyle normalStyle =
        TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: fontColor);
    TextStyle selectedStyle = TextStyle(
        fontSize: 17, fontWeight: FontWeight.w800, color: Colors.white70);
    List<Widget> _children = [
      Text(dayName, style: isSelectedDate ? selectedStyle : normalStyle),
      Text(date.day.toString(),
          style: isSelectedDate ? selectedStyle : normalStyle),
    ];

    if (isDateMarked == true) {
      _children.add(_getMarkedIndicatorWidget());
    }

    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 8, left: 5, right: 5, bottom: 5),
      decoration: BoxDecoration(
        color: !isSelectedDate
            ? Colors.transparent
            : Theme.of(context).primaryColorLight,
        borderRadius: BorderRadius.all(Radius.circular(60)),
      ),
      child: Opacity(
        opacity: opacity,
        child: Column(
          children: _children,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CalendarStrip(
        addSwipeGesture: true,
        startDate: _startDate,
        endDate: _endDate,
        onDateSelected: _onSelect,
        dateTileBuilder: _dateTileBuilder,
        iconColor: Theme.of(context).accentColor,
        monthNameWidget: _monthNameWidget,
        markedDates: _markedDates,
        // containerDecoration: BoxDecoration(color: Colors.black12),
      ),
    );
  }
}
