import 'package:exptech_home/api/Data.dart' as globals;
import 'package:exptech_home/page/UI/DeviceInfoPage.dart';
import 'package:flutter/material.dart';

String alert = "";

class DeviceUploadPage extends StatefulWidget {
  const DeviceUploadPage({Key? key}) : super(key: key);

  @override
  _DeviceUploadPage createState() => _DeviceUploadPage();
}

class _DeviceUploadPage extends State<DeviceUploadPage> {
  final GlobalKey _key = GlobalKey<FormState>();
  final TextEditingController _ssid = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final FocusNode _s = FocusNode();
  final FocusNode _p = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _ssid.dispose();
    _pass.dispose();
    _s.dispose();
    _p.dispose();
  }

  @override
  Widget build(BuildContext context) {
    dynamic arg = ModalRoute.of(context)?.settings.arguments;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "請輸入能被設備接收到的 Wi-Fi 網路",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Form(
                  key: _key,
                  child: Column(
                    children: [
                      TextFormField(
                        focusNode: _s,
                        controller: _ssid,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.wifi),
                          labelText: "Wi-Fi 名稱",
                          hintText: "請輸入 Wi-Fi 名稱",
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return "Wi-Fi 名稱 不為空";
                          }
                          return null;
                        },
                        onFieldSubmitted: (v) {},
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        focusNode: _p,
                        controller: _pass,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.password),
                          labelText: "Wi-Fi 密碼",
                          hintText: "請輸入 Wi-Fi 密碼",
                        ),
                        textInputAction: TextInputAction.done,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return "Wi-Fi 密碼 不為空";
                          }
                          return null;
                        },
                        onFieldSubmitted: (v) {},
                      ),
                    ],
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
                      if ((_key.currentState as FormState).validate()) {
                        globals.SSID = _ssid.text;
                        globals.PASS = _pass.text;
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DeviceInfoPage(),
                              maintainState: false,
                              settings: RouteSettings(
                                arguments: arg,
                              ),
                            ));
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
        title: const Text('通知!'),
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
