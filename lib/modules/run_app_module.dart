import 'package:enviroment_flavor/enviroment_flavor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/modules/app_module.dart';
import 'package:sisater_mobile/modules/app_widget.dart';

runAppModule() async {

  WidgetsFlutterBinding.ensureInitialized();

  await EnvironmentFlavor().addPropertyAppVersion();

  runApp(
    
    ModularApp(
      module: AppModule(),
      child: const AppWidget(),
    ),
  );
}