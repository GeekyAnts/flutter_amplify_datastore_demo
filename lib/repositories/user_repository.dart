import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter_amplify_demo/models/Users.dart';
import 'package:meta/meta.dart';

class UserRepository {
  Users currUser;

  Future<bool> register({
    @required String email,
    @required String password,
    @required String name,
  }) async {
    try {
      Map<String, String> userAttributes = {'name': name};
      SignUpResult res = await Amplify.Auth.signUp(
        username: email,
        password: password,
        options: CognitoSignUpOptions(userAttributes: userAttributes),
      );
      return res.isSignUpComplete;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<bool> optVerfication({
    @required String email,
    @required String password,
    @required String otp,
    @required String name,
  }) async {
    SignUpResult res = await Amplify.Auth.confirmSignUp(
      username: email,
      confirmationCode: otp,
    );
    if (res.isSignUpComplete) {
      SignInResult signInRes = await Amplify.Auth.signIn(
        username: email,
        password: password,
      );
      AuthUser authUser = await Amplify.Auth.getCurrentUser();
      Amplify.DataStore.save(
        Users(
          email: email,
          username: name,
          bio: "",
          profileImage:
              "https://www.arrowbenefitsgroup.com/wp-content/uploads/2018/04/unisex-avatar.png",
          id: authUser.userId,
          createdAt: TemporalTimestamp.now(),
          isVerified: true,
        ),
      );
      return signInRes.isSignedIn;
    }
    return false;
  }

  Future logout() async {
    try {
      await Amplify.Auth.signOut();
    } on AuthException catch (_) {
      rethrow;
    }
  }

  Future<bool> login({
    @required String email,
    @required String password,
  }) async {
    SignInResult res = await Amplify.Auth.signIn(
      username: email,
      password: password,
    );
    return res.isSignedIn;
  }

  Future<bool> loginWithGoogle() async {
    try {
      var res =
          await Amplify.Auth.signInWithWebUI(provider: AuthProvider.google);
      List<AuthUserAttribute> authUserAttributes =
          await Amplify.Auth.fetchUserAttributes();
      String email = authUserAttributes[3].value;
      String userId = authUserAttributes[0].value;
      List<Users> user = await Amplify.DataStore.query(Users.classType,
          where: Users.ID.eq(userId));
      if (user.length > 0) {
        return res.isSignedIn;
      } else {
        Amplify.DataStore.save(
          Users(
            email: email,
            username: "",
            bio: "",
            profileImage:
                "https://www.arrowbenefitsgroup.com/wp-content/uploads/2018/04/unisex-avatar.png",
            id: userId,
            createdAt: TemporalTimestamp.now(),
            isVerified: true,
          ),
        );
        return res.isSignedIn;
      }
    } on AmplifyException catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> checkUsername() async {
    try {
      Users user = await getCurrUser();
      if (user == null) return false;
      if (user.username == "")
        return false;
      else
        return true;
    } on AmplifyException catch (e) {
      print(e);
      return false;
    }
  }

  Future<Users> getCurrUser() async {
    AuthUser authUser = await Amplify.Auth.getCurrentUser();
    List<Users> user = await Amplify.DataStore.query(Users.classType,
        where: Users.ID.eq(authUser.userId));
    if (user.length > 0) {
      print(user.first);
      return user.first;
    } else
      return null;
  }

  Future<List<Users>> getAllOtherUses() async {
    AuthUser authUser = await Amplify.Auth.getCurrentUser();
    List<Users> users = await Amplify.DataStore.query(Users.classType,
        where: Users.ID.ne(authUser.userId));
    return users;
  }

  Future updateFullname(String name) async {
    AuthUser authUser = await Amplify.Auth.getCurrentUser();
    Users user = (await Amplify.DataStore.query(
      Users.classType,
      where: Users.ID.eq(authUser.userId),
    ))[0];
    await Amplify.DataStore.save(user.copyWith(username: name));
  }

  // Future updateProfileImage(File image, String key) async {
  //   try {
  //     await Amplify.Storage.downloadFile(
  //       key: key,
  //       local: image,
  //     );
  //     GetUrlResult getUrlResult = await Amplify.Storage.getUrl(key: key);
  //     await Amplify.DataStore.save(
  //       UserStore().currUser.copyWith(profileImage: getUrlResult.url),
  //     );
  //   } on StorageException catch (e) {
  //     print(e.message);
  //   }
  // }
}
