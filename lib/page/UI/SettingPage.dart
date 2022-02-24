import 'package:exptech_home/page/UI/OTAPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

int start = 0;

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPage createState() => _SettingPage();
}

class _SettingPage extends State<SettingPage> {
  var data;

  @override
  Widget build(BuildContext context) {
    dynamic Data = ModalRoute.of(context)?.settings.arguments;
    var arg = Data["arg"];
    arg["model"] = Data["data"]["response"]["model"];
    data = Data["data"]["response"];
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OTAPage(),
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
                        const Text(
                          "版本",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Text(
                          data["ver"],
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Text(
                          (data["ver"].indexOf("pre") != -1)
                              ? "開發版"
                              : (data["ver"].indexOf("rc") != -1)
                                  ? "預覽版"
                                  : "穩定版",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "網路",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        "SSID: " + data["SSID"],
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        "RSSI: " + data["RSSI"].toString(),
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "設備",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        "EID: " + data["EID"].toString(),
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        "型號: " + data["model"],
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        "MAC 位址: " + data["macAddress"],
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        "本地 IP: " + data["localIP"],
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        "CPU 頻率: " + data["CpuFreqMHz"].toString(),
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        "HeapSize: " + data["HeapSize"].toString(),
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        "FreeHeap: " + data["FreeHeap"].toString(),
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        "MinFreeHeap: " + data["MinFreeHeap"].toString(),
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        "MaxAllocHeap: " + data["MaxAllocHeap"].toString(),
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        "SketchSize: " + data["SketchSize"].toString(),
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        "FreeSketchSpace: " +
                            data["FreeSketchSpace"].toString(),
                        style: const TextStyle(
                          fontSize: 25,
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
      ),
    );
  }
}
