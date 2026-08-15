import "package:database_sqflite/db_helper.dart";
import "package:database_sqflite/db_provider.dart";
import "package:database_sqflite/home_page.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
void main(){
  runApp(ChangeNotifierProvider(create: (context) => DBProvider(dbHelper: DBHelper.getInstance()), child: MyApp(),));

}

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }

}