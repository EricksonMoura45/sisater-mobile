import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/modules/app_store.dart';

appBarhome(BuildContext context) {
  return AppBar(
      leading: Builder(
      builder: (BuildContext buildContext) {
        return IconButton(
          icon: Icon(
            Icons.menu,
            color: Theme.of(context).colorScheme.onBackground,
            size: 28,
          ),
          onPressed: () => Scaffold.of(buildContext).openDrawer(),
          tooltip: MaterialLocalizations.of(buildContext).openAppDrawerTooltip,
        );
      },
    ), 
    );
}