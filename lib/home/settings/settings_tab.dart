import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo/home/settings/language_bottom_sheet.dart';
import 'package:todo/home/settings/theme_bottom_sheet.dart';
import 'package:todo/my_theme.dart';
import 'package:todo/providers/app_config_provider.dart';

class SettingsTab extends StatefulWidget {
  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(AppLocalizations.of(context)!.settings,
      //   style: provider.appTheme==ThemeMode.light?
      //       Theme.of(context).textTheme.titleMedium!.copyWith(color: MyTheme.whiteColor):
      //       Theme.of(context).textTheme.titleMedium!.copyWith(color: MyTheme.blackDark)
      //   ,
      // ),
      // ),
      body: Container(
        margin: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(AppLocalizations.of(context)!.language,
                style: provider.appTheme == ThemeMode.light
                    ? Theme.of(context).textTheme.titleSmall
                    : Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: MyTheme.whiteColor)),
            InkWell(
              onTap: () {
                showLanguageBottomSheet();
                setState(() {});
              },
              child: Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: provider.appTheme == ThemeMode.light
                          ? MyTheme.whiteColor
                          : MyTheme.blackDark,
                      border:
                          Border.all(color: MyTheme.primaryLight, width: 2)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          provider.appLanguage == 'en'
                              ? AppLocalizations.of(context)!.english
                              : AppLocalizations.of(context)!.arabic,
                          style: TextStyle(
                              fontSize: 14, color: MyTheme.primaryLight),
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: MyTheme.primaryLight,
                      )
                    ],
                  )),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              AppLocalizations.of(context)!.mode,
              style: provider.appTheme == ThemeMode.light
                  ? Theme.of(context).textTheme.titleSmall
                  : Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: MyTheme.whiteColor),
            ),
            InkWell(
              onTap: () {
                showThemeBottomSheet();
                setState(() {});
              },
              child: Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: provider.appTheme == ThemeMode.light
                          ? MyTheme.whiteColor
                          : MyTheme.blackDark,
                      border:
                          Border.all(color: MyTheme.primaryLight, width: 2)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          provider.appTheme == ThemeMode.light
                              ? AppLocalizations.of(context)!.light_mode
                              : AppLocalizations.of(context)!.dark_mode,
                          style: TextStyle(
                              fontSize: 14, color: MyTheme.primaryLight),
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: MyTheme.primaryLight,
                      )
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  void showLanguageBottomSheet() {
    showModalBottomSheet(
        context: context, builder: (context) => LanguageBottommSheet());
  }

  void showThemeBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => ThemeBottomSheet(),
    );
  }
}
