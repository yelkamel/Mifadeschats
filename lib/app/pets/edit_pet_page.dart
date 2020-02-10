import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mifadeschats/app/home/models/pet.dart';
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

  @required
  void initState() {
    super.initState();

    if (widget.pet != null) {
      _name = widget.pet.name;
      _age = widget.pet.age;
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
          final pet = Pet(id: id, name: _name, age: _age, gender: 'male');
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
      appBar: AppBar(
        elevation: 2.0,
        title: Text('Ajouter un Animal'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: !_isLoading ? _submit : null,
          ),
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child:
              Padding(padding: const EdgeInsets.all(16.0), child: _buildForm()),
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
        FocusScope.of(context).requestFocus(_nameFocusNode);
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
    ];
  }
}
