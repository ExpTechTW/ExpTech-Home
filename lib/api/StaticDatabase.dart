import 'dart:async';
import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:loggy/loggy.dart';

Future<Map<String, dynamic>> StaticDatabase() async {
  try {
    var response = await http.get(Uri.parse(
        "https://raw.githubusercontent.com/ExpTechTW/RecordTree/%E7%A9%A9%E5%AE%9A%E7%89%88-(Release)/StaticDatabase/Index.json"));
    var jsonResponse;
    if (response.statusCode == 200) {
      jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      Log(LogLevel.debug, jsonResponse);
      return jsonResponse;
    } else {
      Log(LogLevel.error, "StaticDatabase Not Found");
      return jsonDecode('{"state":"Error","response":"404"}');
    }
  } on SocketException catch (e) {
    String msg = e.message;
    Log(LogLevel.error, msg);
    return jsonDecode('{"state":"Error","response":"$msg"}');
  }
}

class Log with NetworkLoggy {
  Log(level, msg) {
    switch (level) {
      case LogLevel.error:
        loggy.error(msg);
        break;
      case LogLevel.warning:
        loggy.warning(msg);
        break;
      case LogLevel.info:
        loggy.info(msg);
        break;
      case LogLevel.debug:
        loggy.debug(msg);
        break;
    }
  }
}
