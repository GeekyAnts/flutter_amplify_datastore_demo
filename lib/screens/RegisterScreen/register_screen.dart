import 'package:flutter/material.dart';
import 'package:flutter_amplify_demo/components/login_text_field.dart';
import 'package:flutter_amplify_demo/components/primary_button.dart';
import 'package:flutter_amplify_demo/components/secondary_button.dart';
import 'package:flutter_amplify_demo/components/show_snackbar.dart';
import 'package:flutter_amplify_demo/routes/routes_path.dart';
import 'package:flutter_amplify_demo/services/get_it_service.dart';
import 'package:flutter_amplify_demo/services/navigation_service.dart';
import 'package:flutter_amplify_demo/services/text_style.dart';
import 'package:flutter_amplify_demo/services/validations.dart';
import 'package:flutter_amplify_demo/stores/auth.dart';
import 'package:flutter_amplify_demo/stores/state_keeper.dart';
import 'package:flutter_amplify_demo/theme/colors.dart';
import 'package:flutter_amplify_demo/services/size_config.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

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
                  style: CustomTextStyle.loginTitleStyle
                      .copyWith(fontSize: 36.toFont),
                ),
                SizedBox(height: 10.toHeight),
                Text(
                  "Welcome aboard!",
                  style: CustomTextStyle.loginTitleSecondaryStyle,
                ),
                buildEmailSignUpForm(),
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

  Form buildEmailSignUpForm() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          SizedBox(height: 45.toHeight),
          CustomLoginTextField(
            hintTextL: "Full Name",
            ctrl: nameCtrl,
            validation: Validations.validateFullName,
            type: TextInputType.text,
          ),
          SizedBox(height: 12.toHeight),
          CustomLoginTextField(
            hintTextL: "Email",
            ctrl: emailCtrl,
            validation: Validations.validateEmail,
            type: TextInputType.emailAddress,
          ),
          SizedBox(height: 12.toHeight),
          CustomLoginTextField(
            hintTextL: "Password",
            ctrl: passwordCtrl,
            validation: Validations.valdiatePassword,
            obscureText: true,
          ),
          SizedBox(height: 24.toHeight),
          Consumer<AuthStore>(builder: (_, authStore, __) {
            if (authStore.status[AuthStore.LOGIN_USER] == Status.Error) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showSnackBar(
                  context,
                  authStore.error[AuthStore.LOGIN_USER],
                );
                authStore.reset(AuthStore.LOGIN_USER);
              });
            }
            if (authStore.status[AuthStore.LOGIN_USER] == Status.Loading) {
              return CircularProgressIndicator();
            }
            return PrimaryButton(
              text: "Register",
              onPress: () async {
                if (!formKey.currentState.validate()) return;
                bool isSignupComplete = await authStore.signUpWithEmailPassword(
                  name: nameCtrl.text,
                  email: emailCtrl.text,
                  password: passwordCtrl.text,
                );
                if (isSignupComplete)
                  _navigationService.navigateTo(
                    RoutePath.Otp,
                    arguments: {
                      "email": emailCtrl.text,
                      "password": passwordCtrl.text,
                      "name": nameCtrl.text,
                    },
                  );
              },
            );
          })
        ],
      ),
    );
  }
}
