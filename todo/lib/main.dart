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
        title: 'TODO App',
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
      listItems.add(TodoItem(name: name));
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

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = TodoList();
      case 1:
        page = ListPage();
      default:
        page = Placeholder();
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        floatingActionButton: AddButton(),
        appBar: AppBar(
          backgroundColor: Colors.deepPurpleAccent,
          title: Text('TODO App',
              style: Theme.of(context).textTheme.headlineMedium),
        ),
        body: Row(
          children: [
            SafeArea(
              child: SizedBox(
                width: constraints.maxWidth / 4,
                child: ListView(
                  children: [
                    for (var i = 0; i <= 5; i++)
                      ListTile(
                        title: Text(
                          'List $i',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        selected: i == selectedIndex,
                        onTap: () {
                          setState(() {
                            selectedIndex = i;
                          });
                        },
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
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
                  // Add the TODO with the specified name
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
