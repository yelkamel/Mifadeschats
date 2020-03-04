import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mifadeschats/app/home/pets/edit_pet_page.dart';
import 'package:mifadeschats/app/home/pets/pet_card.dart';
import 'package:mifadeschats/app/onboarding/fade_text_input.dart';
import 'package:mifadeschats/components/button/awesome_button.dart';
import 'package:mifadeschats/components/button/touchable_particule.dart';
import 'package:mifadeschats/components/list/carrousel_items_builder.dart';
import 'package:mifadeschats/components/list/empty_content.dart';
import 'package:mifadeschats/components/reponsive_safe_area.dart';
import 'package:mifadeschats/models/mifa.dart';
import 'package:mifadeschats/models/pet.dart';
import 'package:mifadeschats/services/database.dart';

class MifaSelector extends StatefulWidget {
  final String mifaName;
  final Database database;
  final Function onSelectMifa;
  final Function goBack;

  const MifaSelector(
      {Key key, this.mifaName, this.database, this.onSelectMifa, this.goBack})
      : super(key: key);
  @override
  _MifaSelectorState createState() => _MifaSelectorState();
}

class _MifaSelectorState extends State<MifaSelector> {
  bool loading = true;
  Mifa _mifaSelected = null;

  List<Mifa> _mifas = [];
  List<Mifa> _mifasDisplay = [];

  @override
  void initState() {
    super.initState();

    widget.database.getAllMifa().then((mifaList) {
      setState(() {
        loading = false;
        _mifas = mifaList;
        _mifasDisplay = mifaList.where((mifa) {
          String mifaNameLower = mifa.name.toLowerCase();
          return mifaNameLower.contains(widget.mifaName.toLowerCase());
        }).toList();
      });
    });
  }

  Widget _buildPetCarrousel(mifaId) {
    return Container(
      width: 300,
      height: 300,
      child: FutureBuilder<List<Pet>>(
          future: widget.database.getPetFromMifa(mifaId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.none &&
                snapshot.hasData == null) {
              return CircularProgressIndicator();
            }
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                Pet pet = snapshot.data[index];
                return Card(
                  elevation: Theme.of(context).cardTheme.elevation,
                  color: Theme.of(context).cardTheme.color,
                  shape: Theme.of(context).cardTheme.shape,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      pet.name,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontFamily: "Apercu",
                      ),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }

  Widget _buildItem(BuildContext context, Mifa mifa) {
    return ListTile(
      leading: Icon(Icons.person, color: Theme.of(context).primaryColor),
      onTap: () {
        setState(() {
          _mifaSelected = mifa;
        });
      },
      trailing: Icon(
        Icons.arrow_right,
        color: Theme.of(context).primaryColor,
      ),
      title: Text(
        mifa.name,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontFamily: "Apercu",
        ),
      ),
    );
  }

  Widget _buildAddMifa(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Text(
          "Si vous ne trouvez pas la votre",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontFamily: "Apercu",
            fontSize: 14,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        AwesomeButton(
          blurRadius: 10.0,
          splashColor: Colors.orange[400],
          borderRadius: BorderRadius.circular(37.5),
          onTap: () => EditPetPage.show(context, pet: null),
          color: Colors.orange[600],
          child: Text(
            "Ajouter la mif ${widget.mifaName}",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16.0,
              fontFamily: 'Apercu',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearch(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: FadeTextField(
          hintText: 'rechercher...',
          onChanged: (text) {
            text = text.toLowerCase();
            setState(() {
              _mifasDisplay = _mifas.where((mifa) {
                String mifaNameLower = mifa.name.toLowerCase();
                return mifaNameLower.contains(text);
              }).toList();
            });
          },
          onSubmitEditing: () {},
          unFocusOnSubmit: true,
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return ListView.separated(
      itemCount: _mifasDisplay.length + 1,
      scrollDirection: Axis.vertical,
      separatorBuilder: (context, index) => Divider(
        height: 0.5,
      ),
      itemBuilder: (context, index) {
        if (index == _mifasDisplay.length) {
          return _buildAddMifa(context);
        }
        return _buildItem(context, _mifasDisplay[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('MifaSelector');

    if (loading) {
      return Expanded(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Expanded(child: _buildContent(context));
  }
}
