import 'package:get/get.dart';
import 'package:stor_app/consts/consts.dart';
import 'package:stor_app/controllers/cart_controller.dart';
import 'package:stor_app/views/cart_screen/payment_method.dart';
import 'package:stor_app/widget_common/custom_textfild.dart';
import 'package:flutter/material.dart';

import '../../widget_common/our_button.dart';

class ShippingDetails extends StatelessWidget {
  const ShippingDetails({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "Shipping Info"
            .text
            .color(darkFontGrey)
            .fontFamily(semibold)
            .make(),
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: OurButton(
            color: redColor,
            onPress: () {
              if (controller.addressController.text.length > 10) {
                Get.to(() => const PaymentMethods());
              } else {
                VxToast.show(context, msg: "Please fill the form");
              }
            },
            textColor: whiteColor,
            title: "Continue"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            customTextField(
                hint: "Address",
                isPass: false,
                title: "Address",
                controller: controller.addressController),
            customTextField(
                hint: "City",
                isPass: false,
                title: "City",
                controller: controller.cityController),
            customTextField(
                hint: "State",
                isPass: false,
                title: "State",
                controller: controller.stateController),
            customTextField(
                hint: "Postal Code",
                isPass: false,
                title: "Postal Code",
                controller: controller.postalcodeController),
            customTextField(
                hint: "Phone",
                isPass: false,
                title: "Phone",
                controller: controller.phoneController),
          ],
        ),
      ),
    );
  }
}
