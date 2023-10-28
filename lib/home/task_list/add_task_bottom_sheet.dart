import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/dialog_utils.dart';
import 'package:todo/my_theme.dart';
import 'package:todo/providers/app_config_provider.dart';
import 'package:todo/providers/auth_provider.dart';
import 'package:todo/providers/list_provider.dart';

import '../../firebase_utils.dart';
import '../../model/task.dart';

class AddTaskBottomSheet extends StatefulWidget {
  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  var formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  DateTime selectedDate = DateTime.now();
  late ListProvider listProvider;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    listProvider = Provider.of<ListProvider>(context);

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(AppLocalizations.of(context)!.add_new_task,
                  style: Theme.of(context).textTheme.titleMedium),
            ),
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      onChanged: (text) {
                        title = text;
                      },
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return AppLocalizations.of(context)!.validate_title;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: provider.appTheme == ThemeMode.light
                                      ? MyTheme.blackColor
                                      : MyTheme.greyColor)),
                          hintText: AppLocalizations.of(context)!.hint_title,
                          hintStyle: provider.appTheme == ThemeMode.light
                              ? Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(color: MyTheme.greyColor)
                              : Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(color: MyTheme.whiteColor)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      onChanged: (text) {
                        description = text;
                      },
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return AppLocalizations.of(context)!
                              .validate_description;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: provider.appTheme == ThemeMode.light
                                    ? MyTheme.blackColor
                                    : MyTheme.greyColor),
                          ),
                          hintText:
                              AppLocalizations.of(context)!.hint_description,
                          hintStyle: provider.appTheme == ThemeMode.light
                              ? Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(color: MyTheme.greyColor)
                              : Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(color: MyTheme.whiteColor)),
                      maxLength: 150,
                      maxLines: 4,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(AppLocalizations.of(context)!.select_date,
                        style: provider.appTheme == ThemeMode.light
                            ? Theme.of(context).textTheme.titleSmall
                            : Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(color: MyTheme.whiteColor)),
                  ),
                  InkWell(
                    onTap: () {
                      showCalender();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        // '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                        '${DateFormat('d/M/y').format(selectedDate)}',
                        style: provider.appTheme == ThemeMode.light
                            ? Theme.of(context).textTheme.titleSmall
                            : Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(color: MyTheme.whiteColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        addTask();
                      },
                      child: Text(AppLocalizations.of(context)!.add_task_button,
                          style: provider.appTheme == ThemeMode.light
                              ? Theme.of(context).textTheme.titleLarge
                              : Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(color: MyTheme.whiteColor))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showCalender() async {
    var chosenDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)));

    if (chosenDate != null) {
      selectedDate = chosenDate;
      setState(() {});
    }
  }

  void addTask() {
    if (formKey.currentState?.validate() == true) {
      // add task to firebase
      Task task = Task(
        title: title,
        description: description,
        dateTime: selectedDate,
      );
      var authProvider = Provider.of<AuthProvider>(context, listen: false);
      DialogUtils.showLoading(context, AppLocalizations.of(context)!.waiting);
      FirebaseUtils.addTaskToFireStore(task, authProvider.currentuser?.id ?? '')
          .then((value) {
        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(
            context, AppLocalizations.of(context)!.task_added,
            posActionName: AppLocalizations.of(context)!.ok, posAction: () {
          Navigator.pop(context);
        });
      }).timeout(Duration(milliseconds: 500), onTimeout: () {
        // print('task added');
        Fluttertoast.showToast(
            msg: "added task successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: MyTheme.blackColor,
            textColor: Colors.white,
            fontSize: 16.0);

        listProvider
            .getAllTasksFromFireStore(authProvider.currentuser?.id ?? '');

        Navigator.pop(context);
      });
    }
  }
}
