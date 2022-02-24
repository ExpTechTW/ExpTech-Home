import 'package:exptech_home/api/Data.dart' as globals;
import 'package:exptech_home/api/NetWork.dart';
import 'package:exptech_home/page/UI/ControlPage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../api/Get.dart';
import 'DeviceInfoPage.dart';
import 'DeviceUploadPage.dart';

String alert = "";
int start = 0;

class ConnectPage extends StatefulWidget {
  const ConnectPage({Key? key}) : super(key: key);

  @override
  _ConnectPage createState() => _ConnectPage();
}

class _ConnectPage extends State<ConnectPage> {
  late int _schedule = 0;
  late String _load = "初始化...";

  @override
  void dispose() {
    start = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      if (start == 0) {
        start = 1;
        _schedule = 40;
        _load = "傳遞設備參數...";
        setState(() {});
        var LocalData = Hive.box('LocalData');
        var data = await Get(
            "http://192.168.4.1:1015/get?function=wifi&ssid=${globals.SSID}&pass=${globals.PASS}&UID=${LocalData.get("UID")}&Token=${globals.Token}");
        _schedule = 60;
        _load =
            "設備連接至服務器...\nWi-Fi 名稱: ${globals.SSID}\nWi-Fi 密碼: ${globals.PASS}";
        setState(() {});
        while (true) {
          var Data = await NetWork(
              '{"Function":"home","Type":"check","EID":"${data["EID"]}"}');
          if (Data["response"] == "Success") {
            _schedule = 80;
            _load = "同步服務器數據...";
            setState(() {});
            var Data = await NetWork(
                '{"Function":"home","Type":"add","EID":"${data["EID"]}","UID":"${LocalData.get("UID")}","Token":"${globals.Token}"}');
            if (Data["response"] == "Success") {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ControlPage(),
                    maintainState: false,
                    settings: RouteSettings(
                      arguments: {
                        "EID": "${data["EID"]}",
                        "Token": globals.Token
                      },
                    ),
                  ));
            } else {
              alert = "同步服務器數據時發生異常";
              showAlert(context);
            }
            break;
          }
          await Future.delayed(const Duration(seconds: 1));
        }
      }
    });
    dynamic arg = ModalRoute.of(context)?.settings.arguments;
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
                Text(
                  _schedule.toString() + "%",
                  style: const TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Text(
                  _load,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.normal,
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
                  child: Visibility(
                    visible: false,
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DeviceUploadPage(),
                              maintainState: false,
                              settings: RouteSettings(
                                arguments: arg,
                              ),
                            ));
                      },
                      child: const Text("下一步"),
                    ),
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
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DeviceInfoPage(),
                    maintainState: false,
                  ));
            },
          ),
        ],
      );
    },
  );
}
