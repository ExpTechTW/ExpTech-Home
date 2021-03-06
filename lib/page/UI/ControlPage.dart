import 'dart:convert';

import 'package:exptech_home/api/Data.dart' as globals;
import 'package:exptech_home/api/NetWork.dart';
import 'package:exptech_home/page/UI/SettingPage.dart';
import 'package:exptech_home/page/system/Initialization.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../api/Get.dart';

String alert = "";
int start = 0;

class ControlPage extends StatefulWidget {
  const ControlPage({Key? key}) : super(key: key);

  @override
  _ControlPage createState() => _ControlPage();
}

class _ControlPage extends State<ControlPage> {
  WebSocketChannel channel =
      WebSocketChannel.connect(Uri.parse('ws://150.117.110.118:910'));
  late String state = "ε θΌδΈ­...";
  var State = {};
  var data;
  bool check = true;
  late int time = 0;

  @override
  void dispose() {
    start = 0;
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var LocalData = Hive.box('LocalData');
    dynamic arg = ModalRoute.of(context)?.settings.arguments;
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      if (start == 0) {
        start = 1;
        State = await Get(
            "https://raw.githubusercontent.com/ExpTechTW/API/%E4%B8%BB%E8%A6%81%E7%9A%84-(main)/Json/device/state.json");
        data = await NetWork(
            '{"Function":"home","Type":"device","UID":"${LocalData.get("UID")}","Token":"${globals.Token}","EID":"${arg["EID"]}"}');
        if (State[data["response"]["model"]] == null) {
          if (data["response"]["state"] == 1) {
            state = "π’ ιε";
          } else {
            state = "π΄ ιι";
          }
        } else {
          state = State[data["response"]["model"]]
              [data["response"]["state"].toString()];
        }
        setState(() {});
        channel =
            WebSocketChannel.connect(Uri.parse('ws://150.117.110.118:910'));
        channel.sink.add('{"EID":"${LocalData.get("token")}"}');
        channel.stream.listen((message) {
          var Data = jsonDecode(message);
          if (Data["device"] != null &&
              Data["device"]["EID"].toString() == arg["EID"].toString()) {
            if (data["response"]["state"] != Data["device"]["state"]) {
              data["response"] = Data["device"];
              if (State[data["response"]["model"]] == null) {
                if (data["response"]["state"] == 1) {
                  state = "π’ ιε";
                } else {
                  state = "π΄ ιι";
                }
              } else {
                state = State[data["response"]["model"]]
                    [data["response"]["state"].toString()];
              }
              check = true;
              time++;
              setState(() {});
            }
          }
        });
      }
    });
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            width: double.infinity,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: double.infinity,
                        ),
                        const Text(
                          "ηζ",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Text(
                          state,
                          style: const TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () async {
                      channel = WebSocketChannel.connect(
                          Uri.parse('ws://150.117.110.118:910'));
                      if (check) {
                        int STATE = time;
                        state = "ε·θ‘δΈ­...";
                        setState(() {});
                        check = false;
                        await NetWork(
                            '{"Function":"home","Type":"switch","UID":"${LocalData.get("UID")}","Token":"${globals.Token}","EID":"${arg["EID"]}"}');
                        await Future.delayed(
                            const Duration(milliseconds: 3000));
                        if (STATE == time) {
                          alert = "ζͺι ζηι―θͺ€";
                          showAlert(context);
                        }
                      } else {
                        alert = "ζ­£ε¨ε³ιζδ»€";
                        showAlert(context);
                      }
                    },
                    child: const Text("εζ"),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.grey),
                    ),
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingPage(),
                            maintainState: false,
                            settings: RouteSettings(
                              arguments: {"arg": arg, "data": data},
                            ),
                          ));
                    },
                    child: const Text("θ¨­η½?"),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<bool?> showAlert(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('θ­¦ε!'),
        content: Text(alert),
        actions: <Widget>[
          TextButton(
            child: const Text('η₯ιδΊ'),
            onPressed: () {
              if (alert == "ζͺι ζηι―θͺ€") {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InitializationPage(),
                      maintainState: false,
                    ));
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      );
    },
  );
}
