import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo/firebase_utils.dart';
import 'package:todo/home/task_list/edit_task_screen.dart';
import 'package:todo/providers/auth_provider.dart';

import '../../model/task.dart';
import '../../my_theme.dart';
import '../../providers/app_config_provider.dart';
import '../../providers/list_provider.dart';

class TaskWidget extends StatefulWidget {
  Task task;

  TaskWidget({required this.task});

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  DateTime selectedDate = DateTime.now();
  late AppConfigProvider provider;
  late ListProvider listProvider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppConfigProvider>(context);
    listProvider = Provider.of<ListProvider>(context, listen: false);
    var uId =
        Provider.of<AuthProvider>(context, listen: false).currentuser?.id ?? '';
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Slidable(
        startActionPane: ActionPane(
          extentRatio: 0.2,
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                /// delete task
                FirebaseUtils.deleteTaskFromFireStore(widget.task, uId)
                    .timeout(Duration(milliseconds: 500), onTimeout: () {
                  print('task was deleted');
                  listProvider.getAllTasksFromFireStore(uId);
                });
              },
              spacing: 12,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15)),
              backgroundColor: MyTheme.redColor,
              foregroundColor: MyTheme.whiteColor,
              icon: Icons.delete,
              label: AppLocalizations.of(context)!.delete,
            ),
          ],
        ),
        child: InkWell(
          onTap: () {
            Navigator.of(context)
                .pushNamed(EditTask.routeName, arguments: widget.task);
          },
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: provider.appTheme == ThemeMode.light
                    ? MyTheme.whiteColor
                    : MyTheme.blackDark),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    color: widget.task.isDone!
                        ? MyTheme.greenColor
                        : MyTheme.primaryLight,
                    height: 80,
                    width: 4,
                  ),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.task.title ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                  color: widget.task.isDone!
                                      ? MyTheme.greenColor
                                      : MyTheme.primaryLight),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.task.description ?? '',
                            style: Theme.of(context).textTheme.titleSmall),
                      ),
                    ],
                  )),
                  InkWell(
                    onTap: () {
                      FirebaseUtils.editIsDone(widget.task, uId);
                      widget.task.isDone = !widget.task.isDone!;
                      setState(() {});
                    },
                    child: widget.task.isDone!
                        ? Text(
                            AppLocalizations.of(context)!.done_task,
                            style: TextStyle(
                                color: MyTheme.greenColor,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          )
                        : Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 18, vertical: 7),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              Icons.check,
                              color: MyTheme.whiteColor,
                              size: 30,
                            ),
                          ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
