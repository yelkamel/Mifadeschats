import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mifadeschats/widget/button/awesome_button.dart';
import 'package:mifadeschats/widget/input/fade_text_input.dart';
import 'package:mifadeschats/models/mifa.dart';
import 'package:mifadeschats/models/pet.dart';
import 'package:mifadeschats/services/database.dart';

class MifaSelector extends StatefulWidget {
  final String mifaName;
  final Database database;
  final Function onSelectMifa;
  final Function goBack;
  final Function onAddMifa;

  const MifaSelector(
      {Key key,
      this.mifaName,
      this.database,
      this.onSelectMifa,
      this.goBack,
      this.onAddMifa})
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
      height: 80,
      child: FutureBuilder<List<Pet>>(
          future: widget.database.getPetFromMifa(mifaId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
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
                      padding: const EdgeInsets.all(10.0),
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
            }
            return CircularProgressIndicator();
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
    return AwesomeButton(
      blurRadius: 10.0,
      splashColor: Colors.orange[400],
      borderRadius: BorderRadius.circular(37.5),
      onTap: widget.onAddMifa,
      color: Colors.orange[600],
      child: Text(
        "Ajouter la mif ${widget.mifaName}",
        style: TextStyle(
          color: Colors.white70,
          fontSize: 16.0,
          fontFamily: 'Apercu',
        ),
      ),
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
    return Container(
      child: ListView.separated(
        itemCount: _mifasDisplay.length,
        scrollDirection: Axis.vertical,
        separatorBuilder: (context, index) => Divider(height: 0.5),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return _buildItem(context, _mifasDisplay[index]);
        },
      ),
    );
  }

  Widget _buildLoading() {
    return Expanded(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildBack() {
    return AwesomeButton(
      width: 60,
      blurRadius: 10.0,
      splashColor: Colors.orange[400],
      borderRadius: BorderRadius.circular(20),
      onTap: widget.goBack,
      color: Colors.orange[600],
      child: Text(
        "Retour",
        style: TextStyle(
          color: Colors.white70,
          fontSize: 14.0,
          fontFamily: 'Apercu',
        ),
      ),
    );
  }

  Widget _buildConfirmMifa(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            Text(
              'Sont-il les chats dont vous vous occupez ? 🤔',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontFamily: 'Apercu',
                fontSize: 24,
              ),
            ),
            _buildPetCarrousel(_mifaSelected.id),
            SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                AwesomeButton(
                  blurRadius: 10.0,
                  splashColor: Colors.orange[400],
                  borderRadius: BorderRadius.circular(37.5),
                  onTap: () => {
                    setState(() {
                      _mifaSelected = null;
                    })
                  },
                  color: Colors.orange[600],
                  child: Center(
                    child: Text(
                      "Non",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18.0,
                        fontFamily: 'Apercu',
                      ),
                    ),
                  ),
                ),
                AwesomeButton(
                  blurRadius: 10.0,
                  splashColor: Colors.orange[400],
                  borderRadius: BorderRadius.circular(37.5),
                  onTap: () => widget.onSelectMifa(_mifaSelected.id),
                  color: Colors.orange[600],
                  child: Center(
                    child: Text(
                      "Oui",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18.0,
                        fontFamily: 'Apercu',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('MifaSelector');

    if (loading) {
      return _buildLoading();
    }

    if (_mifaSelected != null) {
      return _buildConfirmMifa(context);
    }

    if (_mifasDisplay.length == 0) {
      return Container(
        child: Column(
          children: <Widget>[
            Text(
              "Aucune mifa a été trouver, peux-être est tu le premier à t'inscrire ? 😃",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontFamily: "Apercu",
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
            _buildAddMifa(context),
            SizedBox(height: 30),
            Text(
              "sinon tu peux réessayer...",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontFamily: "Apercu",
                fontSize: 12,
              ),
            ),
            SizedBox(height: 10),
            _buildBack(),
          ],
        ),
      );
    }
    return Column(
      children: <Widget>[
        Text(
          "Qui est-ce qui s'occupe du chat ? 😁",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontFamily: "Apercu",
            fontSize: 16,
          ),
        ),
        SizedBox(height: 20),
        Divider(height: 0.5),
        _buildContent(context),
        Divider(height: 0.5),
        SizedBox(height: 10),
        _buildBack(),
      ],
    );
  }
}
