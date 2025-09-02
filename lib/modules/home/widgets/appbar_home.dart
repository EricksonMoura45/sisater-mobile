import 'package:flutter/material.dart';

appBarhome(BuildContext context) {
  return AppBar(
    shadowColor: Colors.white,
    surfaceTintColor: Colors.white,
    leading: Builder(
      builder: (BuildContext buildContext) {
        return IconButton(
          icon: Icon(
            Icons.menu,
            color: Theme.of(context).colorScheme.onSurface,
            size: 28,
          ),
          onPressed: () => Scaffold.of(buildContext).openDrawer(),
          tooltip: MaterialLocalizations.of(buildContext).openAppDrawerTooltip,
        );
      },
    ),
    actions: [
     
    ],
  );
}