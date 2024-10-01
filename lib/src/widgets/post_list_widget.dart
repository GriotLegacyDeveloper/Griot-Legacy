import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:griot_legacy_social_media_app/src/controllers/post_controller.dart';
import 'package:griot_legacy_social_media_app/src/models/comment_model.dart';
import 'package:griot_legacy_social_media_app/src/models/home_data_model.dart';
import 'package:griot_legacy_social_media_app/src/models/like_model.dart';
import 'package:griot_legacy_social_media_app/src/screens/post_details_page.dart';
import 'package:griot_legacy_social_media_app/src/widgets/post_item_widget.dart';

class PostListWidget extends StatefulWidget {
  final PostListWidgetInterface mListener;
  final List<DashboardData> modelData;
  final String homeModelData;
  final String name;
  final String createDate;
  final String profilePic;
  final String images;
  final String type;
  final String thumb;
  final Dashboard postData;

  const PostListWidget({Key key, @required this.modelData,this.postData,this.mListener,
    this.name, this.createDate, this.profilePic, this.images, this.type, this.thumb, this.homeModelData}) : super(key: key);

  @override
  State<PostListWidget> createState() => _PostListWidgetState();
}

class _PostListWidgetState extends State<PostListWidget> with PostDetailsPageInterface{
  Widget getItem(BuildContext buildContext, int index) {
    //print("profilePic $profilePic");

    /*final con = PostController(
        buildContext,
        buildContext
            .findAncestorStateOfType<GetBuilderState<PostController>>());*/
    return GestureDetector(
      onTap: (){
        Navigator.push(
            buildContext,
            MaterialPageRoute(
              builder: (context) =>
                  PostDetailsPage(modelData: widget.homeModelData,
                    name: widget.name,
                    profilePic: widget.profilePic,
                    createDate: widget.createDate,
                    images: widget.images,
                    list: widget.modelData,
                    postData: widget.postData,
                    type:widget.type,
                    thumb:widget.thumb,index: index,
                    postID: widget.postData.data.elementAt(0).postId,
                    mListener: this,),
            ));
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: PostItemWidget(post: widget.modelData[index],index:index),
      ),
    );
  }

  Widget listBuilder(PostController con) {

    return ListView.builder(
      padding: const EdgeInsets.all(0.0),

        itemBuilder: getItem,
        itemCount: widget.modelData.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GetBuilder<PostController>(
        builder: listBuilder,
        init: PostController(
            context,
            context.findAncestorStateOfType<GetBuilderState<PostController>>()));
  }

  @override
  callApi() {
    // TODO: implement callApi
    if(widget.mListener!=null){
      widget.mListener.callApi();
    }


  }
}

abstract class PostListWidgetInterface{
  callApi();
}
