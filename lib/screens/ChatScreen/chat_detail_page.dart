import 'package:amplify_flutter/amplify.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:amplify_datastore_plugin_interface/amplify_datastore_plugin_interface.dart';
import 'package:flutter_amplify_demo/components/show_snackbar.dart';
import 'package:flutter_amplify_demo/components/update_message_bottom_sheet.dart';
import 'package:flutter_amplify_demo/models/ChatData.dart';
import 'package:flutter_amplify_demo/screens/ChatScreen/ChatDetails/appbar.dart';
import 'package:flutter_amplify_demo/stores/chat.dart';
import 'package:flutter_amplify_demo/stores/user.dart';
import 'package:flutter_amplify_demo/theme/colors.dart';
import 'package:flutter_amplify_demo/services/size_config.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ChatDetailPage extends StatefulWidget {
  final String name;
  final String img;
  final String chatId;

  const ChatDetailPage({
    Key key,
    this.name,
    this.img,
    this.chatId,
  }) : super(key: key);
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  TextEditingController messageCtrl = TextEditingController();
  Stream<SubscriptionEvent<Chatdata>> stream;

  bool inSelectMode = false;
  List<String> selectedChats = [];

  UserStore userStore;
  ChatStore chatStore;

  // @override
  // void dispose() {
  //   chatStore.resetChatData();
  //   super.dispose();
  // }

  @override
  void initState() {
    super.initState();
    chatStore = Provider.of<ChatStore>(context, listen: false);
    userStore = Provider.of<UserStore>(context, listen: false);
    fetchChatData();
    stream = Amplify.DataStore.observe(Chatdata.classType)
      ..listen(handleSubscription);
  }

  addToSelectedChats(String messageId) {
    if (selectedChats.contains(messageId)) {
      selectedChats.remove(messageId);
      if (selectedChats.length == 0) {
        setState(() {
          inSelectMode = false;
        });
      }
    } else
      selectedChats.add(messageId);
  }

  closeSelectionModel() {
    setState(() {
      inSelectMode = false;
      selectedChats = [];
    });
  }

  deleteSelectedChats() async {
    await chatStore.deleteChats(selectedChats);
    await fetchChatData();
    setState(() {
      inSelectMode = false;
      selectedChats = [];
    });
  }

  openUpdateMessageSheet() async {
    if (selectedChats.length > 1) {
      showSnackBar(context, "Please select only one message to update.");
    } else {
      Chatdata message = await chatStore.getMessage(selectedChats[0]);
      updateMessageBottomSheet(
          context, message, chatStore.updateChat, closeSelectionModel);
    }
  }

  fetchChatData() async {
    await chatStore.fetchChatData(widget.chatId);
    if (mounted) setState(() {});
  }

  handleSubscription(SubscriptionEvent<Chatdata> event) async {
    if (event.eventType == EventType.delete) {
      fetchChatData();
    } else if (event.eventType == EventType.update) {
      fetchChatData();
    } else if (event.eventType == EventType.create) {
      if (chatStore.chatData.last.id != event.item.id &&
          event.item.chatId == chatStore.chatData.last.chatId &&
          event.item.senderId != userStore.currUser.id) {
        if (mounted)
          setState(() {
            chatStore.addUpdatedChats(event.item);
          });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: getChatDetailsAppBar(
        context: context,
        img: widget.img,
        name: widget.name,
        inSelectMode: inSelectMode,
        selectedChatCount: selectedChats.length,
        closeSelectionModel: closeSelectionModel,
        deleteSelectedChats: deleteSelectedChats,
        openUpdateMessageSheet: openUpdateMessageSheet,
      ),
      bottomSheet: getBottomSheet(),
      body: getBody(),
    );
  }

  Widget getBottomSheet() {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      // height: 60,
      decoration: BoxDecoration(color: greyColor),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.toWidth),
              child: Icon(
                Icons.add,
                color: primary,
                size: 30,
              ),
            ),
            Expanded(
              child: TextFormField(
                controller: messageCtrl,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  fillColor: Colors.white.withOpacity(0.1),
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(18))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(18))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(18))),
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(18))),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  hintText: "",
                  hintStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: IconButton(
                icon: Icon(
                  Icons.send,
                  color: primary,
                  size: 30,
                ),
                onPressed: () async {
                  chatStore.addUpdatedChats(
                    Chatdata(
                      chatId: widget.chatId,
                      message: messageCtrl.text,
                      senderId: userStore.currUser.id,
                      createdAt: TemporalTimestamp.now(),
                      updatedAt: TemporalTimestamp.now(),
                      id: Uuid().v4(),
                    ),
                  );
                  await chatStore.addChatData(
                      message: messageCtrl.text,
                      chatId: widget.chatId,
                      senderId: userStore.currUser.id);
                  messageCtrl.text = "";
                  if (mounted) setState(() {});
                  fetchChatData();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getBody() {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/bg_chat.jpg"),
              fit: BoxFit.cover)),
      child: buildChatList(chatData: chatStore.chatData),
    );
  }

  Widget buildChatList({List<Chatdata> chatData}) {
    return ListView(
      reverse: true,
      padding: EdgeInsets.only(top: 20, bottom: 80),
      children: List.generate(
        chatData.length,
        (index) {
          return buildChatBubble(
            message: chatData[index].message,
            isMe: chatData[index].senderId == userStore.currUser.id,
            time: "10:00",
            messageId: chatData[index].id,
          );
        },
      ),
    );
  }

  Widget buildChatBubble({
    Key key,
    bool isMe,
    String message,
    String time,
    String messageId,
  }) {
    if (isMe) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 2),
        child: GestureDetector(
          onLongPress: () {
            if (!inSelectMode)
              setState(() {
                inSelectMode = true;
                addToSelectedChats(messageId);
              });
            else
              setState(() {
                addToSelectedChats(messageId);
              });
          },
          onTapUp: (TapUpDetails tapUpDetails) {
            if (inSelectMode)
              setState(() {
                addToSelectedChats(messageId);
              });
          },
          child: Container(
            color: inSelectMode && selectedChats.contains(messageId)
                ? chatBoxMe.withOpacity(0.4)
                : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 14,
                        bottom: 2,
                        top: 2,
                      ),
                      child: Bubble(
                        nip: BubbleNip.rightTop,
                        color: chatBoxMe,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              message,
                              style: TextStyle(fontSize: 16, color: white),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              time,
                              style: TextStyle(
                                  fontSize: 12, color: white.withOpacity(0.4)),
                            ),
                          ],
                        ),
                      )),
                )
              ],
            ),
          ),
        ),
      );
    } else {
      return Row(
        children: [
          Flexible(
            child: Padding(
                padding: const EdgeInsets.only(right: 20, left: 14, bottom: 10),
                child: Bubble(
                  nip: BubbleNip.leftTop,
                  color: chatBoxOther,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        message,
                        style: TextStyle(fontSize: 16, color: white),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 11,
                          color: white.withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                )),
          )
        ],
      );
    }
  }
}

// ignore: must_be_immutable
class CustomBubbleChat extends StatelessWidget {
  final bool isMe;
  final String message;
  final String time;

  CustomBubbleChat({Key key, this.isMe, this.message, this.time})
      : super(key: key);

  Color chatBoxMeColor = chatBoxMe;

  @override
  Widget build(BuildContext context) {
    if (isMe) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 14, bottom: 10),
                child: Bubble(
                  nip: BubbleNip.rightTop,
                  color: chatBoxMe,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        message,
                        style: TextStyle(fontSize: 16, color: white),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        time,
                        style: TextStyle(
                            fontSize: 12, color: white.withOpacity(0.4)),
                      ),
                    ],
                  ),
                )),
          )
        ],
      );
    } else {
      return Row(
        children: [
          Flexible(
            child: Padding(
                padding: const EdgeInsets.only(right: 20, left: 14, bottom: 10),
                child: Bubble(
                  nip: BubbleNip.leftTop,
                  color: chatBoxOther,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        message,
                        style: TextStyle(fontSize: 16, color: white),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 11,
                          color: white.withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                )),
          )
        ],
      );
    }
  }
}
