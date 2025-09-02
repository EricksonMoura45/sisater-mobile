import 'package:enviroment_flavor/enviroment_flavor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sisater_mobile/modules/run_app_module.dart';
import 'package:sisater_mobile/shared/utils/constants.dart';

void main() {

  EnvironmentFlavor.create(
    Environment.DEV,
    URL_TESTE_SISATER,
  );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  runAppModule();
}


