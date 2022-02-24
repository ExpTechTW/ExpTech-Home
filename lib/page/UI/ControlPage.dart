import 'dart:convert';

import 'package:exptech_home/api/Data.dart' as globals;
import 'package:exptech_home/api/NetWork.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:web_socket_channel/io.dart';

import '../../api/Get.dart';

String alert = "";
int start = 0;
IOWebSocketChannel channel = IOWebSocketChannel.connect(
  'ws://150.117.110.118:910',
);

class ControlPage extends StatefulWidget {
  const ControlPage({Key? key}) : super(key: key);

  @override
  _ControlPage createState() => _ControlPage();
}

class _ControlPage extends State<ControlPage> {
  late String state = "加載中...";
  var State = {};

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
        channel = IOWebSocketChannel.connect(
          'ws://150.117.110.118:910',
        );
        channel.sink.add('{"test":"1","EID":"${LocalData.get("token")}"}');
        State = await Get(
            "https://raw.githubusercontent.com/ExpTechTW/API/%E4%B8%BB%E8%A6%81%E7%9A%84-(main)/Json/device/state.json");
        var data = await NetWork(
            '{"Function":"home","Type":"device","UID":"${LocalData.get("UID")}","Token":"${globals.Token}","EID":"${arg["EID"]}"}');
        if (State[data["response"]["model"]] == null) {
          if (data["response"]["state"] == 1) {
            state = "🟢 開啟";
          } else {
            state = "🔴 關閉";
          }
        } else {
          state = State[data["response"]["model"]]
              [data["response"]["state"].toString()];
        }
        setState(() {});
        channel.stream.listen((message) {
          var data = jsonDecode(message);
          if (State[data["model"]] == null) {
            if (data["state"] == 1) {
              state = "🟢 開啟";
            } else {
              state = "🔴 關閉";
            }
          } else {
            state = State[data["model"]][data["state"].toString()];
          }
          setState(() {});
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
                          "狀態",
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
                      await NetWork(
                          '{"Function":"home","Type":"switch","UID":"${LocalData.get("UID")}","Token":"${globals.Token}","EID":"${arg["EID"]}"}');
                    },
                    child: const Text("切換"),
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
                    onPressed: () async {},
                    child: const Text("設置"),
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
        title: const Text('警告!'),
        content: Text(alert),
        actions: <Widget>[
          TextButton(
            child: const Text('知道了'),
            onPressed: () {},
          ),
        ],
      );
    },
  );
}
