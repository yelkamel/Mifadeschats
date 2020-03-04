import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mifadeschats/components/date_time_picker.dart';
import 'package:mifadeschats/models/meal.dart';
import 'package:mifadeschats/models/mifa.dart';
import 'package:mifadeschats/components/platform_exception_alert_dialog.dart';
import 'package:mifadeschats/services/database.dart';
import 'package:provider/provider.dart';

class EditMealPage extends StatefulWidget {
  const EditMealPage({@required this.database, this.mifa, this.meal});
  final Database database;
  final Mifa mifa;
  final Meal meal;
  static Future<void> show({BuildContext context, Meal meal}) async {
    final database = Provider.of<Database>(context, listen: false);
    final mifa = Provider.of<Mifa>(context, listen: false);

    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) =>
            EditMealPage(database: database, mifa: mifa, meal: meal),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _EditMealPageState();
}

class _EditMealPageState extends State<EditMealPage> {
  DateTime _date;
  TimeOfDay _time;
  String _comment;

  @override
  void initState() {
    super.initState();

    _date = widget.meal?.date ?? DateTime.now();
    _comment = widget.meal?.comment ?? '';
    _time = TimeOfDay.now();
  }

  Meal _mealFromState() {
    final id = widget.meal?.id ?? documentUniqueId();
    return Meal(
      id: id,
      date: _date,
      comment: _comment,
    );
  }

  Future<void> _setEntryAndDismiss(BuildContext context) async {
    try {
      final meal = _mealFromState();
      await widget.database.setMeal(widget.mifa.id, meal);
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text('Nourir LES CHATS'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              widget.meal != null ? 'Update' : 'Create',
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            onPressed: () => _setEntryAndDismiss(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildDate(),
              SizedBox(height: 8.0),
              _buildComment(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDate() {
    return DateTimePicker(
      labelText: 'Quand',
      selectedDate: _date,
      selectedTime: _time,
      onSelectedDate: (date) => setState(() => _date = date),
      onSelectedTime: (time) => setState(() => _time = time),
    );
  }

  Widget _buildComment() {
    return TextField(
      keyboardType: TextInputType.text,
      maxLength: 50,
      controller: TextEditingController(text: _comment),
      decoration: InputDecoration(
        labelText: 'Comment',
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      style: TextStyle(fontSize: 20.0, color: Colors.black),
      maxLines: null,
      onChanged: (comment) => _comment = comment,
    );
  }
}
