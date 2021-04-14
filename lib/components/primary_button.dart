import 'package:flutter/material.dart';
import 'package:flutter_amplify_demo/services/size_config.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final Function onPress;
  const PrimaryButton({
    Key key,
    this.text,
    this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      height: 50.toHeight,
      child: TextButton(
        onPressed: onPress,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 20.toFont,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0.toWidth),
            ),
          ),
        ),
      ),
    );
  }
}
