import 'package:flutter/material.dart';
import 'package:signals/signals.dart';
import 'package:signals/signals_flutter.dart';

typedef Todo = ({
  String label,
  bool completed,
});

final List<Todo> initialState = [
  (label: 'Learn Flutter', completed: true),
  (label: 'Learn Dart', completed: false),
  (label: 'Learn Signals', completed: false),
];

final todos = <Todo>[...initialState].toSignal();

class TodoView extends StatelessWidget {
  const TodoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watch.builder'),
      ),
      body: Center(
        // state watch
        child: Watch.builder(builder: (context) {
          return ListView.builder(
            itemCount: todos.value.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return Card(
                child: ListTile(
                  title: Text(todo.label),
                  trailing: Checkbox(
                    value: todo.completed,
                    onChanged: (value) {
                      // nullを返さないようにする
                      if(value != null) {
                        todos[index] = (label: todo.label, completed: value);
                      }
                    },
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}