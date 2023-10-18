import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/home/task_list/task_widget.dart';
import 'package:todo/my_theme.dart';
import 'package:todo/providers/app_config_provider.dart';
import 'package:todo/providers/list_provider.dart';

import '../../providers/auth_provider.dart';

class TaskListTab extends StatefulWidget {
  @override
  State<TaskListTab> createState() => _TaskListTabState();
}

class _TaskListTabState extends State<TaskListTab> {
  bool click = false;

  @override
  Widget build(BuildContext context) {
    var listProvider = Provider.of<ListProvider>(context);
    var provider = Provider.of<AppConfigProvider>(context);
    var authProvider = Provider.of<AuthProvider>(context);

    listProvider.getAllTasksFromFireStore(authProvider.currentuser?.id ?? '');

    return Column(
      children: [
        provider.appTheme == ThemeMode.light
            ? CalendarTimeline(
                initialDate: listProvider.selectedDate,
                firstDate: DateTime.now().subtract(Duration(days: 365)),
                lastDate: DateTime.now().add(Duration(days: 365)),
                onDateSelected: (date) {
                  listProvider.changeSelectedDate(
                      date, authProvider.currentuser?.id ?? '');
                },
                leftMargin: 20,
                monthColor: MyTheme.blackColor,
                dayColor: MyTheme.blackColor,
                activeDayColor: MyTheme.whiteColor,
                activeBackgroundDayColor: MyTheme.primaryLight,
                dotsColor: MyTheme.whiteColor,
                selectableDayPredicate: (date) => date.day != 22,
                // selectableDayPredicate: (date) => true,
                locale: 'en_ISO',
              )
            : CalendarTimeline(
                initialDate: listProvider.selectedDate,
                firstDate: DateTime.now().subtract(Duration(days: 365)),
                lastDate: DateTime.now().add(Duration(days: 365)),
                onDateSelected: (date) {
                  listProvider.changeSelectedDate(
                      date, authProvider.currentuser?.id ?? '');
                },
                leftMargin: 20,
                monthColor: MyTheme.whiteColor,
                dayColor: MyTheme.whiteColor,
                activeDayColor: MyTheme.whiteColor,
                activeBackgroundDayColor: MyTheme.primaryLight,
                dotsColor: MyTheme.whiteColor,
                selectableDayPredicate: (date) => date.day != 22,
                // selectableDayPredicate: (date) => true,
                locale: 'en_ISO',
              ),
        Expanded(
          child: ListView.builder(
              itemCount: listProvider.tasksList.length,
              itemBuilder: (context, index) {
                return TaskWidget(task: listProvider.tasksList[index]);
              }),
        ),
      ],
    );
  }
}
