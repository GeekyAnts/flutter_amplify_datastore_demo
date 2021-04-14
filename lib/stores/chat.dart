import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_demo/models/Users.dart';
import 'package:flutter_amplify_demo/repositories/chat_repository.dart';
import 'package:flutter_amplify_demo/models/ChatData.dart';
import 'package:flutter_amplify_demo/stores/state_keeper.dart';

class ChatStore extends StateKeeper {
  ChatStore._();
  static ChatStore _instance = ChatStore._();
  factory ChatStore() => _instance;

  List<Map<String, dynamic>> userChats = [];
  List<Chatdata> chatData = [];
  ChartRepository _chartRepository = ChartRepository();

  Future fetchUserChats() async {
    userChats = await _chartRepository.getUserChatList();
    notifyListeners();
  }

  Future fetchChatData(String chatId) async {
    chatData = await _chartRepository.getChatData(chatId: chatId);
    notifyListeners();
  }

  Future addChatData({
    @required String message,
    @required String chatId,
    @required String senderId,
  }) async {
    await _chartRepository.addChatData(
        message: message, chatId: chatId, senderId: senderId);
    notifyListeners();
  }

  Future deleteChats(List<String> messageIdList) async {
    await _chartRepository.deleteChats(messageIdList);
    notifyListeners();
  }

  Future updateChat(String messageId, String updatedMessage) async {
    await _chartRepository.updateChats(messageId, updatedMessage);
    notifyListeners();
  }

  Future addUserToChatList(Users otherUser) async {
    await _chartRepository.addUserToChatList(otherUser: otherUser);
  }

  Future<Chatdata> getMessage(String id) async {
    Chatdata messageData = (await Amplify.DataStore.query(Chatdata.classType,
        where: Chatdata.ID.eq(id)))[0];
    return messageData;
  }

  addUpdatedChats(Chatdata updatedChatData) {
    chatData.insert(0, updatedChatData);
    notifyListeners();
  }

  resetChatData() {
    chatData = [];
    notifyListeners();
  }
}
