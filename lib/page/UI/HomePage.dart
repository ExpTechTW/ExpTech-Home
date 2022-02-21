import 'package:exptech_home/api/Data.dart' as globals;
import 'package:exptech_home/api/NetWork.dart';
import 'package:exptech_home/page/UI/ControlPage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../api/Get.dart';

int start = 0;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final scrollController = ScrollController();
  final List<Widget> _children = <Widget>[];

  @override
  void dispose() {
    scrollController.dispose();
    start = 0;
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
        var data = await NetWork(
            '{"Function":"home","Type":"home","UID":"${LocalData.get("UID")}","Token":"${globals.Token}"}');
        for (var i = 0; i < data["response"].length; i++) {
          String state;
          if(State[data["response"][i]["model"]]==null){
            if(data["response"][i]["state"]==1){
              state="🟢 開啟";
            }else{
              state="🔴 關閉";
            }
          }else{
            state=State[data["response"][i]["model"]][data["response"][i]["state"].toString()];
          }
          _children.add(
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ControlPage(),
                      maintainState: false,
                      settings: RouteSettings(
                        arguments: {
                          "EID": "${data["response"][i]["EID"]}",
                          "Token": globals.Token
                        },
                      ),
                    ));
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child:  Column(
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
    });

    return SingleChildScrollView(
      child: Column(
        children: _children,
      ),
    );
  }
}
