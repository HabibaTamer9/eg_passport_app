import 'package:eg_passport_app/theme/my_theme_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  String textName;
  CustomButton({required this.textName});
   static const String routeName="CustomButton";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton.icon
              (onPressed: (){},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.red, width: 0.5),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                backgroundColor: Colors.red,
                ),
                iconAlignment: IconAlignment.end,
                icon: Icon(Icons.login),
                label: Text(textName,
                  style: MyThemeApp.lightTheme.textTheme.bodyMedium,
                   )
                ),
          ),
        ),
      ),

    );
  }
}
