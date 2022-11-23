import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:todo_list_page/models/todo_model.dart';
import 'package:todo_list_page/repository/todo_repository.dart';
import 'package:todo_list_page/widgets/todo_card.dart';

class TodoHomePage extends StatefulWidget {
  TodoHomePage({super.key});

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  List<TodoModel> todoList = [];

  TextEditingController todoController = TextEditingController();

  TodoModel? deletedTodo;
  int? deletedTodoPos;

  TodoRepository todoRepository = TodoRepository();

  void deleteTodo(TodoModel todo) {
    deletedTodo = todo;
    deletedTodoPos = todoList.indexOf(todo);
    setState(() {
      todoList.remove(todo);
    });
    todoRepository.saveTodoList(todoList);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tarefa ${todo.description} deletada com sucesso',
        ),
        action: SnackBarAction(
          label: 'Desfazer',
          onPressed: () {
            setState(() {
              todoList.insert(deletedTodoPos!, deletedTodo!);
            });
            todoRepository.saveTodoList(todoList);
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    todoRepository.getTodos().then(
      (value) {
        setState(
          () {
            todoList = value;
          },
        );
      },
    );
  }

  String? errorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de tarefas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: todoController,
                    decoration: InputDecoration(
                      errorText: errorText,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      labelText: 'Tarefa:',
                      hintText: 'Ex: Aprender Flutter',
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    String text = todoController.text;
                    if (text == '' || text.isEmpty) {
                      setState(() {
                        errorText = 'Você deve inserir alguma tarefa';
                      });
                    } else {
                      setState(() {
                        TodoModel newTodo = TodoModel(text, DateTime.now());
                        todoList.add(newTodo);
                        todoController.clear();
                        errorText = null;
                      });
                      todoRepository.saveTodoList(todoList);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Flexible(
              child: todoList.isEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset('assets/images/noTodo.png'),
                    )
                  : ListView(
                      shrinkWrap: true,
                      children: [
                        for (TodoModel todo in todoList)
                          TodoCard(
                            todo: todo,
                            onDelete: deleteTodo,
                          ),
                      ],
                    ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  child: Text('Você tem ${todoList.length} tarefas'),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Apagar todas?'),
                            content: const Text(
                                'Deseja realmente apagar todas as tarefas?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  setState(() {
                                    todoList.clear();
                                  });
                                  todoRepository.saveTodoList(todoList);
                                },
                                child: Text(
                                  'Apagar todas',
                                  style: TextStyle(color: Colors.grey[500]),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Cancelar',
                                ),
                              ),
                            ],
                          );
                        });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Text('Apagar todas'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
