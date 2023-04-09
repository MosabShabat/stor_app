import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:stor_app/consts/consts.dart';
import 'package:stor_app/widget_common/our_button.dart';

Widget exitDialog() {
  return Dialog(
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      "Condirm".text.fontFamily(bold).size(18).color(darkFontGrey).make(),
      const Divider(),
      10.heightBox,
      "Are you sure you want to exit?".text.size(16).color(darkFontGrey).make(),
      10.heightBox,
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          OurButton(
              color: redColor,
              onPress: () {
                SystemNavigator.pop();
              },
              textColor: whiteColor,
              title: "Yes"),
          OurButton(
              color: redColor,
              onPress: () {
                Get.back();
              },
              textColor: whiteColor,
              title: "No"),
        ],
      )
    ]).box.color(lightGrey).padding(const EdgeInsets.all(12)).roundedSM.make(),
  );
}
