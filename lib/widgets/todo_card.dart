import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:todo_list_page/models/todo_model.dart';

class TodoCard extends StatelessWidget {
  const TodoCard({
    super.key,
    required this.todo,
    required this.onDelete,
  });

  final TodoModel todo;
  final Function(TodoModel) onDelete;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.2,
        children: [
          SlidableAction(
            onPressed: (context) {
              onDelete(todo);
            },
            icon: Icons.delete,
            backgroundColor: Colors.red,
            label: 'Deletar',
          ),
        ],
      ),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            ListTile(
              title: Text(
                todo.description,
              ),
              subtitle: Text(
                DateFormat('dd/MM/yy - hh:MM').format(todo.date).toString(),
              ),
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: const Color.fromRGBO(0, 0, 0, 0.15),
            )
          ],
        ),
      ),
    );
  }
}
