import 'package:first_app/model/Task.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:first_app/libary/globals.dart' as globals;
import 'package:first_app/provider/TaskProvider.dart';

class AddTaskView extends StatefulWidget {
  const AddTaskView({super.key});

  @override
  State<AddTaskView> createState() => _AddTaskViewState();
}

DateTime _selectedDay = DateTime.now();
DateTime _focusedDay = DateTime.now();
final _formKey = GlobalKey<FormState>();
final title = TextEditingController();
final description = TextEditingController();

class _AddTaskViewState extends State<AddTaskView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskModel>(
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Add new Task"),
            backgroundColor: Colors.teal,
          ),
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TableCalendar(
                    calendarFormat: CalendarFormat.week,
                    firstDay: DateTime.utc(2010, 10, 16),
                    lastDay: DateTime.utc(2030, 3, 14),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, datetime, events) {
                        return Container(
                          width: 20,
                          height: 15,
                          decoration: BoxDecoration(
                            color: globals.primaries[3],
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        );
                      },
                      selectedBuilder: (context, _datetime, _focusedDay) {
                        return Container(
                          decoration: BoxDecoration(
                            color: globals.primaries[5],
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          margin: EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 10.0),
                          child: Center(
                            child: Text(
                              _datetime.day.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: TextFormField(
                      controller: title,
                      maxLength: 100,
                      decoration: InputDecoration(
                        hintText: "Enter Task Title",
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                              color: Colors.blue, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                              color: Colors.blue, width: 2.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                              color: Colors.red, width: 2.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                              color: Colors.purple, width: 2.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: TextFormField(
                      controller: description,
                      maxLength: 500,
                      maxLines: 7,
                      minLines: 5,
                      decoration: InputDecoration(
                        hintText: "Enter a Description (optional)",
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                              color: Colors.blue, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                              color: Colors.blue, width: 2.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                              color: Colors.red, width: 2.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                              color: Colors.purple, width: 2.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Task _newTask = Task(
                    title.text, false, description.text, _focusedDay);
                model.addTasks(_newTask);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Processing Data')),
                );
                Navigator.pushReplacementNamed(context, "addTasks");
              }
            },
            child: Icon(Icons.done),
          ),
        );
      },
    );
  }
  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
 title.dispose();
 description.dispose();
    super.dispose();
  }
}
