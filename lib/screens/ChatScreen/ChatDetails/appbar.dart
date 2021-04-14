import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_demo/theme/colors.dart';
import 'package:line_icons/line_icons.dart';

Widget getChatDetailsAppBar({
  BuildContext context,
  String img,
  String name,
  bool inSelectMode,
  int selectedChatCount,
  Function closeSelectionModel,
  Function deleteSelectedChats,
  Function openUpdateMessageSheet,
}) {
  return AppBar(
    brightness: Brightness.dark,
    backgroundColor: greyColor,
    title: inSelectMode
        ? Container(child: Text(selectedChatCount.toString()))
        : Container(
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(img),
                        fit: BoxFit.cover),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: 150,
                  child: Text(
                    name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
    leading: inSelectMode
        ? GestureDetector(
            onTap: () {
              closeSelectionModel();
            },
            child: Icon(
              Icons.cancel_outlined,
            ),
          )
        : GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
            ),
          ),
    actions: inSelectMode
        ? [
            IconButton(
                icon: Icon(Icons.edit, size: 30),
                onPressed: () async {
                  await openUpdateMessageSheet();
                }),
            SizedBox(width: 20),
            IconButton(
                icon: Icon(Icons.delete, size: 30),
                onPressed: () async {
                  await deleteSelectedChats();
                }),
            SizedBox(width: 20),
            IconButton(
              icon: Icon(Icons.more_vert, size: 30),
              onPressed: () async {},
            ),
            SizedBox(width: 20),
          ]
        : [
            Icon(LineIcons.phone, size: 30),
            SizedBox(width: 20),
            Icon(Icons.more_vert, size: 30),
            SizedBox(width: 20),
          ],
  );
}
