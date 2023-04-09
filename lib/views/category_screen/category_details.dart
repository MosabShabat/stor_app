import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:stor_app/consts/consts.dart';
import 'package:stor_app/services/firestor_services.dart';
import 'package:stor_app/widget_common/bg_widget.dart';

import '../../controllers/product_controller.dart';
import 'item_details.dart';

class CategoryDetails extends StatefulWidget {
  final String? title;
  const CategoryDetails({super.key, this.title});

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  var controller = Get.find<ProductController>();

  dynamic productMethod;

  @override
  void initState() {
    switchCategory(widget.title);
    super.initState();
  }

  switchCategory(title) {
    if (controller.subcat.contains(title)) {
      productMethod = FirestorServices.getSubCategoryProducts(title);
    } else {
      productMethod = FirestorServices.getProducts(title);
    }
  }

  @override
  Widget build(BuildContext context) {
    return bgWidget(
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: widget.title!.text.fontFamily(bold).white.make(),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                        controller.subcat.length,
                        (index) => "${controller.subcat[index]}"
                                .text
                                .size(12)
                                .fontFamily(semibold)
                                .color(darkFontGrey)
                                .makeCentered()
                                .box
                                .white
                                .size(120, 50)
                                .margin(
                                    const EdgeInsets.symmetric(horizontal: 4))
                                .rounded
                                .make()
                                .onTap(() {
                              switchCategory("${controller.subcat[index]}");
                              setState(() {});
                            })),
                  ),
                ),
                20.heightBox,
                StreamBuilder(
                  stream: productMethod,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Expanded(
                        child: Center(
                          child: loadingIndicator(),
                        ),
                      );
                    } else if (snapshot.data!.docs.isEmpty) {
                      return Expanded(
                        child: "No products found!"
                            .text
                            .color(darkFontGrey)
                            .makeCentered(),
                      );
                    } else {
                      var data = snapshot.data!.docs;
                      return Expanded(
                          child: GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 250,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                data[index]['p_imgs'][0],
                                width: 200,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                              10.heightBox,
                              "${data[index]['p_name']}"
                                  .text
                                  .fontFamily(semibold)
                                  .color(darkFontGrey)
                                  .make(),
                              10.heightBox,
                              "${data[index]['p_price']}"
                                  .numCurrency
                                  .text
                                  .fontFamily(bold)
                                  .color(redColor)
                                  .size(16)
                                  .make(),
                            ],
                          )
                              .box
                              .white
                              .roundedSM
                              .outerShadowSm
                              .margin(const EdgeInsets.symmetric(horizontal: 4))
                              .padding(const EdgeInsets.all(12))
                              .make()
                              .onTap(() {
                            controller.checkIfFav(data[index]);
                            Get.to(() => ItemDetails(
                                  title: "${data[index]['p_name']}",
                                  data: data[index],
                                ));
                          });
                        },
                      ));
                    }
                  },
                ),
              ],
            )));
  }
}
