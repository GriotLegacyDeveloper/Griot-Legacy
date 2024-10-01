import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:griot_legacy_social_media_app/formated_date_time.dart';
import 'package:griot_legacy_social_media_app/src/controllers/post_controller.dart';
import 'package:griot_legacy_social_media_app/src/models/home_data_model.dart';
import 'package:griot_legacy_social_media_app/src/screens/post_details_page.dart';
import 'package:griot_legacy_social_media_app/src/utils/constant_class.dart';


List<BoxShadow> shadowList = [
  BoxShadow(color: Colors.grey[300], blurRadius: 30, offset: const Offset(0, 10))
];

class PostItemWidget extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final DashboardData post;
  final int index;
  const PostItemWidget({Key key, @required this.post,@required this.index}) : super(key: key);

  Widget pieceBuilder(PostController con) {
   // bool isSkelton = true;
   // print("post.file!=" "...... ${post.file}");
   // final hp = con.hp;
    return Container(
       // tag: "post.album$index",
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            post.type=="IMAGE"?
            Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      //margin: EdgeInsets.only(bottom: hp.width / 50),
                      //  padding: EdgeInsets.only(left: 8, top: 8, right: 8),
                      width: 130,
                      height: 180,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),

                      ),
                       child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: CachedNetworkImage(
                    imageUrl: /*Constant.SERVER_URL +*/post.file,
                    fit: BoxFit.cover,
                    placeholder: (BuildContext context,url){
                      return const Image(image: AssetImage('assets/images/noimage.png'));
                    },
                  ),
                ),
                    ),
                  ):
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(

                width: 130,
                height: 180,
                decoration: BoxDecoration(

                  borderRadius: BorderRadius.circular(8.0),

                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: CachedNetworkImage(
                    imageUrl: /*Constant.SERVER_URL +*/ post.thumb,
                    fit: BoxFit.cover,
                    placeholder: (BuildContext context,url){
                      return const Image(image:
                      AssetImage('assets/images/videoplaceholder.png'),
                      );
                    },
                  ),
                  /*FadeInImage.assetNetwork(
                      fit: BoxFit.cover,
                      placeholder: 'assets/images/noimage.png',
                      image:
                      "https://nodeserver.mydevfactory.com:2109/img/post/" +
                          post.thumb),*/
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Text(FormatedDateTime.formatedDateTimeTo(post.createdAt),
                      style: const TextStyle(
                          color: Colors.white, fontSize: 11)),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                      // margin: EdgeInsets.only(bottom: hp.width / 50),
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(
                                  "assets/images/timer.png")))),
                  Text(FormatedDateTime.formatedTime(post.createdAt),
                      style: const TextStyle(
                          fontSize: 11, color: Colors.grey)),
                ], //mainAxisAlignment: MainAxisAlignment.spaceBetween
              ),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // timeDilation = 2.0;
    return GetBuilder<PostController>(
        builder: pieceBuilder,
        init: PostController(
            context,
            context
                .findAncestorStateOfType<GetBuilderState<PostController>>()));
  }
}
