import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stor_app/consts/consts.dart';
import 'package:stor_app/consts/lists.dart';
import 'package:stor_app/controllers/product_controller.dart';

import '../../widget_common/bg_widget.dart';
import 'category_details.dart';

class GategoryScreen extends StatefulWidget {
  const GategoryScreen({super.key});

  @override
  State<GategoryScreen> createState() => _GategoryScreenState();
}

class _GategoryScreenState extends State<GategoryScreen> {
  var controller = Get.put(ProductController());
  @override
  Widget build(BuildContext context) {
    return bgWidget(
        child: Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: categories.text.fontFamily(bold).wide.make(),
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: 9,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisExtent: 180,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            return Column(
              children: [
                Image.asset(
                  categoriesImages[index],
                  width: 200,
                  height: 120,
                  fit: BoxFit.cover,
                ),
                10.heightBox,
                categoriesList[index]
                    .text
                    .color(darkFontGrey)
                    .align(TextAlign.center)
                    .make()
              ],
            )
                .box
                .white
                .rounded
                .clip(Clip.antiAlias)
                .outerShadowSm
                .make()
                .onTap(() {
              controller.getSubCategories(categoriesList[index]);
              Get.to(() => CategoryDetails(
                    title: categoriesList[index],
                  ));
            });
          },
        ),
      ),
    ));
  }
}
