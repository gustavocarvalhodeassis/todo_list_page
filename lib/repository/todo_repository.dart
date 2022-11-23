// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list_page/models/todo_model.dart';

const String instance = 'todo_list';

class TodoRepository {
  late SharedPreferences sharedPreferences;

  Future<List<TodoModel>> getTodos() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(instance) ?? '[]';
    final List jsonDecode = json.decode(jsonString) as List;
    return jsonDecode.map((e) => TodoModel.fromJson(e)).toList();
  }

  void saveTodoList(List<TodoModel> todoList) {
    final jsonString = jsonEncode(todoList);
    sharedPreferences.setString(instance, jsonString);
  }
}
