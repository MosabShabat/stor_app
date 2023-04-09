import 'package:get/get.dart';
import 'package:stor_app/consts/consts.dart';
import 'package:stor_app/consts/lists.dart';
import 'package:stor_app/controllers/cart_controller.dart';
import 'package:stor_app/views/home_screen/home_page.dart';
import 'package:stor_app/widget_common/bg_widget.dart';

import '../../widget_common/our_button.dart';
import '../home_screen/home_screen.dart';

class PaymentMethods extends StatelessWidget {
  const PaymentMethods({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();

    return Obx(
      () => Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          title: "Choose Payment Method"
              .text
              .color(darkFontGrey)
              .fontFamily(semibold)
              .make(),
        ),
        bottomNavigationBar: SizedBox(
          height: 60,
          child: controller.placingOrder.value
              ? Center(
                  child: loadingIndicator(),
                )
              : OurButton(
                  color: redColor,
                  onPress: () async {
                    await controller.placeMyorder(
                        orderPaymentMethod:
                            paymentMethods[controller.paymentIndex.value],
                        totalAmount: controller.totalP.value);

                    await controller.clearCart();
                    // VxToast.show(context, msg: "Order placed successfully");
                    Get.offAll(() => const HomeScreen());
                  },
                  textColor: whiteColor,
                  title: "Place my order"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Obx(
            () => Column(
              children: List.generate(paymentMethodsImg.length, (index) {
                return GestureDetector(
                  onTap: () {
                    controller.changePaymentIndex(index);
                  },
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: controller.paymentIndex.value == index
                              ? redColor
                              : Colors.transparent,
                          width: 4,
                        )),
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Stack(alignment: Alignment.topRight, children: [
                      Image.asset(
                        paymentMethodsImg[index],
                        width: double.infinity,
                        height: 100,
                        colorBlendMode: controller.paymentIndex.value == index
                            ? BlendMode.darken
                            : BlendMode.color,
                        color: controller.paymentIndex.value == index
                            ? Colors.black.withOpacity(0.4)
                            : Colors.transparent,
                        fit: BoxFit.cover,
                      ),
                      controller.paymentIndex.value == index
                          ? Transform.scale(
                              scale: 1.3,
                              child: Checkbox(
                                activeColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)),
                                value: true,
                                onChanged: (value) {},
                              ),
                            )
                          : Container(),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: paymentMethods[index]
                            .text
                            .white
                            .fontFamily(bold)
                            .size(16)
                            .make(),
                      )
                    ]),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
