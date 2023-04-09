import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stor_app/consts/consts.dart';
import 'package:stor_app/consts/lists.dart';
import 'package:stor_app/controllers/auth_controller.dart';
import 'package:stor_app/controllers/profile_controller.dart';
import 'package:stor_app/services/firestor_services.dart';
import 'package:stor_app/views/auth_screen/login_screen.dart';
import 'package:stor_app/views/chat_screen/messaging_screen.dart';
import 'package:stor_app/views/orders_screen/order_screen.dart';
import 'package:stor_app/views/profile_screen/components/edit_profile_screen.dart';
import 'package:stor_app/views/wishlist_screen/wishlist_screen.dart';
import 'package:stor_app/widget_common/bg_widget.dart';

import 'components/details_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());

    return bgWidget(
      child: Scaffold(
          body: StreamBuilder(
        stream: FirestorServices.getUser(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
          } else {
            var data = snapshot.data!.docs[0];
            return SafeArea(
                child: Column(
              children: [
                const Align(
                    alignment: Alignment.topRight,
                    child: Icon(
                      Icons.edit,
                      color: whiteColor,
                    )).onTap(() {
                  controller.nameController.text = data['name'];

                  Get.to((() => EditProfileScreen(
                        data: data,
                      )));
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      data['imageUrl'] == ''
                          ? Image.asset(
                              imgProfile2,
                              width: 70,
                              fit: BoxFit.cover,
                            ).box.roundedFull.clip(Clip.antiAlias).make()
                          : Image.network(
                              data['imageUrl'],
                              width: 50,
                              fit: BoxFit.cover,
                            ).box.roundedFull.clip(Clip.antiAlias).make(),
                      10.widthBox,
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          "${data['name']}"
                              .text
                              .fontFamily(semibold)
                              .wide
                              .size(18)
                              .make(),
                          "${data['email']}".text.white.size(14).make()
                        ],
                      )),
                      OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: whiteColor)),
                          onPressed: () async {
                            await Get.put(AuthController())
                                .singoutMethod(context);
                            Get.offAll(() => LoginScreen());
                          },
                          child: logout.text.fontFamily(semibold).white.make())
                    ],
                  ),
                ),
                20.heightBox,
                FutureBuilder(
                  future: FirestorServices.getCounts(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: loadingIndicator());
                    } else {
                      var countData = snapshot.data;
                      // print(snapshot.data);
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          detailsCard(
                              count: countData[0].toString(),
                              title: "in your cart",
                              width: context.screenWidth / 3.4),
                          detailsCard(
                              count: countData[1].toString(),
                              title: "in your wishlist",
                              width: context.screenWidth / 3.4),
                          detailsCard(
                              count: countData[2].toString(),
                              title: "your orders",
                              width: context.screenWidth / 3.4),
                        ],
                      );
                    }
                  },
                ),
                ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (context, index) {
                    return const Divider(
                      color: lightGrey,
                    );
                  },
                  itemCount: profileButtonsList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        switch (index) {
                          case 0:
                            Get.to(() => const OrderScreen());
                            break;
                          case 1:
                            Get.to(() => const wishlistScreen());
                            break;
                          case 2:
                            Get.to(() => const MessagesScreen());
                            break;
                        }
                      },
                      leading: Image.asset(
                        profileButtonsIcon[index],
                        width: 22,
                      ),
                      title: profileButtonsList[index]
                          .text
                          .fontFamily(semibold)
                          .color(darkFontGrey)
                          .make(),
                    );
                  },
                )
                    .box
                    .white
                    .rounded
                    .margin(const EdgeInsets.all(12))
                    .shadowSm
                    .padding(const EdgeInsets.symmetric(horizontal: 16))
                    .make()
                    .box
                    .color(redColor)
                    .make()
              ],
            ));
          }
        },
      )),
    );
  }
}
