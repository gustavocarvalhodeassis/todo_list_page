import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_list_page/pages/todo_home_page.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoListPage(),
    ),
  );
}

class TodoListPage extends StatelessWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TodoHomePage();
  }
}
