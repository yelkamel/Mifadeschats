import 'package:flutter/material.dart';
import 'package:mifadeschats/common_widgets/list/list_items_builder.dart';
import 'package:provider/provider.dart';
import 'package:mifadeschats/app/home/meals/meals_bloc.dart';
import 'package:mifadeschats/app/home/meals/meals_list_tile.dart';
import 'package:mifadeschats/services/database.dart';

class MealsPage extends StatelessWidget {
  static Widget create(BuildContext context) {
    final database = Provider.of<Database>(context);
    return Provider<MealsBloc>(
      create: (_) => MealsBloc(database: database),
      child: MealsPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    final bloc = Provider.of<MealsBloc>(context);
    return StreamBuilder<List<MealsListTileModel>>(
      stream: bloc.mealsTileModelStream,
      builder: (context, snapshot) {
        return ListItemBuilder<MealsListTileModel>(
          snapshot: snapshot,
          itemBuilder: (context, model) {
            return MealsListTile(model: model);
          },
        );
      },
    );
  }
}
