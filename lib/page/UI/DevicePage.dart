import 'package:exptech_home/api/Data.dart' as globals;
import 'package:exptech_home/page/UI/AddDevicePage.dart';
import 'package:flutter/material.dart';

import '../../api/Get.dart';

int start = 0;

class DevicePage extends StatefulWidget {
  const DevicePage({Key? key}) : super(key: key);

  @override
  _DevicePage createState() => _DevicePage();
}

class _DevicePage extends State<DevicePage> {
  final scrollController = ScrollController();
  final List<Widget> _children = <Widget>[];

  @override
  void dispose() {
    start = 0;
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      if (start == 0) {
        start = 1;
        var data = await Get(
                "https://raw.githubusercontent.com/ExpTechTW/API/%E4%B8%BB%E8%A6%81%E7%9A%84-(main)/Json/device/info.json")
            as List;
        for (var i = 0; i < data.length; i++) {
          String image;
          if (data[i]["image"] == null) {
            image = globals.NotFoundImage;
          } else {
            image = data[i]["image"];
          }
          _children.add(
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddDevicePage(),
                      maintainState: false,
                      settings: RouteSettings(
                        arguments: data[i],
                      ),
                    ));
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Image.network(
                        image,
                        height: 80,
                        width: 80,
                      ),
                    ),
                    Text(
                      data[i]["name"],
                      style: const TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        setState(() {});
      }
    });

    return SingleChildScrollView(
      child: Column(
        children: _children,
      ),
    );
  }
}
