import 'package:flutter/material.dart';
import 'Pages/listviewPage.dart';
import 'Pages/item_detailsPage.dart';
import 'package:activity_crud/model/student.dart'; 

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Listviewpage(),
      onGenerateRoute: (settings) {
        if (settings.name == ItemDetailspage.routeName) {
         
          final student = settings.arguments as Student; 

          return MaterialPageRoute(
            builder: (context) {
            
              return ItemDetailspage(student: student);
            },
          );
        }
        return null;
      },
    );
  }
}
