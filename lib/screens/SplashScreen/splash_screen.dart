import 'package:flutter/material.dart';
import 'package:flutter_amplify_demo/components/primary_button.dart';
import 'package:flutter_amplify_demo/components/secondary_button.dart';
import 'package:flutter_amplify_demo/routes/routes_path.dart';
import 'package:flutter_amplify_demo/services/get_it_service.dart';
import 'package:flutter_amplify_demo/services/navigation_service.dart';
import 'package:flutter_amplify_demo/services/text_style.dart';
import 'package:flutter_amplify_demo/theme/colors.dart';
import 'package:flutter_amplify_demo/services/size_config.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  NavigationService _navigationService =
      get_it_instance_const<NavigationService>();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: bgColor,
      body: getBody(),
    );
  }

  Widget getBody() {
    return SingleChildScrollView(
      child: Container(
        width: SizeConfig.screenWidth,
        padding: EdgeInsets.only(
          top: 80.toHeight,
          bottom: 40.toHeight,
          left: 30.toWidth,
          right: 30.toWidth,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  width: 300.toWidth,
                  height: 300.toHeight,
                  child: Image.asset(
                    "assets/images/splash.png",
                    width: 500.toWidth,
                    height: 500.toHeight,
                  ),
                ),
                SizedBox(height: 20.toHeight),
                Text(
                  "A Whatsapp Clone.",
                  style: CustomTextStyle.loginTitleStyle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.toHeight),
              ],
            ),
            Column(
              children: [
                PrimaryButton(
                  text: "Sign In",
                  onPress: () {
                    _navigationService.popAllAndReplace(RoutePath.Login);
                  },
                ),
                SizedBox(height: 12.toHeight),
                SecondaryButton(
                  text: "Register",
                  onPress: () {
                    _navigationService.popAllAndReplace(RoutePath.Register);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
