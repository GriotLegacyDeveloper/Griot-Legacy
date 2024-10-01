import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:griot_legacy_social_media_app/size_config.dart';
import 'package:griot_legacy_social_media_app/src/controllers/post_controller.dart';
import 'package:griot_legacy_social_media_app/src/models/home_data_model.dart';
import 'package:griot_legacy_social_media_app/src/screens/post_details_page.dart';
import 'package:griot_legacy_social_media_app/src/screens/upload_post_page.dart';
import 'package:griot_legacy_social_media_app/src/widgets/post_list_widget.dart';
import 'package:griot_legacy_social_media_app/src/widgets/story_list_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final HomePageInterface mListener;
  const HomePage({Key key, this.mListener}) : super(key: key);
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with
    StoryListWidgetInterface,PostDetailsPageInterface,PostListWidgetInterface,UploadPostPageInterface{
  bool flag = false;
  Future<SharedPreferences> sharedPrefs = SharedPreferences.getInstance();
  String profileImg;
  String profileName;
  bool didGetResponse = false;
  bool didGetTrendingData = false;
  //didGetResponse is used here to check api response succeessfully get or not
// loaderStatus is used to show / hide loader
  PostController controller;
  HomeResponseModel homeModelData;

  Widget profileImgWidget(
      BuildContext contex, String imgurl, PostController con) {
    print("imgurl  ${imgurl}");
    final hp = con.hp;
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: CircleAvatar(
          radius: 22,
          child: Container(
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: imgurl == null
                    ? Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/dummy.jpeg')),
                        ),
                      )
                    : imgurl == ""
                        ? Container(
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/dummy.jpeg')),
                            ),
                          )
                        : ClipOval(
                            child: FadeInImage.assetNetwork(
                                fit: BoxFit.cover,
                                placeholder: 'assets/images/dummy.jpeg',
                                image: imgurl),
                          ),
              ),
              decoration: BoxDecoration(
                border: Border.all(color: hp.theme.selectedRowColor, width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(22)),
              )),
          backgroundColor: hp.theme.cardColor,
          foregroundColor: hp.theme.secondaryHeaderColor),
    );
  }

  Widget dashboardBuilder(PostController con) {
    final hp = con.hp;
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: SizedBox(
                child: TextField(
                    readOnly: true,
                    onTap: () {
                      //hp.goToRoute("/uploadPost");
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) => UploadPostPage(
                                  imgURL: homeModelData.responseData!=null && homeModelData.responseData.user!=null
                                  ?homeModelData.responseData.user.profileImage
                                  :"assets/images/dummy.jpeg"
                                  , name: profileName,isEdit: false,mListener: this,)))
                          .then((value) => getHomeList());
                    },
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: hp.theme.cardColor,
                        hintStyle: TextStyle(color: hp.theme.primaryColorLight),
                        suffixIcon: Icon(
                            Icons.photo_size_select_actual_outlined,
                            color: hp.theme.primaryColorLight),
                        prefixIcon:
                            profileImgWidget(hp.context,  profileImg, con),
                        border: const OutlineInputBorder(),
                        hintText: "   Build your legacy"),
                    style: TextStyle(color: hp.theme.secondaryHeaderColor)),
                height: hp.height / 16),
          ),
          SizedBox(height: hp.height / 50),
          SizedBox(
            height: didGetTrendingData ? 115 : 8,
            child: didGetTrendingData
                ? StoryListWidget(
                    modelData: homeModelData.responseData.trending,mListner: this,
                  )
                : Container(
                    height: 1,
                  ),
          ),
          didGetResponse
              ? Container(
                  height: (homeModelData.responseData.dashboard.length * 280)
                      .toDouble(),
                  color: Colors.black.withOpacity(0.1),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: homeModelData.responseData.dashboard.length,
                          // shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return homeModelData.responseData.dashboard.elementAt(index).isBlocked==true ?Container():Container(
                              color: Colors.transparent,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  GestureDetector(
                                    onTap: () {
                                     // print("index   $index");
                                      //print("before......${homeModelData.responseData.dashboard[index].isLiked}");
                                      /*Navigator.push(
                                          hp.context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PostDetailsPage(modelData: homeModelData
                                                    .responseData.dashboard[index].data.elementAt(0).caption,
                                                  name: homeModelData.responseData.user.fullName,profilePic: homeModelData.responseData.user.profileImage,
                                                  createDate: homeModelData
                                                      .responseData.dashboard[index].data.elementAt(0).createdAt,
                                                  images: homeModelData
                                                      .responseData.dashboard[index].data.elementAt(0).file,
                                                  list: homeModelData.responseData.dashboard[index].data,type: homeModelData
                                                      .responseData.dashboard[index].data.elementAt(0).type ,
                                                  thumb: homeModelData
                                                      .responseData.dashboard[index].data.elementAt(0).thumb,
                                                  index: index,
                                                  postData:homeModelData.responseData.dashboard[index],
                                                  postID: homeModelData
                                                      .responseData.dashboard[index].data.elementAt(0).postId,
                                                  mListener: this,
                                                ),
                                          ));*/

                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, bottom: 5),
                                      child: Text(
                                        homeModelData
                                            .responseData.dashboard[index].album,
                                        style: const TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 235,
                                    color: Colors.black,
                                    child: PostListWidget(
                                      modelData: homeModelData.responseData.dashboard[index].data,
                                      homeModelData: homeModelData.responseData.dashboard[index].data.elementAt(0).caption ,
                                      name: homeModelData.responseData.user.fullName,
                                      profilePic: homeModelData.responseData.user.profileImage,
                                      createDate: homeModelData.responseData.dashboard[index].data.elementAt(0).createdAt,
                                      images: homeModelData.responseData.dashboard[index].data.elementAt(0).file,
                                      type: homeModelData.responseData.dashboard[index].data.elementAt(0).type ,
                                      thumb: homeModelData.responseData.dashboard[index].data.elementAt(0).thumb,
                                      postData:homeModelData.responseData.dashboard[index],
                                      mListener: this,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Container(
                                      height: 0.5,
                                      //width: 100,
                                      color: Colors.grey.withOpacity(0.8),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                          /* separatorBuilder: (BuildContext context, int index) {
                            return Container(
                              padding: EdgeInsets.only(top: 8),
                              height: 32,
                              child: Text(
                                homeModelData
                                    .responseData.dashboard[index].album
                                    .toString(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            );
                          },*/
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                height: SizeConfig.screenHeight*.60,
                alignment: Alignment.center,
                child: const Text("No Data Found",
                    style: TextStyle(fontSize: 20, color: Colors.white)),
              )
        ],
      ),
    );
  }

  Widget pageBuilder(PostController con) {
    final hp = con.hp;

    return SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: hp.theme.primaryColor,
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                    padding: const EdgeInsets.only(bottom: 30, top: 20),
                    child: dashboardBuilder(con)),
              ),
              flag
                  ? Container(
                      height: hp.height,
                      width: hp.width,
                      color: Colors.black87,
                      child: const SpinKitFoldingCube(color: Colors.white),
                    )
                  : Container(),
            ],
          ),
        ));
  }

  void didChange(GetBuilderState<PostController> state) {
    state.controller.hp.lockScreenRotation();
  }

  @override
  Widget build(BuildContext context) {
    final state =
        context.findAncestorStateOfType<GetBuilderState<PostController>>() ??
            GetBuilderState<PostController>();
    return GetBuilder<PostController>(
        didChangeDependencies: didChange,
        builder: pageBuilder,
        init: PostController(context, state));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialiseProfileValue();
    getHomeList();
    // print("didGetTrendingData      $didGetTrendingData");
  }

  Future getHomeList() async {

    final state =context.findAncestorStateOfType<GetBuilderState<PostController>>() ??
            GetBuilderState<PostController>();
    controller = PostController(context, state);
    final prefs = await controller.sharedPrefs;

    if (mounted) {
      setState(() {
        flag = true;
      });
    }
    controller.waitHomePostDetails().then((value) {
      if (mounted) {
        setState(() {
          flag = false;
        });
      }

      homeModelData = controller.homeData;
      if (homeModelData.responseData.dashboard.isNotEmpty) {
        if (mounted) {
          setState(() {
            didGetResponse = true;

            for (int i = 0; i < homeModelData.responseData.dashboard.length; i++) {
              if (homeModelData.responseData.dashboard[i].likes!= null &&
               homeModelData.responseData.dashboard[i].likes.isNotEmpty) {
                for (int j = 0; j < homeModelData.responseData.dashboard[i].likes.length; j++) {


                  if (prefs.getString("spUserID") == homeModelData.responseData.dashboard[i].likes[j].likedBy.sId) {
                    homeModelData.responseData.dashboard[i].isLiked = true;
                    homeModelData.responseData.dashboard[i].likedId = homeModelData.responseData.dashboard[i].likes[j].id;
                  } else {
                    homeModelData.responseData.dashboard[i].isLiked = false;
                    homeModelData.responseData.dashboard[i].likedId = "0";
                  }
                }
              }
            }


          });
        }
      }else{
        setState(() {
          didGetResponse = false;

        });
      }

      if (homeModelData.responseData.trending.isNotEmpty) {
        if (mounted) {
          setState(() {
            didGetTrendingData = true;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            didGetTrendingData = false;
          });
        }
      }
    });
  }

  void initialiseProfileValue() async {
    final prefs = await sharedPrefs;
    setState(() {
      profileImg = prefs.getString("profileImgUrl");
      print("jjjjjj  ${profileImg}");
      profileName = prefs.getString("profileFullName");
    });
  }

  @override
  addDetailsPage(String id) {
    // TODO: implement addDetailsPage
    widget.mListener.addDetailsPage(id);
  }

  @override
  callApi() {
    // TODO: implement callApi
    getHomeList();
  }

  @override
  apiCallFunction() {
    // TODO: implement apiCallFunction
    getHomeList();

  }
}

abstract class HomePageInterface{
  addDetailsPage(String id);
}

