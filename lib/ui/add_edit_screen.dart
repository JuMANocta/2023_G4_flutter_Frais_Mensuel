import 'package:flutter/material.dart';
import 'package:g4flutterfraismensuel/models/expense.dart';


typedef OnSaveCallback = Function(String description, double amount);

class AddEditScreen extends StatefulWidget {
  final bool isEditing;
  final OnSaveCallback onSave;
  final Expense? expense;

  AddEditScreen({required this.onSave, required this.isEditing, this.expense});

  @override
  _AddEditScreenState createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _description;
  double? _amount;

  bool get isEditing => widget.isEditing;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Modifier un frais' : 'Ajouter un frais'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: isEditing ? widget.expense?.description : '',
                decoration: InputDecoration(labelText: 'Description'),
                validator: (val) {
                  return val!.trim().isEmpty ? 'Veuillez entrer une description' : null;
                },
                onSaved: (value) => _description = value,
              ),
              TextFormField(
                initialValue: isEditing ? '${widget.expense?.amount}' : '',
                decoration: InputDecoration(labelText: 'Montant'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (val) {
                  return val!.trim().isEmpty ? 'Veuillez entrer un montant' : null;
                },
                onSaved: (value) => _amount = double.tryParse(value!),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            widget.onSave(_description!, _amount!);
            Navigator.pop(context);
          }
        },
        child: Icon(Icons.save),
      ),
    );
  }
}