import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'WhatNext?',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  // item Count that can change

  // TODO: Map listitems to todoitems

  List todoItems = [];
  List listItems = [];

  //Method to add todo
  void addTodo(String name) {
    if (todoItems.length <= 12) {
      todoItems.add(TodoItem(name: name));
    }
    notifyListeners();
  }

// Add list
  void addList(String name) {
    if (listItems.length <= 12) {
      listItems.add(ListItem(name: name));
    }
    notifyListeners();
  }

  //Method to remove todo
  void removeTodo(int index) {
    if (index >= 0 && index < todoItems.length) {
      todoItems.removeAt(index);
    }
    notifyListeners();
  }
}

class TodoItem {
  final String name;

  TodoItem({required this.name});
}

class ListItem {
  final String name;

  ListItem({required this.name});
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<TodoList> todoLists;
  var selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    todoLists = List.generate(12, (index) => TodoList());
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    // Get selected todolist
    TodoList selectedList = todoLists[selectedIndex];

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AddButton(),
            SizedBox(height: 16),
            AddListButton(), // New list button
          ],
        ),
        appBar: AppBar(
          backgroundColor: Colors.deepPurpleAccent,
          title: Text('WhatNext?',
              style: Theme.of(context).textTheme.headlineMedium),
        ),
        body: Row(
          children: [
            SafeArea(
              child: SizedBox(
                width: constraints.maxWidth / 4,
                child: ListView.builder(
                  itemCount: appState.listItems.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(
                      appState.listItems[index].name,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                        print(selectedIndex);
                      });
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: selectedList,
              ),
            ),
          ],
        ),
      );
    });
  }
}

// Todolist
class TodoList extends StatefulWidget {
  //TODO: each list has own

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<bool> checkboxValues = List.generate(14, (index) => false);

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return ListView.builder(
      itemCount: appState.todoItems.length,
      itemBuilder: (context, index) => TodoListItem(
        index: index,
        text: appState.todoItems[index].name,
        isChecked: checkboxValues[index],
        onCheckbocChanged: (bool? value) {
          setState(() {
            checkboxValues[index] = value!;
          });
        },
      ),
    );
  }
}

//TODO: Add list button

// New list button
class AddListButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        _showAddListDialog(context);
      },
      child: Icon(Icons.playlist_add),
    );
  }
}

void _showAddListDialog(BuildContext context) {
  TextEditingController textController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Add List'),
        content: TextField(
          controller: textController,
          decoration: InputDecoration(labelText: 'Enter List name'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              String listName = textController.text;
              if (listName.isNotEmpty) {
                Provider.of<MyAppState>(context, listen: false)
                    .addList(listName);
                Navigator.of(context).pop(); // Close the dialog
              }
            },
            child: Text('Add'),
          ),
        ],
      );
    },
  );
}

class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('This is the List Page'),
    );
  }
}

//Add a button right bottom corner
class AddButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        _showAddTodoDialog(context);
      },
      child: Icon(Icons.add),
    );
  }

  void _showAddTodoDialog(BuildContext context) {
    TextEditingController textController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add TODO'),
          content: TextField(
            controller: textController,
            decoration: InputDecoration(labelText: 'Enter TODO name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String todoName = textController.text;
                if (todoName.isNotEmpty) {
                  Provider.of<MyAppState>(context, listen: false)
                      .addTodo(todoName);
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

class TodoListItem extends StatelessWidget {
  final int index;
  final bool isChecked;
  final ValueChanged<bool?> onCheckbocChanged;
  final String text;

  const TodoListItem({
    required this.index,
    required this.isChecked,
    required this.onCheckbocChanged,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: isChecked,
        onChanged: onCheckbocChanged,
      ),
      title: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      trailing: Icon(
        Icons.delete,
        color: Theme.of(context).colorScheme.primary,
      ),
      onTap: () {
        //uncheck checkbox
        onCheckbocChanged(false);
        // remove
        Provider.of<MyAppState>(context, listen: false).removeTodo(index);
      },
    );
  }
}
