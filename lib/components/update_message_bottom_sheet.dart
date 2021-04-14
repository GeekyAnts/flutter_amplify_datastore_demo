import 'package:flutter/material.dart';
import 'package:flutter_amplify_demo/components/textarea.dart';
import 'package:flutter_amplify_demo/components/primary_button.dart';
import 'package:flutter_amplify_demo/models/ChatData.dart';
import 'package:flutter_amplify_demo/services/get_it_service.dart';
import 'package:flutter_amplify_demo/services/navigation_service.dart';
import 'package:flutter_amplify_demo/services/size_config.dart';
import 'package:flutter_amplify_demo/services/text_style.dart';
import 'package:flutter_amplify_demo/theme/colors.dart';

updateMessageBottomSheet(
  context,
  Chatdata chatData,
  Function updateMessage,
  Function closeSelectionModel,
) {
  TextEditingController messageCtrl =
      TextEditingController(text: chatData.message);

  NavigationService _navigationService =
      get_it_instance_const<NavigationService>();
  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: bgColor,
      builder: (context) {
        return Container(
          height: 300.toHeight,
          width: SizeConfig.screenWidth,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 3),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Update message",
                  style: CustomTextStyle.loginTitleStyle.copyWith(
                    fontSize: 23.toFont,
                  ),
                ),
                SizedBox(height: 24.toHeight),
                TextArea(ctrl: messageCtrl),
                SizedBox(height: 24.toHeight),
                PrimaryButton(
                  text: "Continue",
                  onPress: () async {
                    if (messageCtrl.text == "") return;
                    await updateMessage(chatData.id, messageCtrl.text);
                    closeSelectionModel();
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                    // await UserRepository().updateFullname(messageCtrl.text);
                    // _navigationService.popAllAndReplace(RoutePath.Home);
                  },
                ),
              ],
            ),
          ),
        );
      });
}
