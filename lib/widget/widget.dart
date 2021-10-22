import 'package:flutter/material.dart';

InputDecoration textfieldDecoration(String label){
  return InputDecoration(
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
    ),
    labelText: label,
    
  );
}