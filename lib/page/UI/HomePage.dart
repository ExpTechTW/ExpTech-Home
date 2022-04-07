import 'package:exptech_home/api/Data.dart' as globals;
import 'package:exptech_home/api/NetWork.dart';
import 'package:exptech_home/page/UI/ControlPage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../api/Get.dart';

int start = 0;
String alert = "";

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  WebSocketChannel channel =
      WebSocketChannel.connect(Uri.parse('ws://150.117.110.118:910'));
  late List<Widget> _children = <Widget>[];

  @override
  void dispose() {
    start = 0;
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      if (start == 0) {
        start = 1;
        var State = await Get(
            "https://raw.githubusercontent.com/ExpTechTW/API/%E4%B8%BB%E8%A6%81%E7%9A%84-(main)/Json/device/state.json");
        var LocalData = Hive.box('LocalData');
        void Info() async {
          var data = await NetWork(
              '{"Function":"home","Type":"home","UID":"${LocalData.get("UID")}","Token":"${globals.Token}"}');
          _children = <Widget>[];
          for (var i = 0; i < data["response"].length; i++) {
            String state;
            if (State[data["response"][i]["model"]] == null) {
              if (data["response"][i]["online"] == false) {
                state = "📶 設備離線";
              } else {
                if (data["response"][i]["state"] == 1) {
                  state = "🟢 開啟";
                } else {
                  state = "🔴 關閉";
                }
              }
            } else {
              if (data["response"][i]["online"] == false) {
                state = "📶 設備離線";
              } else {
                state = State[data["response"][i]["model"]]
                    [data["response"][i]["state"].toString()];
              }
            }
            _children.add(
              GestureDetector(
                onTap: () {
                  if (data["response"][i]["online"] == false) {
                    alert = "無法控制離線設備";
                    showAlert(context);
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ControlPage(),
                          maintainState: false,
                          settings: RouteSettings(
                            arguments: {"EID": "${data["response"][i]["EID"]}"},
                          ),
                        ));
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 250,
                        width: 250,
                        child: Image.network(globals.NotFoundImage),
                      ),
                      Row(
                        children: [
                          Text(
                            data["response"][i]["model"],
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 30,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              state,
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.left,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
            setState(() {});
          }
        }
        Info();
        channel =
            WebSocketChannel.connect(Uri.parse('ws://150.117.110.118:910'));
        channel.sink.add('{"EID":"${LocalData.get("token")}"}');
        channel.stream.listen((message) {
          Info();
        });
      }
    });
    return Scaffold(
      body: RefreshIndicator(
        child: ListView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          children: _children.toList(),
        ),
        onRefresh: () async {
          start = 0;
          _children = <Widget>[];
          setState(() {});
          await Future.delayed(const Duration(milliseconds: 1000));
          while (true) {
            if (start == 1) {
              break;
            }
            await Future.delayed(const Duration(milliseconds: 100));
          }
          return;
        },
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
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
