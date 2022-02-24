import 'package:exptech_home/page/UI/OTAUpdatePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../api/Get.dart';

int start = 0;

class OTAPage extends StatefulWidget {
  const OTAPage({Key? key}) : super(key: key);

  @override
  _OTAPage createState() => _OTAPage();
}

class _OTAPage extends State<OTAPage> {
  final List<Widget> _children = <Widget>[];

  @override
  void dispose() {
    start = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    dynamic arg = ModalRoute.of(context)?.settings.arguments;
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      if (start == 0) {
        start = 1;
        var Data = await Get("http://220.134.162.44/firmware/version.json");
        String device = Data[arg["model"]];
        var data = await Get(
            "http://220.134.162.44/firmware/" + device + "/version.json");
        for (var i = 0; i < data[device].length; i++) {
          if (data[device][i]["device"].indexOf(arg["model"]) != -1) {
            String image = "";
            if (data[device][i]["reclaimed"] == true) {
              image =
                  "https://raw.githubusercontent.com/ExpTechTW/API/%E4%B8%BB%E8%A6%81%E7%9A%84-(main)/image/Icon/Reclaimed.webp";
            } else if (i == 0 &&
                data[device][i]["ver"].indexOf("pre") == -1 &&
                data[device][i]["ver"].indexOf("rc") != -1) {
              image =
                  "https://raw.githubusercontent.com/ExpTechTW/API/%E4%B8%BB%E8%A6%81%E7%9A%84-(main)/image/Icon/Latest.webp";
            } else if (data[device][i]["ver"].indexOf("pre") != -1 ||
                data[device][i]["ver"].indexOf("rc") != -1) {
              image =
                  "https://raw.githubusercontent.com/ExpTechTW/API/%E4%B8%BB%E8%A6%81%E7%9A%84-(main)/image/Icon/Pre-Release.webp";
            } else {
              image =
                  "https://raw.githubusercontent.com/ExpTechTW/API/%E4%B8%BB%E8%A6%81%E7%9A%84-(main)/image/Icon/Release.webp";
            }
            String note = "# 開發人員未提供相關資訊";
            var Data = await Get("https://api.github.com/repos/ExpTechTW/" +
                device +
                "/releases") as List;
            for (var i = 0; i < Data.length; i++) {
              if (Data[i]["tag_name"] == data[device][i]["ver"]) {
                note = Data[i]["body"];
              }
            }
            _children.add(
              GestureDetector(
                onTap: () {
                  arg["ver"] = data[device][i]["ver"];
                  arg["note"] = note;
                  arg["type"] = device;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OTAUpdatePage(),
                        maintainState: false,
                        settings: RouteSettings(
                          arguments: arg,
                        ),
                      ));
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              data[arg["model"]][i]["ver"],
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Image.network(
                              image,
                              width: 50,
                              height: 50,
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        MarkdownBody(data: note),
                      ],
                    ),
                  ),
                ),
              ),
            );
            setState(() {});
          }
        }
      }
    });

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: _children,
          ),
        ),
      ),
    );
  }
}
