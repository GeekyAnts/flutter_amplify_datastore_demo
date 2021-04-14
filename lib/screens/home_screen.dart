import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_demo/screens/SettingsScreen/settings_page.dart';
import 'package:flutter_amplify_demo/stores/user.dart';
import 'package:line_icons/line_icons.dart';
import 'package:flutter_amplify_demo/screens/ChatScreen/chat_page.dart';
import 'package:flutter_amplify_demo/screens/StatusScreens/status_page.dart';
import 'package:flutter_amplify_demo/theme/colors.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pageIndex = 0;

  UserStore userStore;

  @override
  void initState() {
    super.initState();
    userStore = context.read<UserStore>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: getBody(),
      bottomNavigationBar: getFooter(),
    );
  }

  Widget getBody() {
    return IndexedStack(
      index: pageIndex,
      children: [
        ChatPage(),
        StatusPage(),
        SettingsPage(),
      ],
    );
  }

  Widget getFooter() {
    List iconItems = [
      LineIcons.circle,
      LineIcons.comment,
      Icons.settings,
    ];
    List textItems = ["Chats", "Status", "Settings"];
    return Container(
      height: 90,
      width: double.infinity,
      decoration: BoxDecoration(color: greyColor),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            textItems.length,
            (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    pageIndex = index;
                  });
                },
                child: Column(
                  children: [
                    Icon(
                      iconItems[index],
                      color:
                          pageIndex == index ? primary : white.withOpacity(0.5),
                      size: 29,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      textItems[index],
                      style: TextStyle(
                        fontSize: 12,
                        color: pageIndex == index
                            ? primary
                            : white.withOpacity(0.5).withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
