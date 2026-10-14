// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

void main() {
  runApp(todoApp());
}

List<String> tasks = ["Finish Coding Project"];
List<String> taskCategories = ["Robotics"];
List<String> taskPriorities = ["High"];
List<DateTime> taskDuedates = [DateTime.now()];

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
  const _ToDoListAppState();

  @override
  __ToDoListAppStateState createState() => __ToDoListAppStateState();
}

class __ToDoListAppStateState extends State<_ToDoListAppState> {
  String selectedValue = 'All';
  Color getColor(DateTime dueDate) {
    Duration dateDifference = DateTime.now().difference(dueDate);
    if (dateDifference.inDays > 7) {
      return Colors.red;
    } else if (dateDifference.inDays >= 5) {
      return Colors.orangeAccent;
    }
    return Colors.white;
  }
  void organizeViaUrgency(){
    int counter = 1;
    for (int i = 0; i< tasks.length; i++){
      if(taskPriorities[i] == 'High'){
        setState(() {
        taskPriorities.insert(0,taskPriorities[i]);
        tasks.insert(0,tasks[i]);
        taskDuedates.insert(0,taskDuedates[i]);
        taskCategories.insert(0,taskCategories[i]);
        });
        counter++;
      }
      else if(taskPriorities[i] == 'Medium'){
        setState(() {
        taskPriorities.insert(counter,taskPriorities[i]);
        tasks.insert(counter,tasks[i]);
        taskDuedates.insert(counter,taskDuedates[i]);
        taskCategories.insert(counter,taskCategories[i]);
        });
      }
      else{
        setState(() {
        taskPriorities.insert(taskPriorities.length,taskPriorities[i]);
        tasks.insert(taskPriorities.length,tasks[i]);
        taskDuedates.insert(taskPriorities.length,taskDuedates[i]);
        taskCategories.insert(taskPriorities.length,taskCategories[i]);
        });
      }
    }
  }
  
  @override
  void initState(){
    super.initState();
    organizeViaUrgency();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        actions: [
          
          PopupMenuButton<String>(
            color: Colors.cyan,
            onSelected: (String value) {
              setState(() {
                selectedValue = value;
              });
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(value: 'Robotics', child: Text('Robotics')),
              PopupMenuItem(value: 'School', child: Text('School')),
              PopupMenuItem(value: 'Home', child: Text('Home')),
              PopupMenuItem(value: 'All', child: Text('All')),
            ],
          ),
        ],
        title: Text('TODO List'),
        automaticallyImplyLeading: false,
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
      body: tasks.isEmpty
          ? Center(
              child: Text(
                "No tasks yet",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            )
          : Column(
              children: [
                Flexible(
                  child: ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (selectedValue == 'Robotics') {
                        if (!(taskCategories[index] == 'Robotics')) {
                          return null;
                        }
                      } else if (selectedValue == 'School') {
                        if (!(taskCategories[index] == 'School')) {
                          return null;
                        }
                      } else if (selectedValue == 'Home') {
                        if (!(taskCategories[index] == 'Home')) {
                          return null;
                        }
                      }
                      return Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                tasks[index],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "Category: ${taskCategories[index]}",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "Priority: ${taskPriorities[index]}",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "Due: ${taskDuedates[index].toString()}",
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
                            onPressed: () {
                              setState(() {
                                tasks.removeAt(index);
                                taskCategories.removeAt(index);
                                taskDuedates.removeAt(index);
                                taskPriorities.removeAt(index);
                              });
                            },
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
  const AddTaskPage({super.key});

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  TextEditingController inputController = TextEditingController();
  String selectedCategory = "Robotics";
  String defaultPriority = "Low";
  DateTime? selectedDate;
  String formFieldLabel = "Enter new task: ";

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
                decoration: InputDecoration(labelText: formFieldLabel),
                controller: inputController,
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
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
                  onPressed: () {
                    if (inputController.text.isEmpty) {
                      setState(() {
                        formFieldLabel = "Cannot add empty task";
                      });
                    } else {
                      setState(() {
                        tasks.add(inputController.text);
                        taskCategories.add(selectedCategory);
                        taskPriorities.add(defaultPriority);
                        taskDuedates.add(selectedDate ?? DateTime.now());
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => _ToDoListAppState(),
                        ),
                      );
                    }
                  },
                  child: Text('Save'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
                  onPressed: () {
                    Navigator.pop(context);
                  },
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
