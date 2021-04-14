import 'package:flutter/material.dart';
import 'package:flutter_amplify_demo/repositories/user_repository.dart';
import 'package:flutter_amplify_demo/components/login_text_field.dart';
import 'package:flutter_amplify_demo/components/primary_button.dart';
import 'package:flutter_amplify_demo/routes/routes_path.dart';
import 'package:flutter_amplify_demo/services/get_it_service.dart';
import 'package:flutter_amplify_demo/services/navigation_service.dart';
import 'package:flutter_amplify_demo/services/size_config.dart';
import 'package:flutter_amplify_demo/services/text_style.dart';
import 'package:flutter_amplify_demo/services/validations.dart';
import 'package:flutter_amplify_demo/stores/user.dart';
import 'package:flutter_amplify_demo/theme/colors.dart';

getNameBottomSheet(context) {
  TextEditingController nameCtrl = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  NavigationService _navigationService =
      get_it_instance_const<NavigationService>();
  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: bgColor,
      builder: (context) {
        return Container(
          height: 400,
          width: SizeConfig.screenWidth,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 3),
          ),
          child: Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: Column(
                children: [
                  Text(
                    "What should we call you?",
                    style: CustomTextStyle.loginTitleStyle,
                  ),
                  SizedBox(height: 24.toHeight),
                  CustomLoginTextField(
                    hintTextL: "Full Name",
                    ctrl: nameCtrl,
                    validation: Validations.validateFullName,
                    type: TextInputType.text,
                  ),
                  SizedBox(height: 24.toHeight),
                  PrimaryButton(
                    text: "Continue",
                    onPress: () async {
                      if (!formKey.currentState.validate()) return;
                      await UserRepository().updateFullname(nameCtrl.text);
                      await UserStore().fetchCurrentUser();
                      await UserStore().fetchAllOtherUsers();
                      _navigationService.popAllAndReplace(RoutePath.Home);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      });
}
