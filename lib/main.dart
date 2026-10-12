import 'package:flutter/material.dart';

void main() {
  runApp(todoApp());
}

List<String> tasks = [];
List<String> taskCategories = [];
List<String> taskPriorities = [];
List<DateTime> taskDuedates = [];

// ignore: camel_case_types
class todoApp extends StatelessWidget {
  const todoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _ToDoListAppState(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class _ToDoListAppState extends StatefulWidget {
  const _ToDoListAppState({super.key});

  @override
  __ToDoListAppStateState createState() => __ToDoListAppStateState();
}

class __ToDoListAppStateState extends State<_ToDoListAppState> {
  Color getColor(DateTime dueDate) {
    Duration dateDifference = DateTime.now().difference(dueDate);
    if (dateDifference.inDays > 7) {
      return Colors.red;
    } else if (dateDifference.inDays < 5) {
      return Colors.white;
    } else if (dateDifference.inDays >= 5) {
      return Colors.orangeAccent;
    }
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text('TODO List'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(11),
        ),
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddTaskPage()));
        },
        backgroundColor: Colors.cyan,

        child: Icon(Icons.add),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          tasks[index],
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        Text(
                          taskCategories[index],
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        Text(
                          taskPriorities[index],
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        Text(
                          taskDuedates.toString()[index],
                          style: TextStyle(
                            fontSize: 16,
                            color: getColor(taskDuedates[index]),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 50),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {},
                      color: Colors.cyanAccent,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AddTaskPage extends StatefulWidget {
  AddTaskPage({Key? key}) : super(key: key);

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  String selectedCategory = "Robotics";
  String defaultPriority = "Low";
  DateTime? selectedDate;

  Future<void> _selectDate() async {
    final now = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 5),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        taskDuedates.add(selectedDate!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 200),
            Container(
              width: 600,
              decoration: BoxDecoration(
                color: Colors.cyan,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Enter new task'),
                validator: (value) {
                  setState(() {
                    tasks.add(value.toString());
                  });
                },
              ),
            ),
            SizedBox(height: 40),
            DropdownButton<String>(
              menuWidth: 100,
              iconEnabledColor: Colors.cyan,
              dropdownColor: Colors.cyan,
              focusColor: Colors.cyanAccent,
              value: selectedCategory,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue!;
                  taskCategories.add(selectedCategory);
                });
              },
              items: <String>['Robotics', 'School', 'Home']
                  .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  })
                  .toList(),
            ),
            SizedBox(height: 60),
            DropdownButton<String>(
              iconEnabledColor: Colors.cyan,
              menuWidth: 100,
              dropdownColor: Colors.cyan,
              focusColor: Colors.cyanAccent,
              value: defaultPriority,
              onChanged: (String? newValue) {
                setState(() {
                  defaultPriority = newValue!;
                  taskPriorities.add(defaultPriority);
                });
              },
              items: <String>['Low', 'Medium', 'High']
                  .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  })
                  .toList(),
            ),
            SizedBox(height: 60),
            MaterialButton(
              height: 50,
              color: Colors.cyan,
              onPressed: _selectDate,
              child: Text(
                selectedDate == null
                    ? 'Pick a date'
                    : MaterialLocalizations.of(context)
                          .formatShortDate(selectedDate!),
              ),
            ),
            SizedBox(height: 50),
             Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                ),
                onPressed: () {},
                child: Text('Save'),        
              ),
              SizedBox(width:20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                ),
                onPressed: () {},
                child: Text('Cancel'),        
              ),
              ],
             ),
          ],
        ),
      ),
    );
  }
}
