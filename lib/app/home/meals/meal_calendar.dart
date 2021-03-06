import 'package:calendar_strip/calendar_strip.dart';
import 'package:flutter/material.dart';
import 'package:mifadeschats/models/meal.dart';
import 'package:mifadeschats/models/mifa.dart';
import 'package:mifadeschats/services/database.dart';
import 'package:mifadeschats/utils/format.dart';

class MealCalendar extends StatefulWidget {
  final Database database;
  final Mifa mifa;

  const MealCalendar({Key key, this.database, this.mifa}) : super(key: key);
  @override
  _MealCalendarState createState() => _MealCalendarState();
}

class _MealCalendarState extends State<MealCalendar> {
  DateTime _startDate = DateTime.now().subtract(Duration(days: 99));
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
      _markedDates = mealsDates;
      _startDate = mealsDates.first;
    });
  }

  Widget _monthNameWidget(monthName) {
    return Container(height: 10);
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
    Color fontColor = Theme.of(context).primaryColor;
    TextStyle normalStyle =
        TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: fontColor);
    TextStyle selectedStyle = TextStyle(
        fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white70);
    List<Widget> _children = [
      Text(Format.dayOfWeek(date),
          style: isSelectedDate ? selectedStyle : normalStyle),
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
    return CalendarStrip(
      addSwipeGesture: true,
      startDate: _startDate,
      endDate: _endDate,
      onDateSelected: _onSelect,
      selectedDate: _selectedDate,
      dateTileBuilder: _dateTileBuilder,
      iconColor: Theme.of(context).accentColor,
      monthNameWidget: _monthNameWidget,
      markedDates: _markedDates,
      containerHeight: 100,
    );
  }
}
