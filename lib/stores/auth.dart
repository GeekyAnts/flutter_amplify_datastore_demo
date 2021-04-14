import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_demo/repositories/user_repository.dart';
import 'package:flutter_amplify_demo/stores/state_keeper.dart';
import 'package:flutter_amplify_demo/stores/user.dart';

class AuthStore extends StateKeeper {
  AuthStore._();
  static AuthStore _instance = AuthStore._();
  factory AuthStore() {
    return _instance;
  }

  static const String LOGIN_USER = 'login_user';
  static const String LOGIN_GOOGLE_USER = 'login_gooogle_user';
  static const String SIGNUP_USER = 'signup_user';

  bool isAuthenticated;

  UserRepository _userRepository = UserRepository();

  Future isSignedIn() async {
    AuthSession authSessions = await Amplify.Auth.fetchAuthSession();
    isAuthenticated = authSessions.isSignedIn;
    notifyListeners();
  }

  Future<bool> loginWithGoogle() async {
    try {
      setStatus(LOGIN_GOOGLE_USER, Status.Loading);
      bool isSignedIn = await _userRepository.loginWithGoogle();
      if (isSignedIn == false) setStatus(LOGIN_GOOGLE_USER, Status.Idle);
      if (isSignedIn) {
        await UserStore().fetchCurrentUser();
        await UserStore().fetchAllOtherUsers();
        setStatus(LOGIN_GOOGLE_USER, Status.Done);
        return true;
      }
      setStatus(LOGIN_GOOGLE_USER, Status.Done);
      return false;
    } on UserCancelledException catch (_) {
      setError(LOGIN_GOOGLE_USER, "Google authentication cancelled by user.");
      return false;
    } catch (e) {
      print("ERROR");
      setError(LOGIN_GOOGLE_USER, e.toString());
      return false;
    }
  }

  Future<bool> loginWithEmailPassword({
    @required String email,
    @required String password,
  }) async {
    try {
      setStatus(LOGIN_USER, Status.Loading);
      bool isSignInComplete = await UserRepository().login(
        email: email,
        password: password,
      );
      if (isSignInComplete) {
        await UserStore().fetchCurrentUser();
        await UserStore().fetchAllOtherUsers();
        return true;
      }
      return false;
    } on UserNotFoundException catch (_) {
      setError(LOGIN_USER, "Email or Password incorrect");
      return false;
    } catch (e) {
      setError(LOGIN_USER, e.toString());
      return false;
    }
  }

  Future<bool> signUpWithEmailPassword({
    @required name,
    @required email,
    @required password,
  }) async {
    try {
      setStatus(SIGNUP_USER, Status.Loading);
      bool isSignupComplete = await _userRepository.register(
        email: email,
        password: password,
        name: name,
      );

      if (!isSignupComplete)
        setError(SIGNUP_USER, "Error Occured please try gain.");
      return isSignupComplete;
    } catch (e) {
      print(e);
      setError(SIGNUP_USER, "Error Occured please try gain.");
      return false;
    }
  }

  Future<bool> checkUsername() async {
    bool hasUsername = await _userRepository.checkUsername();
    return hasUsername;
  }

  Future<bool> optVerification({
    String email,
    String name,
    String otp,
    String password,
  }) async {
    bool isVerified = await _userRepository.optVerfication(
      email: email,
      name: name,
      otp: otp,
      password: password,
    );
    if (isVerified) {
      await UserStore().fetchCurrentUser();
      await UserStore().fetchAllOtherUsers();
    }
    return isVerified;
  }

  Future logout() async {
    await _userRepository.logout();
    notifyListeners();
  }
}
