import 'package:exptech_home/api/Data.dart' as globals;
import 'package:exptech_home/page/function/ArticlePage.dart';
import 'package:flutter/material.dart';

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
        _children.add(
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArticlePage(),
                    maintainState: false,
                    settings: const RouteSettings(
                      arguments: {"type": "無法連線至 API 服務器"},
                    ),
                  ));
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: Image.network(globals.NotFoundImage),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "whes1015",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Text("2022/02/05 22:56"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 250,
                    width: 250,
                    child: Image.network(globals.NotFoundImage),
                  ),
                  Row(
                    children: const [
                      Text(
                        "10 👀 | 26 ❤ | 1 💬 | 300 🔥",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  Row(
                    children: const [
                      Expanded(
                        child: Text(
                          "1234567890",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
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
    });

    return SingleChildScrollView(
      child: Column(
        children: _children,
      ),
    );
  }
}
