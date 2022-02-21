import 'package:exptech_home/api/Data.dart' as globals;
import 'package:flutter/material.dart';

import 'DeviceUploadPage.dart';

class AddDevicePage extends StatelessWidget {
  const AddDevicePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    dynamic arg = ModalRoute.of(context)?.settings.arguments;
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
                    arg["Introduction"] ??
                        "若 藍色指示燈 為非快速閃爍，請長按 Reset 按鈕，直到 藍色指示燈 快速閃爍",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                Image.network(
                  arg["initialize"] ?? globals.NotFoundImage,
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
                      Navigator.pushReplacement(
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
            ],
          ),
        ],
      ),
    );
  }
}
