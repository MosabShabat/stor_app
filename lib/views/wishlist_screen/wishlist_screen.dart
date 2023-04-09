import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:stor_app/consts/consts.dart';
import 'package:stor_app/services/firestor_services.dart';

import '../../widget_common/bg_widget.dart';

class wishlistScreen extends StatelessWidget {
  const wishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title:
            "My Wishlist".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
        stream: FirestorServices.getWishlist(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: loadingIndicator());
          } else if (snapshot.data!.docs.isEmpty) {
            print(snapshot.data);
            return Center(
              child: "No Wishlist yet!".text.color(darkFontGrey).make(),
            );
          } else {
            var data = snapshot.data!.docs;
            return Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: Image.network(
                      "${data[index]['p_imgs'][0]}",
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                    title: "${data[index]['p_name']}"
                        .text
                        .fontFamily(semibold)
                        .size(16)
                        .make(),
                    subtitle: "${data[index]['p_price']}"
                        .numCurrency
                        .text
                        .color(redColor)
                        .fontFamily(semibold)
                        .make(),
                    trailing: const Icon(
                      Icons.favorite,
                      color: redColor,
                    ).onTap(() async {
                      await firestore
                          .collection(productsCollection)
                          .doc(data[index].id)
                          .set({
                        'p_wishlist': FieldValue.arrayRemove([currentUser!.uid])
                      }, SetOptions(merge: true));
                    }),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
