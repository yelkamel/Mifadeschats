import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:mifadeschats/widget/button/touchable_particule.dart';
import 'package:mifadeschats/widget/photo/image_capture.dart';
import 'package:mifadeschats/models/mifa.dart';
import 'package:mifadeschats/models/pet.dart';
import 'package:mifadeschats/widget/platform_alert_dialog.dart';
import 'package:mifadeschats/widget/platform_exception_alert_dialog.dart';
import 'package:mifadeschats/navigation/fade_page_route.dart';
import 'package:mifadeschats/services/database.dart';
import 'package:provider/provider.dart';

class EditPetPage extends StatefulWidget {
  const EditPetPage({Key key, @required this.database, this.pet, this.mifa})
      : super(key: key);
  final Database database;
  final Mifa mifa;
  final Pet pet;

  static Future<void> show(BuildContext context,
      {Database database, Pet pet}) async {
    final database = Provider.of<Database>(context, listen: false);
    final mifa = Provider.of<Mifa>(context, listen: false);

    await Navigator.of(context, rootNavigator: true).push(FadePageRoute(
      screen: EditPetPage(
        database: database,
        pet: pet,
        mifa: mifa,
      ),
    ));
  }

  @override
  _EditPetPageState createState() => _EditPetPageState();
}

class _EditPetPageState extends State<EditPetPage> {
  final _formkey = GlobalKey<FormState>();
  bool _isLoading = false;

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _ageFocusNode = FocusNode();

  String _name;
  int _age;
  String _gender;
  String _id;

  @required
  void initState() {
    super.initState();

    if (widget.pet != null) {
      _name = widget.pet.name;
      _age = widget.pet.age;
      _gender = widget.pet.gender;
      _id = widget.pet?.id ?? documentUniqueId();
    } else {
      _id = documentUniqueId();
    }
  }

  Future<void> _delete() async {
    try {
      await widget.database.deletePet(widget.mifa.id, widget.pet);
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'une Erreur est survenu',
        exception: e,
      ).show(context);
    }
  }

  bool _validateAndSave() {
    final form = _formkey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    }

    return false;
  }

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
    });

    if (_validateAndSave()) {
      try {
        final pets = await widget.database.petsStream(widget.mifa.id).first;
        final allNames = pets.map((pet) => pet.name).toList();
        if (widget.pet != null) {
          allNames.remove(widget.pet.name);
        }

        if (allNames.contains(_name)) {
          PlatformAlertDialog(
            title: 'Nom déjà présent',
            content: 'Ressayer avec un autre prénom',
            defaultActionText: "d'accord",
          ).show(context);
        } else {
          final pet = Pet(id: _id, name: _name, age: _age, gender: _gender);
          await widget.database.setPet(widget.mifa.id, pet);

          Navigator.of(context).pop();
        }
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(exception: e, title: 'Erreur')
            .show(context);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: TouchableParticule(
          child: Transform.rotate(
            angle: -pi / 2,
            child: Icon(
              Icons.arrow_back,
              color: Colors.red,
            ),
          ),
          onTap: () => Navigator.of(context).pop(),
        ),
      ),
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: Theme.of(context).cardTheme.elevation,
            color: Theme.of(context).cardTheme.color,
            shape: Theme.of(context).cardTheme.shape,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildForm(),
                ),
                ButtonBar(
                  children: <Widget>[
                    if (widget.pet != null)
                      FlatButton(
                        textColor: Theme.of(context).accentColor,
                        child: const Text('Supprimer'),
                        onPressed: _delete,
                      ),
                    FlatButton(
                      textColor: Theme.of(context).accentColor,
                      child:
                          Text(widget.pet == null ? 'Enregistrer' : 'Modifier'),
                      onPressed: !_isLoading ? _submit : null,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formkey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildChildren(),
      ),
    );
  }

  void _editingComplete(type) {
    switch (type) {
      case 'email':
        FocusScope.of(context).requestFocus(_ageFocusNode);
        break;
      default:
    }
  }

  List<Widget> _buildChildren() {
    return [
      ImageCapture(
        path: 'images/pets/${_id}.png',
      ),
      TextFormField(
        focusNode: _nameFocusNode,
        initialValue: _name,
        decoration: InputDecoration(
          labelText: "Nom",
          enabled: _isLoading == false,
        ),
        onSaved: (value) => _name = value,
        validator: (input) => input.length == 0 ? 'ajoute un blase' : null,
        onEditingComplete: () => _editingComplete('email'),
      ),
      TextFormField(
        focusNode: _ageFocusNode,
        initialValue: _age != null ? '$_age' : null,
        decoration: InputDecoration(labelText: "age"),
        keyboardType:
            TextInputType.numberWithOptions(signed: false, decimal: false),
        onSaved: (value) => _age = int.tryParse(value) ?? 0,
        // onEditingComplete: () => _editingComplete('age'),
      ),
      FormField(
        onSaved: (value) {
          _gender = value;
        },
        initialValue: _gender != null ? _gender : 'female',
        builder: (FormFieldState state) {
          return InputDecorator(
            decoration: InputDecoration(
              labelText: 'Sexe',
            ),
            isEmpty: _gender == '',
            child: new DropdownButtonHideUnderline(
              child: new DropdownButton(
                value: _gender,
                onChanged: (value) {
                  setState(() {
                    _gender = value;
                  });
                },
                items: ['male', 'female'].map((tag) {
                  return DropdownMenuItem(
                    value: tag,
                    child: Image.asset(
                      genderImages[tag],
                      height: 50,
                      width: 50,
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    ];
  }
}
