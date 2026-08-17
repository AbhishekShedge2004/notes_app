import "package:database_sqflite/cubit/note_cubit.dart";
import "package:database_sqflite/database/db_helper.dart";
import "package:database_sqflite/provider/db_provider.dart";
import "package:database_sqflite/ui/home_page.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:provider/provider.dart";
void main(){
  runApp(BlocProvider(create: (context) => NoteCubit(dbHelper: DBHelper.getInstance()), child: MyApp(),));

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