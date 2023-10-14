import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo/providers/app_config_provider.dart';

import '../../my_theme.dart';

class LanguageBottommSheet extends StatelessWidget {
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
              provider.changeLanguage('en');
            },
            child: provider.appLanguage == 'en'
                ? getSelectedItemWidget(
                    context, AppLocalizations.of(context)!.english)
                : getUnSelectedItemWidget(
                    context, AppLocalizations.of(context)!.english),
          ),
          InkWell(
            onTap: () {
              provider.changeLanguage('ar');
            },
            child: provider.appLanguage == 'ar'
                ? getSelectedItemWidget(
                    context, AppLocalizations.of(context)!.arabic)
                : getUnSelectedItemWidget(
                    context, AppLocalizations.of(context)!.arabic),
          ),
        ],
      ),
    );
  }

  Widget getSelectedItemWidget(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.all(8),
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
          ),
        ],
      ),
    );
  }

  Widget getUnSelectedItemWidget(BuildContext context, String text) {
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
                        .copyWith(color: MyTheme.whiteColor))),
      ]),
    );
  }
}
