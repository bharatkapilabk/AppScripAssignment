import 'package:flutter/material.dart';

AppBar appBar(BuildContext context,String title){
  return AppBar(
    centerTitle: true,
    backgroundColor: Colors.white,
    elevation: 0,
    title: Text(title,style: TextStyle(color: Colors.black),),
    automaticallyImplyLeading: false,
  );
}