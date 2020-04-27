import 'dart:async';

import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:mifadeschats/app/home/meals/meal_calendar.dart';
import 'package:mifadeschats/app/home/meals/pet_state.dart';
import 'package:mifadeschats/widget/button/awesome_button.dart';
import 'package:mifadeschats/widget/list/list_items_builder.dart';
import 'package:mifadeschats/widget/utils/reponsive_safe_area.dart';
import 'package:mifadeschats/models/meal.dart';
import 'package:mifadeschats/models/mifa.dart';
import 'package:mifadeschats/services/singleton/local_notification.dart';
import 'package:provider/provider.dart';
import 'package:mifadeschats/services/database.dart';

import 'meal_item.dart';

class MealsPage extends StatefulWidget {
  @override
  _MealsPageState createState() => _MealsPageState();
}

class _MealsPageState extends State<MealsPage> {
  ScrollController _scrollController = new ScrollController();
  FlareControls _controls = FlareControls();
  Timer _timer;

  Future _showNotification(BuildContext context) async {
    final localNotification = getIt.get<LocalNotification>();

    if (localNotification.allowNotification) {
      await localNotification.setNotification();
    }
  }

  void startAnimation() {
    _controls.play("Animations");
    new Timer(Duration(seconds: 1), () => _controls.play("Animations"));
    const oneSec = const Duration(seconds: 15);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        _controls.play("Animations");
      },
    );
  }

  @override
  void initState() {
    super.initState();
    startAnimation();
  }

  void _scrollToEnd() {
    _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 200,
        duration: new Duration(seconds: 2),
        curve: Curves.ease);
  }

  Widget _buildQuickMealButton(
      BuildContext context, Database database, Mifa mifa, Size size) {
    return Positioned(
      bottom: size.height / 6,
      left: size.width / 1.5,
      child: AwesomeButton(
        blurRadius: 10.0,
        splashColor: Colors.orange[400],
        borderRadius: BorderRadius.circular(37.5),
        height: 40.0,
        width: 100,
        onTap: () async {
          _showNotification(context);

          if (mifa.nbOfMeal > 6) {
            _scrollToEnd();
          }

          await database.setMeal(
              mifa.id,
              Meal(
                id: documentUniqueId(),
                date: DateTime.now(),
                comment: '',
              ));

          await database.setMifa(Mifa(
            id: mifa.id,
            lastMealDate: DateTime.now(),
            name: mifa.name,
            nbOfMeal: mifa.nbOfMeal + 1,
          ));
        },
        color: Colors.orange[600],
        child: Text(
          "Miam",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 22.0,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context);
    final mifa = Provider.of<Mifa>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 100),
        child: SafeArea(
          child: MealCalendar(
            mifa: mifa,
            database: database,
          ),
        ),
      ),
      body: ResponsiveSafeArea(builder: (context, size) {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            _buildContents(context, database, mifa),
            _buildQuickMealButton(context, database, mifa, size),
          ],
        );
      }),
    );
  }

  Widget _buildContents(BuildContext context, Database database, Mifa mifa) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: PetState(controls: _controls),
        ),
        Expanded(
          flex: 3,
          child: StreamBuilder<List<Meal>>(
            stream: database.mealsStream(mifa.id, null),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(child: CircularProgressIndicator());
              }
              if (snapshot.data.length == 0) {
                return Container();
              }
              return ListItemBuilder<Meal>(
                controller: _scrollController,
                snapshot: snapshot,
                itemBuilder: (context, model) {
                  return Container(
                    key: ValueKey(model.id),
                    child: MealItem(
                      meal: model,
                      onDelete: () async {
                        await database.deleteMeal(mifa.id, model);
                        await database.setMifa(Mifa(
                          id: mifa.id,
                          name: mifa.name,
                          lastMealDate: mifa.lastMealDate,
                          nbOfMeal: mifa.nbOfMeal - 1,
                        ));
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
