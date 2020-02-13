import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mifadeschats/app/home/models/pet.dart';
import 'package:mifadeschats/common_widgets/button/back_down.dart';
import 'package:mifadeschats/common_widgets/platform_alert_dialog.dart';
import 'package:mifadeschats/common_widgets/platform_exception_alert_dialog.dart';
import 'package:mifadeschats/services/database.dart';

class EditPetPage extends StatefulWidget {
  const EditPetPage({Key key, @required this.database, this.pet})
      : super(key: key);
  final Database database;
  final Pet pet;

  static Future<void> show(BuildContext context,
      {Database database, Pet pet}) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => EditPetPage(
          database: database,
          pet: pet,
        ),
        fullscreenDialog: true,
      ),
    );
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

  @required
  void initState() {
    super.initState();

    if (widget.pet != null) {
      _name = widget.pet.name;
      _age = widget.pet.age;
      _gender = widget.pet.gender;
    }
  }

  Future<void> _delete() async {
    try {
      await widget.database.deletePet(widget.pet);
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

    print(_gender);

    if (_validateAndSave()) {
      try {
        final pets = await widget.database.petsStream().first;
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
          final id = widget.pet?.id ?? documentIdFromCurrentDate();
          final pet = Pet(id: id, name: _name, age: _age, gender: _gender);
          print(pet.gender);
          await widget.database.setPet(pet);

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
      body: _buildContents(context),
      backgroundColor: Colors.orange[200],
    );
  }

  Widget _buildContents(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 8,
            color: Colors.white70,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildForm(),
                ),
                ButtonBar(
                  children: <Widget>[
                    FlatButton(
                      textColor: Colors.orange[600],
                      child: const Text('Supprimer'),
                      onPressed: _delete,
                    ),
                    FlatButton(
                      textColor: Colors.orange[600],
                      child: const Text('Modifier'),
                      onPressed: !_isLoading ? _submit : null,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        BackDown(onTap: () {
          Navigator.of(context).pop();
        })
      ],
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
        onEditingComplete: () => _editingComplete('age'),
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
                isDense: true,
                onChanged: (value) {
                  print(value);
                  setState(() {
                    _gender = value;
                  });
                },
                items: ['male', 'female'].map((tag) {
                  return DropdownMenuItem(
                    value: tag,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Image.asset(
                            genderImages[tag],
                            height: 30,
                            width: 30,
                          ),
                        ]),
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
