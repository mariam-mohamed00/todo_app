import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo/my_theme.dart';
import 'package:todo/providers/app_config_provider.dart';

class ThemeBottomSheet extends StatefulWidget {
  @override
  State<ThemeBottomSheet> createState() => _ThemeBottomSheetState();
}

class _ThemeBottomSheetState extends State<ThemeBottomSheet> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return Container(
      color: provider.appTheme == ThemeMode.light
          ? MyTheme.whiteColor
          : MyTheme.blackDark,
      child: Column(
        children: [
          InkWell(
              onTap: () {
                provider.changeTheme(ThemeMode.light);
              },
              child: provider.appTheme == ThemeMode.light
                  ? getSelected(AppLocalizations.of(context)!.light_mode)
                  : getUnSelected(AppLocalizations.of(context)!.light_mode)),
          InkWell(
              onTap: () {
                provider.changeTheme(ThemeMode.dark);
              },
              child: provider.appTheme == ThemeMode.dark
                  ? getSelected(AppLocalizations.of(context)!.dark_mode)
                  : getUnSelected(AppLocalizations.of(context)!.dark_mode))
        ],
      ),
    );
  }

  Widget getSelected(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(text,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: MyTheme.primaryLight)),
          ),
          Icon(
            Icons.check,
            size: 25,
            color: MyTheme.primaryLight,
          )
        ],
      ),
    );
  }

  Widget getUnSelected(String text) {
    var provider = Provider.of<AppConfigProvider>(context);

    return Padding(
      padding: EdgeInsets.all(8),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(text,
              style: provider.appTheme == ThemeMode.light
                  ? Theme.of(context).textTheme.titleSmall
                  : Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: MyTheme.whiteColor)),
        ),
      ]),
    );
  }
}
