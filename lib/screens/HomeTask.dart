
import 'package:consware/data/TaskData.dart';
import 'package:consware/providers/TaskProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/task.dart';

class HomeTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('To-Do List'),
          backgroundColor: Colors.deepPurple,
        ),
        body: Consumer<TaskProvider>(
          builder: (context, provider, _) {
            final tasks = provider.allTasks;
            if (tasks.isEmpty) {
              return Center(
                child: Text(
                  'No hay tareas',
                  style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: tasks.length,
              itemBuilder: (_, index) {
                final task = tasks[index];
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: task.isCompleted
                        ? Colors.green[100]
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 18,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: task.isCompleted
                            ? Colors.grey[600]
                            : Colors.black,
                      ),
                    ),
                    leading: Checkbox(
                      value: task.isCompleted,
                      activeColor: Colors.deepPurple,
                      onChanged: (_) => provider.toggleComplete(task.id!),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit,
                              color: const Color.fromRGBO(68, 138, 255, 1)),
                          onPressed: () =>
                              _showEditDialog(context, provider, task),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () => provider.deleteTask(task.id!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple,
          child: Icon(Icons.add),
          onPressed: () => _showAddDialog(context),
        ),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final _controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Agregar Tarea'),
        content: TextField(
          controller: _controller,
          decoration: InputDecoration(hintText: 'Título de la tarea'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final title = _controller.text;
              if (title.isNotEmpty) {
                final provider = context.read<TaskProvider>();
                final id = DateTime.now().millisecondsSinceEpoch;
                provider.addTask(Task(id: id, title: title));
                Navigator.pop(context);
              }
            },
            child:
                Text('Guardar', style: TextStyle(color: Colors.deepPurple)),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(
      BuildContext context, TaskProvider provider, Task task) {
    final _controller = TextEditingController(text: task.title);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Editar Tarea'),
        content: TextField(
          controller: _controller,
          decoration: InputDecoration(hintText: 'Nuevo título'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final newTitle = _controller.text;
              if (newTitle.isNotEmpty) {
                provider.editTask(task.id!, newTitle);
                Navigator.pop(context);
              }
            },
            child: Text('Guardar cambios',
                style: TextStyle(color: Colors.deepPurple)),
          ),
        ],
      ),
    );
  }
}
