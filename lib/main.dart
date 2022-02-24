import 'package:exptech_home/api/Data.dart' as globals;
import 'package:exptech_home/page/system/Initialization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_loggy/flutter_loggy.dart';
import 'package:loggy/loggy.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:universal_io/io.dart';

import 'api/Get.dart';

main() async {
  globals.StaticDatabase = await Get(
          "https://raw.githubusercontent.com/ExpTechTW/API/%E4%B8%BB%E8%A6%81%E7%9A%84-(main)/StaticDatabase/Index.json")
      as Map<String, dynamic>;
  WidgetsFlutterBinding.ensureInitialized();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  globals.ver=packageInfo.version;
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
  } else {
    globals.web = true;
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
