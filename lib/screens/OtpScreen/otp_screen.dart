import 'package:flutter/material.dart';
import 'package:flutter_amplify_demo/components/login_text_field.dart';
import 'package:flutter_amplify_demo/components/primary_button.dart';
import 'package:flutter_amplify_demo/components/secondary_button.dart';
import 'package:flutter_amplify_demo/routes/routes_path.dart';
import 'package:flutter_amplify_demo/services/get_it_service.dart';
import 'package:flutter_amplify_demo/services/navigation_service.dart';
import 'package:flutter_amplify_demo/services/text_style.dart';
import 'package:flutter_amplify_demo/services/validations.dart';
import 'package:flutter_amplify_demo/stores/auth.dart';
import 'package:flutter_amplify_demo/theme/colors.dart';
import 'package:flutter_amplify_demo/services/size_config.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  final String password;
  final String name;

  const OtpScreen({
    Key key,
    this.email,
    this.password,
    @required this.name,
  }) : super(key: key);
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otpCtrl = TextEditingController();

  bool showOtpScreen = false;

  @override
  void initState() {
    super.initState();
  }

  NavigationService _navigationService =
      get_it_instance_const<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: getBody(),
    );
  }

  Widget getBody() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 80, horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(height: 80.toHeight),
                Text(
                  "A WhatsApp Clone.",
                  style: CustomTextStyle.loginTitleStyle.copyWith(fontSize: 36),
                ),
                SizedBox(height: 10.toHeight),
                Text(
                  "Welcome aboard!",
                  style: CustomTextStyle.loginTitleSecondaryStyle,
                ),
                buildOtpForm(),
                SizedBox(height: 24.toHeight),
              ],
            ),
            Column(
              children: [
                SizedBox(height: 16.toHeight),
                SecondaryButton(
                  text: "Sign In",
                  onPress: () {
                    _navigationService.popAllAndReplace(RoutePath.Login);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Column buildOtpForm() {
    return Column(
      children: [
        SizedBox(height: 45.toHeight),
        CustomLoginTextField(
          hintTextL: "Enter OTP Send to your Email",
          ctrl: otpCtrl,
          validation: Validations.validateOTP,
          maxLength: 6,
          type: TextInputType.number,
        ),
        SizedBox(height: 24.toHeight),
        Consumer<AuthStore>(builder: (_, authStore, __) {
          return PrimaryButton(
            text: "Continue",
            onPress: () async {
              try {
                bool isVerified = await authStore.optVerification(
                  email: widget.email,
                  otp: otpCtrl.text,
                  password: widget.password,
                  name: widget.name,
                );
                if (isVerified)
                  _navigationService.popAllAndReplace(RoutePath.Home);
              } catch (e) {
                print(e);
              }
            },
          );
        }),
      ],
    );
  }
}
