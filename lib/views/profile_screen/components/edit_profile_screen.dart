import 'dart:io';
import 'package:get/get.dart';
import 'package:stor_app/consts/consts.dart';
import 'package:stor_app/controllers/profile_controller.dart';
import 'package:stor_app/widget_common/bg_widget.dart';
import 'package:stor_app/widget_common/custom_textfild.dart';
import 'package:stor_app/widget_common/our_button.dart';

class EditProfileScreen extends StatelessWidget {
  final dynamic data;
  const EditProfileScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProfileController>();

    return bgWidget(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            data['imageUrl'] == '' && controller.profileImgPath.isEmpty
                ? Image.asset(
                    imgProfile2,
                    width: 100,
                    fit: BoxFit.cover,
                  ).box.roundedFull.clip(Clip.antiAlias).make()
                : data['imageUrl'] != '' && controller.profileImgPath.isEmpty
                    ? Image.network(
                        data['imageUrl'],
                        width: 70,
                        fit: BoxFit.cover,
                      ).box.roundedFull.clip(Clip.antiAlias).make()
                    : Image.file(
                        File(controller.profileImgPath.value),
                        width: 70,
                        fit: BoxFit.cover,
                      ).box.roundedFull.clip(Clip.antiAlias).make(),
            10.heightBox,
            OurButton(
                color: redColor,
                onPress: () {
                  controller.changeImage(context);
                },
                textColor: whiteColor,
                title: "Change"),
            Divider(),
            20.heightBox,
            customTextField(
                controller: controller.nameController,
                hint: nameHint,
                title: name,
                isPass: false),
            10.heightBox,
            customTextField(
                controller: controller.oldpasswordController,
                hint: passwordHint,
                title: oldpass,
                isPass: true),
            10.heightBox,
            customTextField(
                controller: controller.newpasswordController,
                hint: passwordHint,
                title: newpass,
                isPass: true),
            20.heightBox,
            controller.isloading.value
                ? loadingIndicator()
                : SizedBox(
                    width: context.screenWidth - 60,
                    child: OurButton(
                        color: redColor,
                        onPress: () async {
                          controller.isloading(true);
                          if (controller.profileImgPath.value.isNotEmpty) {
                            await controller.uploadProfileImage();
                          } else {
                            controller.profileImageLink = data['imageUrl'];
                          }
                          if (data['password'] ==
                              controller.oldpasswordController.text) {
                            await controller.changeAuthPassword(
                                email: data['email'],
                                password: controller.oldpasswordController.text,
                                newpassword:
                                    controller.newpasswordController.text);
                            await controller.updateProfile(
                                imgUrl: controller.profileImageLink,
                                name: controller.nameController.text,
                                password:
                                    controller.newpasswordController.text);
                            VxToast.show(context, msg: "Update");
                          } else {
                            VxToast.show(context, msg: "Wrong old passowrd");
                            controller.isloading(false);
                          }
                        },
                        textColor: whiteColor,
                        title: "Save"),
                  ),
          ],
        )
            .box
            .white
            .shadowSm
            .padding(const EdgeInsets.all(16))
            .margin(const EdgeInsets.only(top: 50, left: 12, right: 12))
            .rounded
            .make(),
      ),
    ));
  }
}
