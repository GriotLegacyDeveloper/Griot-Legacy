import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:griot_legacy_social_media_app/src/controllers/post_controller.dart';
import 'package:griot_legacy_social_media_app/src/models/home_data_model.dart';
import 'package:griot_legacy_social_media_app/src/widgets/story_item_widget.dart';

class StoryListWidget extends StatelessWidget {
  final List<Trending> modelData;
  final StoryListWidgetInterface mListner;
  const StoryListWidget({Key key, @required this.modelData, this.mListner}) : super(key: key);

  Widget listBuilder(PostController con) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: getItem,
        itemCount: modelData.length);
  }

  Widget getItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: (){
        mListner.addDetailsPage(modelData[index].post.userId);
      },
      onDoubleTap: (){},
      child: StoryItemWidget(
        trendingData: modelData[index],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PostController>(
        builder: listBuilder,
        init: PostController(
            context,
            context
                .findAncestorStateOfType<GetBuilderState<PostController>>()));
  }
}
abstract class StoryListWidgetInterface{
  addDetailsPage(String id);
}
