import 'dart:convert';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_demo/models/ChatData.dart';
import 'package:flutter_amplify_demo/models/Users.dart';
import 'package:flutter_amplify_demo/stores/user.dart';
import 'package:uuid/uuid.dart';

class ChartRepository {
  Future addUserToChatList({Users otherUser}) async {
    AuthUser authUser = await Amplify.Auth.getCurrentUser();
    Users user = (await Amplify.DataStore.query(Users.classType,
        where: Users.ID.eq(authUser.userId)))[0];
    String chatId = Uuid().v4();
    Map<String, dynamic> updateChatData = {
      'chatId': chatId,
      "otherUserId": otherUser.id,
      'otherUserProfileImage': otherUser.profileImage,
      'otherUserName': otherUser.username,
    };

    List<String> tempJsonData =
        new List<String>.from(user.chats == null ? [] : user.chats);
    tempJsonData.add(json.encode(updateChatData));
    Users updatedUser = user.copyWith(chats: tempJsonData);
    await Amplify.DataStore.save(updatedUser);

    Map<String, dynamic> otherUserChatData = {
      'chatId': chatId,
      "otherUserId": user.id,
      'otherUserProfileImage': user.profileImage,
      'otherUserName': user.username,
    };

    List<String> tempOtherUserJsonData =
        new List<String>.from(otherUser.chats == null ? [] : otherUser.chats);
    tempOtherUserJsonData.add(json.encode(otherUserChatData));
    Users updatedOtherUser = otherUser.copyWith(chats: tempOtherUserJsonData);
    await Amplify.DataStore.save(updatedOtherUser);
  }

  Future<List<Map<String, dynamic>>> getUserChatList() async {
    try {
      List<Map<String, dynamic>> data = [];
      Users users = UserStore().currUser;
      if (users == null) return data;
      if (users.chats == null) return data;
      users.chats.forEach((chat) {
        print("===> ${json.decode(chat)['chatId']}");
        data.add(json.decode(chat));
      });
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future addChatData({
    @required String message,
    @required String chatId,
    @required String senderId,
  }) async {
    Chatdata chat = Chatdata(
      createdAt: TemporalTimestamp.now(),
      updatedAt: TemporalTimestamp.now(),
      message: message,
      chatId: chatId,
      senderId: senderId,
    );
    await Amplify.DataStore.save(chat);
  }

  Future<List<Chatdata>> getChatData({@required String chatId}) async {
    List<Chatdata> chatData = await Amplify.DataStore.query(Chatdata.classType,
        where: Chatdata.CHATID.eq(chatId),
        sortBy: [Chatdata.CREATEDAT.descending()]);

    return chatData;
  }

  Future deleteChats(List<String> messageIdList) async {
    for (String messageId in messageIdList) {
      Chatdata chatdata = (await Amplify.DataStore.query(Chatdata.classType,
          where: Chatdata.ID.eq(messageId)))[0];
      print("Deleting ==> ${chatdata.message}");
      await Amplify.DataStore.delete(chatdata);
    }
  }

  Future updateChats(String messageId, String updatedMessage) async {
    Chatdata messagedata = (await Amplify.DataStore.query(Chatdata.classType,
        where: Chatdata.ID.eq(messageId)))[0];
    await Amplify.DataStore.save(messagedata.copyWith(message: updatedMessage));
  }
}
