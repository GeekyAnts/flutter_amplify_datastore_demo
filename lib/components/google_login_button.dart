import 'package:flutter/material.dart';
import 'package:flutter_amplify_demo/components/get_name_bottom_sheet.dart';
import 'package:flutter_amplify_demo/components/primary_button.dart';
import 'package:flutter_amplify_demo/components/secondary_button.dart';
import 'package:flutter_amplify_demo/components/show_snackbar.dart';
import 'package:flutter_amplify_demo/routes/routes_path.dart';
import 'package:flutter_amplify_demo/services/get_it_service.dart';
import 'package:flutter_amplify_demo/services/navigation_service.dart';
import 'package:flutter_amplify_demo/stores/auth.dart';
import 'package:flutter_amplify_demo/stores/state_keeper.dart';
import 'package:provider/provider.dart';

class GoogleButton extends StatefulWidget {
  final bool isPrimaryButton;
  GoogleButton({Key key, this.isPrimaryButton}) : super(key: key);

  @override
  _GoogleButtonState createState() => _GoogleButtonState();
}

class _GoogleButtonState extends State<GoogleButton> {
  NavigationService _navigationService =
      get_it_instance_const<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthStore>(builder: (_, authStore, __) {
      if (authStore.status[AuthStore.LOGIN_GOOGLE_USER] == Status.Error) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showSnackBar(
            context,
            authStore.error[AuthStore.LOGIN_GOOGLE_USER],
          );
          authStore.reset(AuthStore.LOGIN_GOOGLE_USER);
        });
      }
      if (authStore.status[AuthStore.LOGIN_GOOGLE_USER] == Status.Loading) {
        return CircularProgressIndicator();
      }
      return widget.isPrimaryButton
          ? PrimaryButton(
              text: "Continue with Google",
              onPress: () async {
                bool isSignedIn = await authStore.loginWithGoogle();
                if (isSignedIn) {
                  bool hasUsername = await authStore.checkUsername();
                  if (!hasUsername)
                    getNameBottomSheet(context);
                  else
                    _navigationService.popAllAndReplace(RoutePath.Home);
                }
              },
            )
          : SecondaryButton(
              text: "Continue with Google",
              onPress: () async {
                bool isSignedIn = await authStore.loginWithGoogle();
                if (isSignedIn) {
                  bool hasUsername = await authStore.checkUsername();
                  if (!hasUsername)
                    getNameBottomSheet(context);
                  else
                    _navigationService.popAllAndReplace(RoutePath.Home);
                }
              },
            );
    });
  }
}
