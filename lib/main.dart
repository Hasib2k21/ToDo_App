import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class Task {
  String title;
  bool isCompleted;
  DateTime dueDate;
  String category;

  Task({
    required this.title,
    this.isCompleted = false,
    required this.dueDate,
    required this.category,
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ToDoScreen(),
    );
  }
}

class ToDoScreen extends StatefulWidget {
  @override
  _ToDoScreenState createState() => _ToDoScreenState();
}

// ... (previous code)

class _ToDoScreenState extends State<ToDoScreen> {
  TextEditingController _taskController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  List<Task> _tasks = [];
  int _editingIndex = -1; // Keep track of the task being edited

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ToDo App'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: InputDecoration(
                      hintText: 'Enter task',
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _categoryController,
                    decoration: InputDecoration(
                      hintText: 'Category',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () {
                    _selectDate(context);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    if (_editingIndex == -1) {
                      _addTask(_taskController.text, _selectedDate, _categoryController.text);
                    } else {
                      _saveEditedTask(_editingIndex);
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_tasks[index].title),
                  subtitle: Text(_tasks[index].category),
                  leading: Checkbox(
                    value: _tasks[index].isCompleted,
                    onChanged: (value) {
                      _toggleTask(index);
                    },
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _editTask(index);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteTask(index);
                        },
                      ),
                      Text(DateFormat('MMM dd, yyyy').format(_tasks[index].dueDate)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _editTask(int index) {
    setState(() {
      _editingIndex = index;
      _taskController.text = _tasks[index].title;
      _categoryController.text = _tasks[index].category;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Task'),
          content: TextField(
            controller: _taskController,
            decoration: InputDecoration(
              hintText: 'Enter updated task',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _editingIndex = -1; // Reset editing index
                });
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _saveEditedTask(index);
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _saveEditedTask(int index) {
    if (_taskController.text.isNotEmpty && _categoryController.text.isNotEmpty) {
      setState(() {
        _tasks[index].title = _taskController.text;
        _tasks[index].category = _categoryController.text;
        _tasks[index].dueDate = _selectedDate;
        _editingIndex = -1; // Reset editing index
        _taskController.text = '';
        _categoryController.text = '';
      });
    }
  }

// ... (remaining methods remain the same)


  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _addTask(String title, DateTime dueDate, String category) {
    if (title.isNotEmpty && category.isNotEmpty) {
      setState(() {
        _tasks.add(Task(title: title, dueDate: dueDate, category: category));
        _taskController.text = '';
        _categoryController.text = '';
      });
    }
  }

  void _toggleTask(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    });
  }


  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }
}
