import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_demo/models/Users.dart';
import 'package:flutter_amplify_demo/stores/chat.dart';
import 'package:flutter_amplify_demo/stores/user.dart';
import 'package:flutter_amplify_demo/theme/colors.dart';

class UsersList extends StatefulWidget {
  final Users user;
  final bool hasAdded;
  UsersList({Key key, this.user, this.hasAdded}) : super(key: key);

  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  bool addButtonloading = false;
  @override
  Widget build(BuildContext context) {
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
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(
                            widget.user.profileImage,
                          ),
                          fit: BoxFit.cover)),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  widget.user.username,
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: white),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                      color: white.withOpacity(0.1), shape: BoxShape.circle),
                  child: Center(
                    child: addButtonloading
                        ? CircularProgressIndicator()
                        : IconButton(
                            icon: Icon(
                              widget.hasAdded ? Icons.check : Icons.add,
                              size: 20,
                            ),
                            color: primary,
                            onPressed: () async {
                              if (!widget.hasAdded) {
                                setState(() {
                                  addButtonloading = true;
                                });
                                await ChatStore()
                                    .addUserToChatList(widget.user);
                                await UserStore().fetchCurrentUser();
                                await ChatStore().fetchUserChats();
                                setState(() {
                                  addButtonloading = false;
                                });
                              }
                            },
                          ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
