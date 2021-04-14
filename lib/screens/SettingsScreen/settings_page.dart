import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_demo/models/Users.dart';
import 'package:flutter_amplify_demo/routes/routes_path.dart';
import 'package:flutter_amplify_demo/screens/SettingsScreen/components/image_picker.dart';
import 'package:flutter_amplify_demo/screens/SettingsScreen/components/users_list.dart';
import 'package:flutter_amplify_demo/services/get_it_service.dart';
import 'package:flutter_amplify_demo/services/navigation_service.dart';
import 'package:flutter_amplify_demo/stores/auth.dart';
import 'package:flutter_amplify_demo/stores/user.dart';
import 'package:flutter_amplify_demo/theme/colors.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SettingsPage extends StatefulWidget {
  final Function updateHomeScreen;

  const SettingsPage({Key key, this.updateHomeScreen}) : super(key: key);
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  NavigationService _navigationService =
      get_it_instance_const<NavigationService>();

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  bool addButtonloading = false;

  Future _onRefresh() async {
    await UserStore().fetchCurrentUser();
    await UserStore().fetchAllOtherUsers();
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: MaterialClassicHeader(color: Colors.white),
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: getBody(),
      ),
    );
  }

  Widget getBody() {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
          child: Text(
            "Settings",
            style: TextStyle(
                fontSize: 23, color: white, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Consumer<UserStore>(builder: (_, userStore, __) {
          return buildUserSection(userStore.currUser);
        }),
        SizedBox(
          height: 30,
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Users List",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Consumer2<UserStore, AuthStore>(
              builder: (_, userStore, authStore, __) {
            if (userStore.allOtherUsers == null)
              return Container();
            else if (userStore.allOtherUsers.length == 0)
              return Text("Sorry there is no other user.");
            else {
              return Column(
                children: [
                  ...userStore.allOtherUsers.map((user) {
                    bool hasAdded = false;
                    if (userStore.currUser != null &&
                        userStore.currUser.chats != null)
                      userStore.currUser.chats.forEach((chat) {
                        if (json.decode(chat)['otherUserId'] == user.id)
                          hasAdded = true;
                      });
                    return UsersList(hasAdded: hasAdded, user: user);
                  }).toList()
                ],
              );
            }
          }),
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(color: textfieldColor),
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
              child: Column(
                children: [
                  buildListItem(
                    title: "Logout",
                    icon: Icons.logout,
                    onTap: () async {
                      await AuthStore().logout();
                      _navigationService.popAllAndReplace(RoutePath.Wrapper);
                    },
                  )
                ],
              ),
            ),
          ),
        ]),
      ],
    );
  }

  Container buildUserSection(Users currUser) {
    return Container(
      width: double.infinity,
      height: 90,
      decoration: BoxDecoration(color: textfieldColor),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: currUser == null
                        ? null
                        : DecorationImage(
                            image: CachedNetworkImageProvider(
                                currUser.profileImage),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  currUser == null ? "" : currUser.username,
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: white),
                ),
              ],
            ),
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                  color: white.withOpacity(0.1), shape: BoxShape.circle),
              child: ImagePickerButton(),
            )
          ],
        ),
      ),
    );
  }

  GestureDetector buildListItem({String title, IconData icon, Function onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.red,
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: white,
                    size: 20,
                  ),
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: white,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: white.withOpacity(0.2),
            size: 15,
          )
        ],
      ),
    );
  }
}
