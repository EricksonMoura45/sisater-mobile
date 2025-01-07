import 'package:enviroment_flavor/enviroment_flavor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:one_context/one_context.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
    dividerColor: Colors.transparent,    
    textTheme: GoogleFonts.publicSansTextTheme(
      Theme.of(context).textTheme,
    ),
  ),
      title: 'Sisater Mobile',
      builder: OneContext().builder,
      themeAnimationDuration: const Duration(milliseconds: 30),
      debugShowCheckedModeBanner: EnvironmentFlavor().isProd,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR')],
      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate,
    );
  }
}
