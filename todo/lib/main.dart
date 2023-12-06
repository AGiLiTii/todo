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

class MyAppState extends ChangeNotifier {}

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
        page = Placeholder();
      default:
        page = Placeholder();
    }
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.deepPurpleAccent,
            title: Text('TODO App',
                style: Theme.of(context).textTheme.headlineMedium)),
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

class TodoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (var i = 0; i < 10; i++)
          ListTile(
            // Add leading checkbox
            leading: Checkbox(
              value: false,
              onChanged: (bool? value) {},
            ),
            title:
                // TODO: Recieve actual name
                Text('Todo $i', style: Theme.of(context).textTheme.bodyMedium),
          ),
      ],
    );
  }
}
