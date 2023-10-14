import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/my_theme.dart';
import 'package:todo/providers/app_config_provider.dart';
import 'package:todo/providers/list_provider.dart';

import '../../dialog_utils.dart';
import '../../firebase_utils.dart';
import '../../model/task.dart';
import '../../providers/auth_provider.dart';

class EditTask extends StatefulWidget {
  static const String routeName = 'Edit Task';

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  late ListProvider listProvider;
  Task? task;

  @override
  Widget build(BuildContext context) {
    if (task == null) {
      task = ModalRoute.of(context)!.settings.arguments as Task;
      titleController.text = task!.title ?? '';
      descriptionController.text = task!.description ?? '';
      selectedDate = task!.dateTime!;
    }

    listProvider = Provider.of<ListProvider>(context);
    var provider = Provider.of<AppConfigProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.to_do_app_bar),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  color: MyTheme.primaryLight,
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.04),
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                        color: provider.appTheme == ThemeMode.light
                            ? MyTheme.whiteColor
                            : MyTheme.blackDark,
                        borderRadius: BorderRadius.circular(20)),
                    padding: EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Text(AppLocalizations.of(context)!.edit_task,
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
                                  // initialValue: task.title,
                                  controller: titleController,
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return AppLocalizations.of(context)!
                                          .validate_title;
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: provider.appTheme ==
                                                      ThemeMode.light
                                                  ? MyTheme.blackColor
                                                  : MyTheme.greyColor)),
                                      hintText: AppLocalizations.of(context)!
                                          .hint_title,
                                      hintStyle: provider.appTheme ==
                                              ThemeMode.light
                                          ? Theme.of(context)
                                              .textTheme
                                              .titleSmall!
                                              .copyWith(
                                                  color: MyTheme.greyColor)
                                          : Theme.of(context)
                                              .textTheme
                                              .titleSmall!
                                              .copyWith(
                                                  color: MyTheme.whiteColor)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: descriptionController,
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
                                            color: provider.appTheme ==
                                                    ThemeMode.light
                                                ? MyTheme.blackColor
                                                : MyTheme.greyColor),
                                      ),
                                      hintText: AppLocalizations.of(context)!
                                          .hint_description,
                                      hintStyle: provider.appTheme ==
                                              ThemeMode.light
                                          ? Theme.of(context)
                                              .textTheme
                                              .titleSmall!
                                              .copyWith(
                                                  color: MyTheme.greyColor)
                                          : Theme.of(context)
                                              .textTheme
                                              .titleSmall!
                                              .copyWith(
                                                  color: MyTheme.whiteColor)),
                                  maxLength: 150,
                                  maxLines: 4,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    AppLocalizations.of(context)!.select_date,
                                    style: provider.appTheme == ThemeMode.light
                                        ? Theme.of(context).textTheme.titleSmall
                                        : Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(
                                                color: MyTheme.whiteColor)),
                              ),
                              InkWell(
                                onTap: () {
                                  showCalender();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${DateFormat('d/M/y').format(selectedDate)}',
                                    style: provider.appTheme == ThemeMode.light
                                        ? Theme.of(context).textTheme.titleSmall
                                        : Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(
                                                color: MyTheme.whiteColor),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    editTask();
                                  },
                                  child: Text(
                                      AppLocalizations.of(context)!.save_change,
                                      style: provider.appTheme ==
                                              ThemeMode.light
                                          ? Theme.of(context)
                                              .textTheme
                                              .titleLarge
                                          : Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(
                                                  color: MyTheme.whiteColor))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
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

  void editTask() {
    if (formKey.currentState?.validate() == true) {
      task!.title = titleController.text;
      task!.description = descriptionController.text;
      task!.dateTime = selectedDate;
      var authProvider = Provider.of<AuthProvider>(context, listen: false);
      DialogUtils.showLoading(context, AppLocalizations.of(context)!.waiting);
      FirebaseUtils.editTask(task!, authProvider.currentuser?.id ?? '')
          .then((value) {
        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(
            context, AppLocalizations.of(context)!.task_edit_success,
            posActionName: AppLocalizations.of(context)!.ok, posAction: () {
          Navigator.pop(context);
        });
      }).timeout(Duration(milliseconds: 500), onTimeout: () {
        Fluttertoast.showToast(
            msg: AppLocalizations.of(context)!.task_edit_success,
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
