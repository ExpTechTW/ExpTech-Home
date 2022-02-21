import 'package:exptech_home/api/Data.dart' as globals;
import 'package:exptech_home/page/system/Initialization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_loggy/flutter_loggy.dart';
import 'package:loggy/loggy.dart';
import 'package:universal_io/io.dart';

import 'api/StaticDatabase.dart';

main() async {
  globals.StaticDatabase = await StaticDatabase();
  WidgetsFlutterBinding.ensureInitialized();
  Loggy.initLoggy(
    logPrinter: StreamPrinter(
      const PrettyDeveloperPrinter(),
    ),
    logOptions: const LogOptions(
      LogLevel.all,
      stackTraceLevel: LogLevel.error,
    ),
  );
  if (Platform.isIOS || Platform.isAndroid) {
    logInfo('Firebase Initialize');
    await Firebase.initializeApp();
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    globals.FirebaseToken = await FirebaseMessaging.instance.getToken();
    logInfo('FirebaseToken: ' + globals.FirebaseToken.toString());
  }else{
    globals.web=true;
  }
  logInfo('Starting App');
  runApp(const ExpTechHome());
}

class ExpTechHome extends StatelessWidget {
  const ExpTechHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InitializationPage(),
      //home: InitializationPage(),
    );
  }
}
