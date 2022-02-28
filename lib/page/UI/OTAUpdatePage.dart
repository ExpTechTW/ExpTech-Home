import 'dart:convert';

import 'package:exptech_home/api/Data.dart' as globals;
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hive/hive.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../api/NetWork.dart';

String alert = "";

class OTAUpdatePage extends StatefulWidget {
  const OTAUpdatePage({Key? key}) : super(key: key);

  @override
  _OTAUpdatePage createState() => _OTAUpdatePage();
}

class _OTAUpdatePage extends State<OTAUpdatePage> {
  WebSocketChannel channel =
      WebSocketChannel.connect(Uri.parse('ws://150.117.110.118:910'));
  bool button = true;
  late String _button = "升級";
  Color buttonColor = Colors.blue;

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    dynamic arg = ModalRoute.of(context)?.settings.arguments;
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      arg["ver"],
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MarkdownBody(data: arg["note"]),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: buttonColor // background
                            ),
                        onPressed: () async {
                          var LocalData = Hive.box('LocalData');
                          if (button) {
                            button = false;
                            _button = "正在升級...(請勿關閉頁面)";
                            buttonColor = Colors.grey;
                            setState(() {});
                            String Url = "http://220.134.162.44/firmware/" +
                                arg["type"] +
                                "/" +
                                arg["model"] +
                                "/" +
                                arg["model"] +
                                "_" +
                                arg["ver"] +
                                ".bin";
                            await NetWork(
                                '{"Url":"$Url","Function":"home","Type":"update","UID":"${LocalData.get("UID")}","Token":"${globals.Token}","EID":"${arg["EID"]}"}');
                            channel.sink
                                .add('{"EID":"${LocalData.get("token")}"}');
                            channel.stream.listen((message) {
                              var data = jsonDecode(message);
                              if (data["EID"].toString() == arg["EID"] &&
                                  data["Time"].toString() != arg["Time"] &&
                                  data["Time"] != 0) {
                                _button = "升級完成";
                                buttonColor = Colors.green;
                                setState(() {});
                              }
                            });
                          } else {
                            if (_button == "升級完成") {
                              alert = "升級完成";
                              showAlert(context);
                            } else {
                              alert = "升級中 請稍後";
                              showAlert(context);
                            }
                          }
                        },
                        child: Text(_button),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )),
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
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
