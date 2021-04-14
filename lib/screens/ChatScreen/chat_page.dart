import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_demo/stores/chat.dart';
import 'package:line_icons/line_icons.dart';
import 'package:flutter_amplify_demo/screens/ChatScreen/chat_detail_page.dart';
import 'package:flutter_amplify_demo/theme/colors.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatStore chatStore;
  @override
  void initState() {
    chatStore = Provider.of<ChatStore>(context, listen: false);
    fetchUserChats();
    super.initState();
  }

  fetchUserChats() async {
    await chatStore.fetchUserChats();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: chatStore.chatData != [] ? getBody() : Container(),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 15, right: 15, left: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Chats",
                style: TextStyle(
                    fontSize: 23, color: white, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 38,
                decoration: BoxDecoration(
                  color: textfieldColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  style: TextStyle(color: white),
                  cursorColor: primary,
                  decoration: InputDecoration(
                    prefixIcon:
                        Icon(LineIcons.search, color: white.withOpacity(0.3)),
                    border: InputBorder.none,
                    hintText: "Search",
                    hintStyle:
                        TextStyle(color: white.withOpacity(0.3), fontSize: 17),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5, top: 5, right: 5),
          child: Divider(color: white.withOpacity(0.3)),
        ),
        SizedBox(
          height: 10,
        ),
        if (chatStore.userChats.length > 0)
          Column(
            children: chatStore.userChats
                .map((user) => UserChatCard(
                      context: context,
                      size: size,
                      name: user['otherUserName'],
                      profileImage: user['otherUserProfileImage'],
                      chatId: user['chatId'],
                    ))
                .toList(),
          ),
      ],
    );
  }
}

class UserChatCard extends StatelessWidget {
  const UserChatCard({
    Key key,
    @required this.context,
    @required this.size,
    @required this.name,
    @required this.profileImage,
    this.chatId,
  }) : super(key: key);

  final BuildContext context;
  final Size size;
  final String name;
  final String profileImage;
  final String chatId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatDetailPage(
              name: name,
              img: profileImage,
              chatId: chatId,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: CachedNetworkImageProvider(profileImage),
                    fit: BoxFit.cover),
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Container(
                height: 85,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: (size.width - 40) * 0.6,
                              child: Text(name,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: white,
                                      fontWeight: FontWeight.w600)),
                            ),
                            Expanded(
                              child: Text(
                                "10/08/20",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: white.withOpacity(0.4)),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      color: white.withOpacity(0.3),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
