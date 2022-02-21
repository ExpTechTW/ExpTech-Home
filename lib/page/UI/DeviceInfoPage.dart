import 'package:exptech_home/page/UI/ConnectPage.dart';
import 'package:flutter/material.dart';

import '../../api/Get.dart';

String alert = "";
dynamic arg;

class DeviceInfoPage extends StatelessWidget {
  const DeviceInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    arg = ModalRoute.of(context)?.settings.arguments;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: double.infinity,
          ),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    arg["name"],
                    style: const TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    arg["ConnectIntroduction"] ??
                        "連接至 設備 Wi-Fi 訊號 開始初始化設備\nWi-Fi 名稱: ${arg["name"]}\nWi-Fi 密碼: 1234567890",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                Image.network(
                  "https://raw.githubusercontent.com/ExpTechTW/API/%E4%B8%BB%E8%A6%81%E7%9A%84-(main)/image/Device/ET_Smart_Socket.png",
                  width: 250,
                  height: 250,
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
                      var data = await Get(
                          "http://192.168.4.1:1015/get?function=info");
                      if (data["ver"] == null) {
                        alert = "未連接至設備訊號";
                        showAlert(context);
                      } else {
                        if (data["model"] != arg["name"]) {
                          alert = "設備型號驗證異常";
                          showAlert(context);
                        } else {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ConnectPage(),
                                maintainState: false,
                                settings: RouteSettings(
                                  arguments: arg,
                                ),
                              ));
                        }
                      }
                    },
                    child: const Text("下一步"),
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
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
