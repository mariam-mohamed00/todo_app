import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../firebase_utils.dart';
import '../model/task.dart';

class ListProvider extends ChangeNotifier {
  List<Task> tasksList = [];
  late Task task;
  DateTime selectedDate = DateTime.now();
  bool check = false;

  void getAllTasksFromFireStore(String uId) async {
    QuerySnapshot<Task> querySnapshot =
        await FirebaseUtils.getTasksCollection(uId).get();

    tasksList = querySnapshot.docs.map((doc) {
      return doc.data();
    }).toList();

    /// filter

    tasksList = tasksList.where((task) {
      if (task.dateTime?.day == selectedDate.day &&
          task.dateTime?.month == selectedDate.month &&
          task.dateTime?.year == selectedDate.year) {
        return true;
      }
      return false;
    }).toList();

    /// sort
    tasksList.sort((Task task1, Task task2) {
      return task1.dateTime!.compareTo(task2.dateTime!);
    });

    notifyListeners();
  }

  void changeSelectedDate(DateTime newDate, String uId) {
    selectedDate = newDate;
    getAllTasksFromFireStore(uId);
    notifyListeners();
  }
}
