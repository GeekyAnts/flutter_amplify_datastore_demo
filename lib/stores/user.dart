import 'package:flutter_amplify_demo/repositories/user_repository.dart';
import 'package:flutter_amplify_demo/models/Users.dart';
import 'package:flutter_amplify_demo/stores/state_keeper.dart';
import 'dart:io';

class UserStore extends StateKeeper {
  UserStore._();
  static UserStore _instance = UserStore._();
  factory UserStore() => _instance;

  static const String CURR_USER = 'curr_user';

  UserRepository _userRepository = UserRepository();

  Users currUser;
  List<Users> allOtherUsers;

  Future fetchCurrentUser() async {
    currUser = await _userRepository.getCurrUser();
    notifyListeners();
  }

  Future fetchAllOtherUsers() async {
    allOtherUsers = await _userRepository.getAllOtherUses();
    notifyListeners();
  }

  // Future updateProfileImage({File image, String key}) async {
  //   await _userRepository.updateProfileImage(image, key);
  // }
}
