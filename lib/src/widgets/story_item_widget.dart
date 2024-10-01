import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:griot_legacy_social_media_app/src/controllers/post_controller.dart';
import 'package:griot_legacy_social_media_app/src/models/home_data_model.dart';
import 'package:griot_legacy_social_media_app/src/utils/constant_class.dart';

class StoryItemWidget extends StatelessWidget {
  final Trending trendingData;
  const StoryItemWidget({Key key, this.trendingData}) : super(key: key);

  Widget itemBuilder(PostController con) {
    final hp = con.hp;
    return Stack(
      clipBehavior: Clip.hardEdge, children:
    [
        trendingData.post.type=="IMAGE"?
        Container(

            margin: EdgeInsets.symmetric(horizontal: hp.width / 40),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child:  CachedNetworkImage(
                imageUrl: trendingData.post.file,
                fit: BoxFit.cover,
                placeholder: (BuildContext context,url){
                  return const Image(image: AssetImage('assets/images/noimage.png'));
                },
              ),
            ),

            height: hp.height / 10,
            width: hp.width / 5):
        Container(
            margin: EdgeInsets.symmetric(horizontal: hp.width / 40),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: CachedNetworkImage(
                imageUrl: trendingData.post.thumb,
                fit: BoxFit.cover,
                placeholder: (BuildContext context,url){
                  return const Image(image: AssetImage('assets/images/noimage.png'));
                },
              ),
              /*FadeInImage.assetNetwork(
                  fit: BoxFit.cover,
                  placeholder: 'assets/images/noimage.png',
                  image: "https://nodeserver.mydevfactory.com:2109/img/post/" +
                      trendingData.post.thumb),*/
            ),
            // decoration: BoxDecoration(
            //   color: Colors.black.withOpacity(0.5),
            //   borderRadius: BorderRadius.all(Radius.circular(10)),
            // ),
            height: hp.height / 10,
            width: hp.width / 5),

        Positioned(
            top: hp.height / 13.1072,
            left: hp.width / 13.1072,
            child: CircleAvatar(
                child: CircleAvatar(
                    child: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: ClipOval(
                        child: FadeInImage.assetNetwork(
                            fit: BoxFit.fill,
                            placeholder: 'assets/images/dummy.jpeg',
                            image: Constant.userPicServerUrl+trendingData.user.profileImage),
                      ),
                    ),
                    radius: hp.radius / 64),
                backgroundColor: hp.theme.secondaryHeaderColor,
                radius: hp.radius / 54.9755813888))
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<PostController>(
        builder: itemBuilder,
        init: PostController(
            context,
            context
                .findAncestorStateOfType<GetBuilderState<PostController>>()));
  }
}
