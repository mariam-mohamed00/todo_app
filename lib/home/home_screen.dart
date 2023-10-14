import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo/auth/login/login_screen.dart';
import 'package:todo/home/settings/settings_tab.dart';
import 'package:todo/home/task_list/add_task_bottom_sheet.dart';
import 'package:todo/home/task_list/task_list_tab.dart';
import 'package:todo/my_theme.dart';
import 'package:todo/providers/app_config_provider.dart';
import 'package:todo/providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'Home Screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    // var listProvider = Provider.of<ListProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          selectedIndex == 0
              ? AppLocalizations.of(context)!.to_do_app_bar +
                  ' ${authProvider.currentuser!.name}'
              : AppLocalizations.of(context)!.settings,
          style: provider.appTheme == ThemeMode.light
              ? Theme.of(context).textTheme.titleLarge
              : Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: MyTheme.blackDark),
        ),
        actions: [
          IconButton(
              onPressed: () {
                // listProvider.tasksList=[];
                // authProvider.currentuser = null;
                Navigator.pushReplacementNamed(context, LoginScreen.routeName);
              },
              icon: Icon(Icons.login)),
        ],
      ),
      body: tabs[selectedIndex],
      bottomNavigationBar: provider.appTheme == ThemeMode.light
          ? BottomAppBar(
              shape: CircularNotchedRectangle(),
              notchMargin: 8,
              child: BottomNavigationBar(
                currentIndex: selectedIndex,
                onTap: (index) {
                  selectedIndex = index;
                  setState(() {});
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.list),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    label: '',
                  ),
                ],
              ),
            )
          : BottomAppBar(
              shadowColor: MyTheme.whiteColor,
              elevation: 20,
              color: MyTheme.blackDark,
              shape: CircularNotchedRectangle(),
              notchMargin: 10,
              child: BottomNavigationBar(
                currentIndex: selectedIndex,
                onTap: (index) {
                  selectedIndex = index;
                  setState(() {});
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.list),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    label: '',
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          provider.appTheme == ThemeMode.light
              ? showModalBottomSheet(
                  context: context, builder: (context) => AddTaskBottomSheet())
              : showModalBottomSheet(
                  backgroundColor: MyTheme.blackDark,
                  context: context,
                  builder: (context) => AddTaskBottomSheet());
          setState(() {});
        },
        child: Icon(
          Icons.add,
          size: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  List<Widget> tabs = [TaskListTab(), SettingsTab()];
}
