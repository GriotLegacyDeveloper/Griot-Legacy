import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:griot_legacy_social_media_app/size_config.dart';
import 'package:griot_legacy_social_media_app/src/controllers/post_controller.dart';
import 'package:griot_legacy_social_media_app/src/helpers/helper.dart';
import 'package:griot_legacy_social_media_app/src/image_picker_handler.dart';
import 'package:griot_legacy_social_media_app/src/models/home_data_model.dart';
import 'package:griot_legacy_social_media_app/src/screens/show_video_class.dart';
import 'package:griot_legacy_social_media_app/src/screens/video_class.dart';
import 'package:griot_legacy_social_media_app/src/utils/constant_class.dart';
import 'package:griot_legacy_social_media_app/src/widgets/my_button.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/user_controller.dart';
import '../models/get_content_model.dart';
import 'about_us_page.dart';

class UploadPostPage extends StatefulWidget {
  final UploadPostPageInterface mListener;
  final bool isEdit;
  final String album;
  final String caption;
  final String postType;
  final String name, imgURL;
  String file;
  final String thumb;
  final String postId;
  final List<TribeModel> tribeId;
  final List<Map<String, dynamic>> imageList;

  UploadPostPage({
    Key key,
    @required this.imgURL,
    @required this.name,
    this.album,
    this.caption,
    this.postType,
    this.file,
    this.isEdit,
    this.thumb,
    this.postId,
    this.imageList,
    this.tribeId,
    this.mListener,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return UploadPostPageState();
  }
}

class UploadPostPageState extends State<UploadPostPage>
    with TickerProviderStateMixin, ImagePickerListener, VideoAppInterface {
  XFile image;
  //final picker = ImagePicker();
  bool flag = true;
  bool isChanged = true;
  PostController controller;
  UserController userController;
  List tribesList = [];
  List selectedTibesList = [];
  String selectedAudienceType = "TRIBE";
  ImagePickerHandler imagePicker;
  AnimationController _controller;
  String comeFrom = "";
  int localIndex;
  String profileImg;
  String profileName;
  Future getTribesList() async {
    final state =
        context.findAncestorStateOfType<GetBuilderState<PostController>>() ??
            GetBuilderState<PostController>();
    controller = PostController(context, state);
    final prefs = await controller.sharedPrefs;
    final obj = {
      "userId": prefs.getString("spUserID"),
      "loginId": prefs.getString("spLoginID"),
      "appType": prefs.getString("spAppType"),
    };
    //print(obj);
    controller.waitUntilGetTribesList(obj).then((value) {
      if (mounted) {
        setState(() {
          flag = true;
          tribesList = controller.tribesList;
        });
      }
    });
  }

  List<File> imagesList = <File>[];
  List<File> imagesListSendtoserver = <File>[];

  int localOne;

  addImages() {
    for (int i = 0; i < widget.imageList.length; i++) {
      File file = File(widget.imageList.elementAt(i)['file']);
      imagesListSendtoserver.add(file);
      localOne = i;
      print("imagesListSendtoserver... ${widget.imageList.elementAt(i)['file']}"
          " ${imagesListSendtoserver.length} $file");
    }
  }

  Future<SharedPreferences> sharedPrefs = SharedPreferences.getInstance();

  List<String> categories = [
    "TRIBE",
    "INNERCIRCLE",
    "VILLAGE",
    "JUSTME",
  ];

  @override
  void initState() {
    super.initState();
    //initialiseProfileValue();

    if (mounted) {
      setState(() {
        flag = false;
      });
    }

    getTribesList();
    controller.tec.text = "";
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    if (widget.isEdit) {
      addImages();
    }
    imagePicker = ImagePickerHandler(this, _controller, "1");
    imagePicker.init();
  }

  initialiseProfileValue() async {
    final prefs = await sharedPrefs;
    setState(() {
      profileImg = prefs.getString("profileImgUrl");
      profileName = prefs.getString("profileFullName");
    });
    print("imgURL    ${widget.imgURL}  ${profileImg}");
  }

  void didChange(GetBuilderState<PostController> state) {
    state.controller.hp.lockScreenRotation();
  }

  Widget gridViewContainer(BuildContext context, List data, String type) {
    return Container(
      padding: const EdgeInsets.only(top: 8, left: 16),
      height: 190,
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            type == "Tribe" ? "Your Tribe List : " : "Your selected tribe",
            style: const TextStyle(
                fontSize: 17, fontWeight: FontWeight.w500, color: Colors.grey),
          ),
          const SizedBox(
            height: 8,
          ),
          tribeGridView(controller.buildContext, data, type)
        ],
      ),
    );
  }

  Widget tribeGridView(BuildContext context, List data, String type) {
    return Container(
        alignment: Alignment.centerLeft,
        color: Colors.transparent,
        height: 150,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: data.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                margin: const EdgeInsets.only(left: 4, right: 4),
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    border: Border.all(color: Colors.white),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                // width: double.infinity,
                child: tribeListView(context, index, data, type));
          },
        ));
  }

  Widget tribeListView(
      BuildContext context, int index, List data, String type) {
    return Container(
      margin: const EdgeInsets.only(left: 8, right: 8),
      child: InkWell(
          onTap: () {
            if (mounted) {
              setState(() {
                if (type == "Tribe") {
                  if (!selectedTibesList.contains(data[index])) {
                    selectedTibesList.add(data[index]);
                  }
                } else {
                  selectedTibesList.remove(data[index]);
                }
              });
            }
          },
          child: tribeView(context, data[index])),
    );
  }

  Widget tribeView(BuildContext context, data) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Container(
          child: AspectRatio(
            aspectRatio: 1 / 1,
            child: ClipOval(
              child: FadeInImage.assetNetwork(
                  fit: BoxFit.fill,
                  placeholder: 'assets/images/noimage.png',
                  image: data["tribeImageUrl"] + data["image"]),
            ),
          ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey, width: 1),
            // image: DecorationImage(
            //     fit: BoxFit.fill,
            //     image: data["image"] == ""
            //         ? const AssetImage("assets/images/dummy.jpeg")
            //         : NetworkImage(data["tribeImageUrl"] + data["image"])),
          ),
          height: 80,
          width: 80,
        ),
        const SizedBox(height: 8),
        Text(
          data["name"],
          style: const TextStyle(color: Colors.white, fontSize: 17),
        ),
      ],
    );
  }

  Widget pageBuilder(PostController controller) {
    final hp = controller.hp;

    if (widget.isEdit != null && widget.isEdit && isChanged) {
      if (widget.postType == "IMAGE" && widget.imageList.length > 1) {
        comeFrom = "2";
      } else if (widget.postType == "VIDEO") {
        comeFrom = "3";
      } else {
        comeFrom = "1";
      }
      if (widget.isEdit) {
        controller.albumText.text = widget.album;
        controller.tec.text = widget.caption;
      }

      isChanged = false;
    }

    return SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
            backgroundColor: hp.theme.primaryColor,
            appBar: AppBar(
                leadingWidth: 0,
                backgroundColor: hp.theme.primaryColor,
                foregroundColor: hp.theme.secondaryHeaderColor,
                title: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (widget.isEdit) {
                          Navigator.pop(context);

                          /*Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const MainScreen()));*/
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.only(left: 25),
                        child: const Text(
                          "Build Your Legacy",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                  ],
                )),
            body: Stack(
              children: [
                SingleChildScrollView(
                    child: Column(children: [
                  Container(
                    height: 0.5,
                    color: Colors.white12,
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: hp.height / 60, horizontal: hp.width / 64),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: AspectRatio(
                                    aspectRatio: 1 / 1,
                                    child: ClipOval(
                                      child: FadeInImage.assetNetwork(
                                          fit: BoxFit.cover,
                                          placeholder:
                                              'assets/images/noimage.png',
                                          image: Constant.userPicServerUrl +
                                              widget.imgURL),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.grey, width: 1),
                                    // image: DecorationImage(
                                    //     fit: BoxFit.fill,
                                    //     image: data["image"] == ""
                                    //         ? const AssetImage("assets/images/dummy.jpeg")
                                    //         : NetworkImage(data["tribeImageUrl"] + data["image"])),
                                  ),
                                  height: SizeConfig.screenHeight * .07,
                                  width: SizeConfig.screenHeight * .07,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: SizeConfig.screenWidth * .05),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(widget.name ?? "",
                                          style: TextStyle(
                                              color: hp
                                                  .theme.secondaryHeaderColor)),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: SizeConfig.screenHeight * .01),
                                        child: Container(
                                          // alignment: Alignment.topCenter,
                                          color: Colors.transparent,
                                          // height: 35,
                                          width: 110,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              /*        DropdownButtonFormField(
                                                  decoration:
                                                       InputDecoration(
                                                    isDense: true,
                                                    // isDense: true padding value
                                                    contentPadding:
                                                        EdgeInsets.only(left: 7,top: 5),

                                                        border: OutlineInputBorder(  // <--- this line
                                                        ),
                                                  ),
                                                  alignment: AlignmentDirectional
                                                      .centerStart,
                                                  style: const TextStyle(
                                                      fontSize: 9),
                                                  isDense: true,
                                                  iconEnabledColor: hp
                                                      .theme.secondaryHeaderColor,
                                                  dropdownColor:
                                                      hp.theme.selectedRowColor,
                                                  hint: Text("Hi",
                                                      style: TextStyle(
                                                          color: hp.theme
                                                              .secondaryHeaderColor)),
                                                  value: controller.value,
                                                  onChanged: (value) {
                                                    if (mounted) {
                                                      setState(() {
                                                        selectedAudienceType =
                                                            value;
                                                        controller.value = value;
                                                      });
                                                    }
                                                    controller.onChanged;
                                                  },
                                                  items: <String>[
                                                    "TRIBE",
                                                    "INNERCIRCLE",
                                                    "VILLAGE",
                                                    "JUSTME",
                                                  ]
                                                      .map((e) => DropdownMenuItem<
                                                              String>(

                                                          value: e,
                                                          child: Text(e,
                                                              style: TextStyle(
                                                                  color: hp.theme
                                                                      .secondaryHeaderColor))))
                                                      .toList()),*/
                                              PopupMenuButton(
                                                  onSelected: (value) {
                                                    if (mounted) {
                                                      setState(() {
                                                        selectedAudienceType =
                                                            value;
                                                        controller.value =
                                                            value;
                                                      });
                                                    }
                                                    controller.onChanged;
                                                  },
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      10.0))),
                                                  itemBuilder: (context) {
                                                    return categories
                                                        .map(
                                                          (value) =>
                                                              PopupMenuItem(
                                                            value: value,
                                                            child: Text(
                                                              value,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 10),
                                                            ),
                                                          ),
                                                        )
                                                        .toList();
                                                  },
                                                  offset: const Offset(1, 30),
                                                  child: Container(
                                                    // padding: EdgeInsets.all(8.0),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                                Colors.white),
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    8))),
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: SizeConfig
                                                                  .screenHeight *
                                                              .01),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            controller.value,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 10),
                                                          ),
                                                          const Icon(
                                                            Icons
                                                                .arrow_drop_down,
                                                            color: Colors.white,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(right: 12),
                            child: MyButton(
                                label: "Post",
                                labelWeight: FontWeight.w500,
                                onPressed: () async {
                                  String imageListId = "";
                                  if (rememberMe) {
                                    if (widget.imageList != null &&
                                        widget.imageList.isNotEmpty) {
                                      imageListId =
                                          "${widget.imageList[0]["id"]}";
                                      for (int i = 1;
                                          i < widget.imageList.length;
                                          i++) {
                                        imageListId = imageListId +
                                            ',' +
                                            widget.imageList[i]["id"];
                                      }
                                    }
                                    if (comeFrom != "") {
                                      if (comeFrom == "1") {
                                        print("commmme11111");
                                        if (selectedAudienceType == "TRIBE") {
                                          if (controller.tec.text == "") {
                                            Helper.showToast(
                                                "Please enter some text");
                                          }
                                          // else if (selectedTibesList.isEmpty) {
                                          //   Helper.showToast(
                                          //       "Please select any tribe");
                                          // }
                                          else if (controller.albumText.text ==
                                              "") {
                                            Helper.showToast(
                                                "Please enter album name");

                                            /*EasyLoading.showToast(
                                         "Please enter album name");*/
                                          } else if (image == null &&
                                              widget.file == null) {
                                            Helper.showToast(
                                                "Please upload at least one photo");
                                          } else {
                                            final prefs =
                                                await controller.sharedPrefs;
                                            var tribeID = "";
                                            for (var i = 0;
                                                i < selectedTibesList.length;
                                                i++) {
                                              tribeID = tribeID +
                                                  selectedTibesList[i]["_id"] +
                                                  ",";
                                            }
                                            final body = widget.isEdit
                                                ? {
                                                    "userId": prefs
                                                        .getString("spUserID"),
                                                    "loginId": prefs
                                                        .getString("spLoginID"),
                                                    "appType": prefs
                                                        .getString("spAppType"),
                                                    "caption":
                                                        controller.tec.text,
                                                    "audience":
                                                        controller.value,
                                                    "fileIds": imageListId,
                                                    "postType": (image !=
                                                                null ||
                                                            widget.file != null)
                                                        ? "FILE"
                                                        : "NORMAL",
                                                    "album": controller
                                                        .albumText.text,
                                                    "tribeId": tribeID,
                                                    "postId": widget.postId
                                                  }
                                                : {
                                                    "userId": prefs
                                                        .getString("spUserID"),
                                                    "loginId": prefs
                                                        .getString("spLoginID"),
                                                    "appType": prefs
                                                        .getString("spAppType"),
                                                    "caption":
                                                        controller.tec.text,
                                                    "audience":
                                                        controller.value,
                                                    "postType": (image != null)
                                                        ? "FILE"
                                                        : "NORMAL",
                                                    "album": controller
                                                        .albumText.text,
                                                    "tribeId": tribeID
                                                  };
                                            //  print(body);
                                            if (mounted) {
                                              setState(() {
                                                flag = false;
                                              });
                                            }

                                            if (image != null) {
                                              controller
                                                  .waitUntilCreateFilePostSingleImage(
                                                      body,
                                                      image.path,
                                                      widget.isEdit)
                                                  .then((value) {
                                                if (mounted) {
                                                  setState(() {
                                                    flag = true;
                                                    controller.tec.text = "";
                                                    controller.albumText.text =
                                                        "";
                                                  });
                                                }
                                              });
                                            } else {
                                              Helper.showToast(
                                                  "Select at least one image");

                                              controller
                                                  .waitUntilCreateNormalPost(
                                                      body, widget.isEdit)
                                                  .then((value) {
                                                if (value) {
                                                  if (mounted) {
                                                    setState(() {
                                                      flag = true;
                                                      controller.tec.text = "";
                                                      controller
                                                          .albumText.text = "";
                                                    });
                                                  }
                                                }
                                              });
                                            }
                                          }
                                        } else {
                                          if (controller.tec.text == "") {
                                            Helper.showToast(
                                                "Please enter some text");
                                          } else if (controller
                                                  .albumText.text ==
                                              "") {
                                            Helper.showToast(
                                                "Please enter album name");
                                          } else if (image == null &&
                                              widget.file == null) {
                                            Helper.showToast(
                                                "Please upload at least one photo");
                                          } else {
                                            final prefs =
                                                await controller.sharedPrefs;
                                            var tribeID = "";
                                            for (var i = 0;
                                                i < selectedTibesList.length;
                                                i++) {
                                              tribeID = tribeID +
                                                  selectedTibesList[i]["_id"] +
                                                  ",";
                                            }
                                            final body = widget.isEdit
                                                ? {
                                                    "userId": prefs
                                                        .getString("spUserID"),
                                                    "loginId": prefs
                                                        .getString("spLoginID"),
                                                    "appType": prefs
                                                        .getString("spAppType"),
                                                    "caption":
                                                        controller.tec.text,
                                                    "audience":
                                                        controller.value,
                                                    "fileIds": imageListId,
                                                    "postType": (image !=
                                                                null ||
                                                            widget.file != null)
                                                        ? "FILE"
                                                        : "NORMAL",
                                                    "album": controller
                                                        .albumText.text,
                                                    "tribeId": tribeID,
                                                    "postId": widget.postId
                                                  }
                                                : {
                                                    "userId": prefs
                                                        .getString("spUserID"),
                                                    "loginId": prefs
                                                        .getString("spLoginID"),
                                                    "appType": prefs
                                                        .getString("spAppType"),
                                                    "caption":
                                                        controller.tec.text,
                                                    "audience":
                                                        controller.value,
                                                    "postType": (image != null)
                                                        ? "FILE"
                                                        : "NORMAL",
                                                    "album": controller
                                                        .albumText.text,
                                                    "tribeId": tribeID
                                                  };
                                            //  print(body);
                                            if (mounted) {
                                              setState(() {
                                                flag = false;
                                              });
                                            }
                                            if (image != null) {
                                              controller
                                                  .waitUntilCreateFilePostSingleImage(
                                                      body,
                                                      image.path,
                                                      widget.isEdit)
                                                  .then((value) {
                                                if (mounted) {
                                                  setState(() {
                                                    flag = true;
                                                    controller.tec.text = "";
                                                    controller.albumText.text =
                                                        "";
                                                  });
                                                }
                                              });
                                            } else {
                                              Helper.showToast(
                                                  "Select at least one image");

                                              controller
                                                  .waitUntilCreateNormalPost(
                                                      body, widget.isEdit)
                                                  .then((value) {
                                                if (value) {
                                                  if (mounted) {
                                                    setState(() {
                                                      flag = true;
                                                      controller.tec.text = "";
                                                      controller
                                                          .albumText.text = "";
                                                    });
                                                  }
                                                }
                                              });
                                            }
                                          }
                                        }
                                      } else if (comeFrom == "3") {
                                        print("comeeee3333");
                                        if (selectedAudienceType == "TRIBE") {
                                          if (controller.tec.text == "") {
                                            Helper.showToast(
                                                "Please enter some text");
                                          }
                                          //  else if (selectedTibesList
                                          //     .isEmpty) {
                                          //   Helper.showToast(
                                          //       "Please select any tribe");
                                          // }
                                          else if (controller.albumText.text ==
                                              "") {
                                            Helper.showToast(
                                                "Please enter album name");
                                            /* EasyLoading.showToast(
                                         "Please enter album name");*/
                                          } else if (videoFile == null &&
                                              widget.file == null) {
                                            Helper.showToast(
                                                "Please upload at least one photo");
                                          } else {
                                            final prefs =
                                                await controller.sharedPrefs;
                                            var tribeID = "";
                                            for (var i = 0;
                                                i < selectedTibesList.length;
                                                i++) {
                                              tribeID = tribeID +
                                                  selectedTibesList[i]["_id"] +
                                                  ",";
                                            }
                                            final body = widget.isEdit
                                                ? {
                                                    "userId": prefs
                                                        .getString("spUserID"),
                                                    "loginId": prefs
                                                        .getString("spLoginID"),
                                                    "appType": prefs
                                                        .getString("spAppType"),
                                                    "caption":
                                                        controller.tec.text,
                                                    "audience":
                                                        controller.value,
                                                    "fileIds": imageListId,
                                                    "postType": (image !=
                                                                null ||
                                                            widget.file != null)
                                                        ? "FILE"
                                                        : "NORMAL",
                                                    "album": controller
                                                        .albumText.text,
                                                    "tribeId": tribeID,
                                                    "postId": widget.postId
                                                  }
                                                : {
                                                    "userId": prefs
                                                        .getString("spUserID"),
                                                    "loginId": prefs
                                                        .getString("spLoginID"),
                                                    "appType": prefs
                                                        .getString("spAppType"),
                                                    "caption":
                                                        controller.tec.text,
                                                    "audience":
                                                        controller.value,
                                                    "postType":
                                                        (videoFile != null)
                                                            ? "FILE"
                                                            : "NORMAL",
                                                    "album": controller
                                                        .albumText.text,
                                                    "tribeId": tribeID
                                                  };
                                            // print(body);
                                            if (mounted) {
                                              setState(() {
                                                flag = false;
                                              });
                                            }
                                            if (isMixPosting) {
                                              print(
                                                  "hhhhh  ${imagesList.length}");
                                              if (imagesList.isNotEmpty) {
                                                controller
                                                    .waitUntilPostImageListAndVideoUrl(
                                                        body,
                                                        imagesList,
                                                        thumb.path,
                                                        widget.isEdit)
                                                    .then((value) {
                                                  Navigator.pop(context);
                                                  if (mounted) {
                                                    setState(() {
                                                      flag = true;
                                                      controller.tec.text = "";
                                                      controller
                                                          .albumText.text = "";
                                                    });
                                                  }
                                                });
                                              }
                                            } else {
                                              print("elsssssssone");

                                              if (videoFile != null) {
                                                controller
                                                    .waitUntilUploadThumb(
                                                        body,
                                                        videoFile.path,
                                                        thumb.path,
                                                        widget.isEdit)
                                                    .then((value) {
                                                  // Navigator.pop(context);
                                                  if (mounted) {
                                                    setState(() {
                                                      flag = true;
                                                      controller.tec.text = "";
                                                      controller
                                                          .albumText.text = "";
                                                      if (widget.isEdit) {
                                                        widget.mListener
                                                            .apiCallFunction();
                                                      }
                                                    });
                                                  }
                                                });
                                              } else {
                                                controller
                                                    .waitUntilCreateNormalPost(
                                                        body, widget.isEdit)
                                                    .then((value) {
                                                  if (value) {
                                                    //  print("POPPPPP");
                                                    //Navigator.pop(context);
                                                    if (mounted) {
                                                      setState(() {
                                                        flag = true;
                                                        controller.tec.text =
                                                            "";
                                                        controller.albumText
                                                            .text = "";
                                                      });
                                                    }
                                                  }
                                                });
                                              }
                                            }
                                          }
                                        } else {
                                          if (controller.tec.text == "") {
                                            Helper.showToast(
                                                "Please enter some text");
                                          } else if (controller
                                                  .albumText.text ==
                                              "") {
                                            Helper.showToast(
                                                "Please enter album name");
                                          } else if (videoFile == null &&
                                              widget.file == null) {
                                            Helper.showToast(
                                                "Please upload at least one photo");
                                          } else {
                                            final prefs =
                                                await controller.sharedPrefs;
                                            var tribeID = "";
                                            for (var i = 0;
                                                i < selectedTibesList.length;
                                                i++) {
                                              tribeID = tribeID +
                                                  selectedTibesList[i]["_id"] +
                                                  ",";
                                            }
                                            final body = widget.isEdit
                                                ? {
                                                    "userId": prefs
                                                        .getString("spUserID"),
                                                    "loginId": prefs
                                                        .getString("spLoginID"),
                                                    "appType": prefs
                                                        .getString("spAppType"),
                                                    "caption":
                                                        controller.tec.text,
                                                    "audience":
                                                        controller.value,
                                                    "fileIds": imageListId,
                                                    "postType": (image !=
                                                                null ||
                                                            widget.file != null)
                                                        ? "FILE"
                                                        : "NORMAL",
                                                    "album": controller
                                                        .albumText.text,
                                                    "tribeId": tribeID,
                                                    "postId": widget.postId
                                                  }
                                                : {
                                                    "userId": prefs
                                                        .getString("spUserID"),
                                                    "loginId": prefs
                                                        .getString("spLoginID"),
                                                    "appType": prefs
                                                        .getString("spAppType"),
                                                    "caption":
                                                        controller.tec.text,
                                                    "audience":
                                                        controller.value,
                                                    "postType":
                                                        (videoFile != null)
                                                            ? "FILE"
                                                            : "NORMAL",
                                                    "album": controller
                                                        .albumText.text,
                                                    "tribeId": tribeID
                                                  };
                                            // print(body);
                                            if (mounted) {
                                              setState(() {
                                                flag = false;
                                              });
                                            }
                                            if (isMixPosting) {
                                              print(
                                                  "hhhhh  ${imagesList.length}");
                                              if (imagesList.isNotEmpty) {
                                                controller
                                                    .waitUntilPostImageListAndVideoUrl(
                                                        body,
                                                        imagesList,
                                                        thumb.path,
                                                        widget.isEdit)
                                                    .then((value) {
                                                  Navigator.pop(context);
                                                  if (mounted) {
                                                    setState(() {
                                                      flag = true;
                                                      controller.tec.text = "";
                                                      controller
                                                          .albumText.text = "";
                                                    });
                                                  }
                                                });
                                              }
                                            } else {
                                              if (videoFile != null) {
                                                // print("withimaggggg");
                                                controller
                                                    .waitUntilUploadThumb(
                                                        body,
                                                        videoFile.path,
                                                        thumb.path,
                                                        widget.isEdit)
                                                    .then((value) {
                                                  // Navigator.pop(context);

                                                  //print("RRRRRR");
                                                  if (mounted) {
                                                    setState(() {
                                                      flag = true;
                                                      controller.tec.text = "";
                                                      controller
                                                          .albumText.text = "";
                                                    });
                                                  }
                                                });
                                              } else {
                                                controller
                                                    .waitUntilCreateNormalPost(
                                                        body, widget.isEdit)
                                                    .then((value) {
                                                  if (value) {
                                                    //  print("POPPPPP");
                                                    Navigator.pop(context);
                                                    if (mounted) {
                                                      setState(() {
                                                        flag = true;
                                                        controller.tec.text =
                                                            "";
                                                        controller.albumText
                                                            .text = "";
                                                      });
                                                    }
                                                  }
                                                });
                                              }
                                            }
                                          }
                                        }
                                      } else {
                                        print("comeeeeee");
                                        if (selectedAudienceType == "TRIBE") {
                                          print("tribbbbbbb");
                                          if (controller.tec.text == "") {
                                            Helper.showToast(
                                                "Please enter some text");
                                            /*  EasyLoading.showToast(
                                         "Please enter some text");*/
                                          }
                                          // else if (selectedTibesList
                                          //     .isEmpty) {
                                          //   Helper.showToast(
                                          //       "Please select any tribe");
                                          // }
                                          else if (controller.albumText.text ==
                                              "") {
                                            Helper.showToast(
                                                "Please enter album name");
                                          } else if (imagesList.isEmpty &&
                                              widget.file == null) {
                                            Helper.showToast(
                                                "Please upload at least one photo");
                                          } else {
                                            final prefs =
                                                await controller.sharedPrefs;
                                            var tribeID = "";
                                            for (var i = 0;
                                                i < selectedTibesList.length;
                                                i++) {
                                              tribeID = tribeID +
                                                  selectedTibesList[i]["_id"] +
                                                  ",";
                                            }
                                            final body = widget.isEdit
                                                ? {
                                                    "userId": prefs
                                                        .getString("spUserID"),
                                                    "loginId": prefs
                                                        .getString("spLoginID"),
                                                    "appType": prefs
                                                        .getString("spAppType"),
                                                    "caption":
                                                        controller.tec.text,
                                                    "audience":
                                                        controller.value,
                                                    "fileIds": imageListId,
                                                    "postType": (image !=
                                                                null ||
                                                            widget.file != null)
                                                        ? "FILE"
                                                        : "NORMAL",
                                                    "album": controller
                                                        .albumText.text,
                                                    "tribeId": tribeID,
                                                    "postId": widget.postId
                                                  }
                                                : {
                                                    "userId": prefs
                                                        .getString("spUserID"),
                                                    "loginId": prefs
                                                        .getString("spLoginID"),
                                                    "appType": prefs
                                                        .getString("spAppType"),
                                                    "caption":
                                                        controller.tec.text,
                                                    "audience":
                                                        controller.value,
                                                    "postType":
                                                        (imagesList.length !=
                                                                null)
                                                            ? "FILE"
                                                            : "NORMAL",
                                                    "album": controller
                                                        .albumText.text,
                                                    "tribeId": tribeID
                                                  };
                                            // print(body);
                                            if (mounted) {
                                              setState(() {
                                                flag = false;
                                              });
                                            }
                                            print(
                                                "hhhhh  ${imagesList.length}");

                                            if (isMixPosting) {
                                              print(
                                                  "hhhhh  ${imagesList.length}");
                                              if (imagesList.isNotEmpty) {
                                                controller
                                                    .waitUntilPostImageListAndVideoUrl(
                                                        body,
                                                        imagesList,
                                                        thumb.path,
                                                        widget.isEdit)
                                                    .then((value) {
                                                  Navigator.pop(context);
                                                  if (mounted) {
                                                    setState(() {
                                                      flag = true;
                                                      controller.tec.text = "";
                                                      controller
                                                          .albumText.text = "";
                                                    });
                                                  }
                                                });
                                              }
                                            } else {
                                              if (imagesList.length != null &&
                                                  (widget.file != null &&
                                                      imagesList.isNotEmpty)) {
                                                print("withimaggggg");
                                                controller
                                                    .waitUntilCreateFilePost(
                                                        body,
                                                        imagesList,
                                                        widget.isEdit)
                                                    .then((value) {
                                                  print("RRRRRRtribbbb");
                                                  Navigator.pop(context, true);
                                                  if (widget.isEdit) {
                                                    widget.mListener
                                                        .apiCallFunction();
                                                  }
                                                  if (mounted) {
                                                    setState(() {
                                                      flag = true;

                                                      controller.tec.text = "";
                                                      controller
                                                          .albumText.text = "";
                                                    });
                                                  }
                                                });
                                              }
                                              /*else if(widget.imageList!=null){
                                              controller
                                                  .waitUntilCreateFilePost(body,
                                                  imagesList, widget.isEdit)
                                                  .then((value) {
                                                print("edit...");
                                                Navigator.pop(context, true);
                                                if (widget.isEdit) {
                                                  widget.mListener
                                                      .apiCallFunction();
                                                }

                                                setState(() {
                                                  flag = true;

                                                  controller.tec.text = "";
                                                  controller.albumText.text =
                                                  "";
                                                });
                                              });
                                            }*/
                                              else {
                                                print("withoutimageeee");

                                                controller
                                                    .waitUntilCreateNormalPost(
                                                        body, widget.isEdit)
                                                    .then((value) {
                                                  if (value) {
                                                    if (widget.isEdit) {
                                                      widget.mListener
                                                          .apiCallFunction();
                                                    }
                                                    //Navigator.pop(context, true);

                                                    print("POPPPPPtribe");
                                                    // Navigator.pop(context);
                                                    if (mounted) {
                                                      setState(() {
                                                        flag = true;
                                                        controller.tec.text =
                                                            "";
                                                        controller.albumText
                                                            .text = "";
                                                      });
                                                    }
                                                  }
                                                });
                                              }
                                            }
                                          }
                                        } else {
                                          print("nottribeee");
                                          if (controller.tec.text == "") {
                                            Helper.showToast(
                                                "Please enter some text");
                                          } else if (controller
                                                  .albumText.text ==
                                              "") {
                                            Helper.showToast(
                                                "Please enter album name");
                                          } else if (imagesList.isEmpty &&
                                              widget.file == null) {
                                            Helper.showToast(
                                                "Please upload at least one photo");
                                          } else {
                                            final prefs =
                                                await controller.sharedPrefs;
                                            var tribeID = "";
                                            for (var i = 0;
                                                i < selectedTibesList.length;
                                                i++) {
                                              tribeID = tribeID +
                                                  selectedTibesList[i]["_id"] +
                                                  ",";
                                            }
                                            final body = widget.isEdit
                                                ? {
                                                    "userId": prefs
                                                        .getString("spUserID"),
                                                    "loginId": prefs
                                                        .getString("spLoginID"),
                                                    "appType": prefs
                                                        .getString("spAppType"),
                                                    "caption":
                                                        controller.tec.text,
                                                    "audience":
                                                        controller.value,
                                                    "fileIds": imageListId,
                                                    "postType": (image !=
                                                                null ||
                                                            widget.file != null)
                                                        ? "FILE"
                                                        : "NORMAL",
                                                    "album": controller
                                                        .albumText.text,
                                                    "tribeId": tribeID,
                                                    "postId": widget.postId
                                                  }
                                                : {
                                                    "userId": prefs
                                                        .getString("spUserID"),
                                                    "loginId": prefs
                                                        .getString("spLoginID"),
                                                    "appType": prefs
                                                        .getString("spAppType"),
                                                    "caption":
                                                        controller.tec.text,
                                                    "audience":
                                                        controller.value,
                                                    "postType":
                                                        (imagesList.length !=
                                                                null)
                                                            ? "FILE"
                                                            : "NORMAL",
                                                    "album": controller
                                                        .albumText.text,
                                                    "tribeId": tribeID
                                                  };
                                            // print(body);
                                            if (mounted) {
                                              setState(() {
                                                flag = false;
                                              });
                                            }
                                            if (isMixPosting) {
                                              print(
                                                  "hhhhh  ${imagesList.length}");
                                              if (imagesList.isNotEmpty) {
                                                controller
                                                    .waitUntilPostImageListAndVideoUrl(
                                                        body,
                                                        imagesList,
                                                        thumb.path,
                                                        widget.isEdit)
                                                    .then((value) {
                                                  Navigator.pop(context);
                                                  if (mounted) {
                                                    setState(() {
                                                      flag = true;
                                                      controller.tec.text = "";
                                                      controller
                                                          .albumText.text = "";
                                                    });
                                                  }
                                                });
                                              }
                                            } else {
                                              if (imagesList.length != null ||
                                                  (widget.file != null &&
                                                      widget.imageList !=
                                                          null &&
                                                      widget.imageList.length >
                                                          1)) {
                                                /// print("withimaggggg");
                                                controller
                                                    .waitUntilCreateFilePost(
                                                        body,
                                                        imagesList,
                                                        widget.isEdit)
                                                    .then((value) {
                                                  print("RRRRRR");
                                                  Navigator.pop(context);
                                                  if (widget.isEdit) {
                                                    widget.mListener
                                                        .apiCallFunction();
                                                  }
                                                  if (mounted) {
                                                    setState(() {
                                                      flag = true;

                                                      controller.tec.text = "";
                                                      controller
                                                          .albumText.text = "";
                                                    });
                                                  }
                                                });
                                              } else {
                                                controller
                                                    .waitUntilCreateNormalPost(
                                                        body, widget.isEdit)
                                                    .then((value) {
                                                  if (value) {
                                                    print("POPPPPP");
                                                    Navigator.pop(context);
                                                    if (mounted) {
                                                      setState(() {
                                                        flag = true;
                                                        controller.tec.text =
                                                            "";
                                                        controller.albumText
                                                            .text = "";
                                                      });
                                                    }
                                                  }
                                                });
                                              }
                                            }
                                          }
                                        }
                                      }
                                    } //if
                                    else {
                                      Helper.showToast(
                                          "Please upload at least one photo");
                                    }
                                  } else {
                                    Helper.showToast(
                                        "Read guideline carefully accept this guideline and tick on checkbox");
                                  }
                                },
                                heightFactor: 80,
                                widthFactor: 20,
                                radiusFactor: 80),
                          )
                        ],
                      )),
                  // const SizedBox(height: 12),
                  widget.isEdit
                      ? imagesList.isNotEmpty ||
                              (comeFrom == "2" &&
                                  widget.imageList != null &&
                                  widget.imageList.length > 1)
                          ? Container(
                              height: 100,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: widget.isEdit
                                          ? ReorderableListView.builder(
                                              padding:
                                                  const EdgeInsets.all(0.0),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                final String productName =
                                                    widget.imageList[index]
                                                        ["file"];

                                                return Card(
                                                  key: ValueKey(productName),
                                                  // color: Colors.amberAccent,
                                                  elevation: 1,
                                                  margin:
                                                      const EdgeInsets.all(10),
                                                  child: Stack(
                                                    alignment:
                                                        Alignment.topRight,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        child: Container(
                                                            //alignment: Alignment.center,
                                                            height: 100,
                                                            width: 60,
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  color: hp
                                                                      .theme
                                                                      .selectedRowColor,
                                                                  width: 1),
                                                              borderRadius:
                                                                  const BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          10.0)),
                                                              //color: Colors.blue
                                                            ),
                                                            child:
                                                                Image.network(
                                                              /*Constant.SERVER_URL +*/
                                                              widget.imageList[
                                                                      index]
                                                                  ["file"],
                                                              fit: BoxFit.cover,
                                                            )),
                                                      ),
                                                      IconButton(
                                                        icon: const Icon(
                                                            Icons.delete),
                                                        iconSize: 20.0,
                                                        color: Colors.white,
                                                        onPressed: () {
                                                          if (mounted) {
                                                            setState(() {
                                                              if (widget
                                                                  .isEdit) {
                                                                print(
                                                                    "eddittt   $index");
                                                                widget.imageList
                                                                    .removeAt(
                                                                        index);
                                                                videoFile =
                                                                    null;
                                                              }
                                                            });
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                              itemCount:
                                                  widget.imageList.length,
                                              scrollDirection: Axis.horizontal,
                                              onReorder: (oldIndex, newIndex) {
                                                if (mounted) {
                                                  setState(() {
                                                    if (newIndex > oldIndex) {
                                                      newIndex = newIndex - 1;
                                                    }
                                                    final element = widget
                                                        .imageList
                                                        .removeAt(oldIndex);
                                                    widget.imageList.insert(
                                                        newIndex, element);
                                                  });
                                                }
                                              })
                                          : ReorderableListView.builder(
                                              padding:
                                                  const EdgeInsets.all(0.0),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                final String productName =
                                                    imagesList[index].path;

                                                return Card(
                                                  key: ValueKey(productName),
                                                  // color: Colors.amberAccent,
                                                  elevation: 1,
                                                  margin:
                                                      const EdgeInsets.all(10),
                                                  child: Stack(
                                                    alignment:
                                                        Alignment.topRight,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        child: Container(
                                                          //alignment: Alignment.center,
                                                          height: 100,
                                                          width: 60,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                color: hp.theme
                                                                    .selectedRowColor,
                                                                width: 1),
                                                            borderRadius:
                                                                const BorderRadius
                                                                        .all(
                                                                    Radius.circular(
                                                                        10.0)),
                                                            //color: Colors.blue
                                                          ),
                                                          child: Image.file(
                                                            File(imagesList[
                                                                    index]
                                                                .path),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      IconButton(
                                                        icon: const Icon(
                                                            Icons.delete),
                                                        iconSize: 20.0,
                                                        color: Colors.white,
                                                        onPressed: () {
                                                          if (mounted) {
                                                            setState(() {
                                                              imagesList
                                                                  .removeAt(
                                                                      index);
                                                              videoFile = null;
                                                            });
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                              itemCount: imagesList.length,
                                              scrollDirection: Axis.horizontal,
                                              onReorder: (oldIndex, newIndex) {
                                                if (mounted) {
                                                  setState(() {
                                                    if (newIndex > oldIndex) {
                                                      newIndex = newIndex - 1;
                                                    }
                                                    final element = imagesList
                                                        .removeAt(oldIndex);
                                                    imagesList.insert(
                                                        newIndex, element);
                                                  });
                                                }
                                              }),
                                    ),
                                    Expanded(
                                      child: Visibility(
                                        visible: imagesList.isNotEmpty &&
                                                widget.isEdit
                                            ? true
                                            : false,
                                        child: ReorderableListView.builder(
                                            padding: const EdgeInsets.all(0.0),
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              final String productName =
                                                  imagesList[index].path;

                                              return Card(
                                                key: ValueKey(productName),
                                                // color: Colors.amberAccent,
                                                elevation: 1,
                                                margin:
                                                    const EdgeInsets.all(10),
                                                child: Stack(
                                                  alignment: Alignment.topRight,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Container(
                                                        //alignment: Alignment.center,
                                                        height: 100,
                                                        width: 60,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color: hp.theme
                                                                  .selectedRowColor,
                                                              width: 1),
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          10.0)),
                                                          //color: Colors.blue
                                                        ),
                                                        child: Image.file(
                                                          File(imagesList[index]
                                                              .path),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(
                                                          Icons.delete),
                                                      iconSize: 20.0,
                                                      color: Colors.white,
                                                      onPressed: () {
                                                        if (mounted) {
                                                          setState(() {
                                                            imagesList.removeAt(
                                                                index);
                                                            videoFile = null;
                                                          });
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            itemCount: imagesList.length,
                                            scrollDirection: Axis.horizontal,
                                            onReorder: (oldIndex, newIndex) {
                                              if (mounted) {
                                                setState(() {
                                                  if (newIndex > oldIndex) {
                                                    newIndex = newIndex - 1;
                                                  }
                                                  final element = imagesList
                                                      .removeAt(oldIndex);
                                                  imagesList.insert(
                                                      newIndex, element);
                                                });
                                              }
                                            }),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : image != null || comeFrom == "1"
                              ? Container(
                                  //alignment: Alignment.center,
                                  height: 100,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    // color: Colors.green,
                                    border: Border.all(
                                        color: hp.theme.selectedRowColor,
                                        width: 1),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0)),
                                    //color: Colors.blue
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: widget.isEdit
                                        ? Image.network(
                                            /*Constant.SERVER_URL +*/ widget
                                                .file,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.file(
                                            File(image.path),
                                            fit: BoxFit.fitWidth,
                                          ),
                                  ),
                                )
                              : comeFrom == "3"
                                  ? widget.file != ""
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16, right: 16),
                                          child: widget.isEdit
                                              ? Container(
                                                  height:
                                                      SizeConfig.screenHeight *
                                                          .28,
                                                  color: Colors.black,
                                                  child: ShowVideoApp(
                                                    videoUrl:
                                                        /*Constant.SERVER_URL +*/
                                                        widget.file,
                                                    thumb: widget.thumb,
                                                    come: "2",
                                                  ))
                                              : Container(
                                                  height:
                                                      SizeConfig.screenHeight *
                                                          .28,
                                                  // color: Colors.black,
                                                  child: VideoApp(
                                                    mListener: this,
                                                    videoUrl: videoFile,
                                                  )),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16, right: 16),
                                          child: Container(
                                              height:
                                                  SizeConfig.screenHeight * .28,
                                              // color: Colors.black,
                                              child: VideoApp(
                                                mListener: this,
                                                videoUrl: videoFile,
                                              )),
                                        )
                                  : Container()
                      : Visibility(
                          visible: imagesList.isNotEmpty ? true : false,
                          child: Container(
                            height: 100,
                            child: ReorderableListView.builder(
                                padding: const EdgeInsets.all(0.0),
                                itemBuilder: (BuildContext context, int index) {
                                  print("index,,,,   $index $comeFrom");
                                  localIndex = index;
                                  final String productName =
                                      imagesList[index].path;

                                  return Card(
                                    key: ValueKey(productName),
                                    // color: Colors.amberAccent,
                                    elevation: 1,
                                    margin: const EdgeInsets.all(10),
                                    child: Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Container(
                                            //alignment: Alignment.center,
                                            height: 100,
                                            width: 60,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color:
                                                      hp.theme.selectedRowColor,
                                                  width: 1),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10.0)),
                                              //color: Colors.blue
                                            ),
                                            child: imagesList[index].path !=
                                                    null
                                                ? Image.file(
                                                    File(
                                                        imagesList[index].path),
                                                    fit: BoxFit.cover,
                                                  )
                                                : Container(),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          iconSize: 20.0,
                                          color: Colors.white,
                                          onPressed: () {
                                            if (mounted) {
                                              setState(() {
                                                imagesList.removeAt(index);
                                                videoFile = null;
                                              });
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                itemCount: imagesList.length,
                                scrollDirection: Axis.horizontal,
                                onReorder: (oldIndex, newIndex) {
                                  if (mounted) {
                                    setState(() {
                                      if (newIndex > oldIndex) {
                                        newIndex = newIndex - 1;
                                      }
                                      final element =
                                          imagesList.removeAt(oldIndex);
                                      imagesList.insert(newIndex, element);
                                    });
                                  }
                                }),
                          ),
                        ),
                  Visibility(
                    visible: widget.isEdit ? false : true,
                    child: videoFile != null
                        ? SizedBox(
                            height: SizeConfig.screenHeight * .28,
                            // color: Colors.black,
                            child: VideoApp(
                              mListener: this,
                              videoUrl: videoFile,
                            ))
                        : Container(),
                  ),

                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: TextField(
                        autocorrect: false,
                        enableSuggestions: false,
                        controller: controller.albumText,
                        maxLines: 1,
                        minLines: 1,
                        style: TextStyle(color: hp.theme.secondaryHeaderColor),
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: hp.theme.secondaryHeaderColor)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: hp.theme.secondaryHeaderColor)),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: hp.theme.secondaryHeaderColor)),
                            hintText: "Enter Album Name",
                            hintStyle:
                                TextStyle(color: hp.theme.indicatorColor))),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: TextField(
                        autocorrect: false,
                        enableSuggestions: false,
                        controller: controller.tec,
                        // maxLines: null,
                        minLines: 1,
                        style: TextStyle(color: hp.theme.secondaryHeaderColor),
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: hp.theme.secondaryHeaderColor)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: hp.theme.secondaryHeaderColor)),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: hp.theme.secondaryHeaderColor)),
                            hintText: "Share Your Legacy",
                            hintStyle:
                                TextStyle(color: hp.theme.indicatorColor))),
                  ),
                  const SizedBox(height: 12),
                  selectedAudienceType == "TRIBE"
                      ? selectedTibesList.isNotEmpty
                          ? gridViewContainer(
                              context, selectedTibesList, "SelectedTribe")
                          : Container()
                      : Container(
                          height: 10,
                        ),
                  const SizedBox(height: 12),
                  selectedAudienceType == "TRIBE"
                      ? gridViewContainer(context, tribesList, "Tribe")
                      : Container(height: 10, color: Colors.transparent),
                  const SizedBox(height: 12),
                  GestureDetector(
                      child: Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 8,
                              ),
                              Icon(Icons.photo_library,
                                  color: hp.theme.secondaryHeaderColor),
                              const SizedBox(
                                width: 12,
                              ),
                              Text("Photo/video",
                                  style: TextStyle(
                                      color: hp.theme.secondaryHeaderColor,
                                      fontSize: 17)),
                              const SizedBox(
                                width: 12,
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                              color: hp.theme.highlightColor,
                              border: Border.all(
                                  color: hp.theme.secondaryHeaderColor),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          padding:
                              EdgeInsets.symmetric(vertical: hp.height / 50),
                          margin: EdgeInsets.symmetric(
                              vertical: hp.height / 40,
                              horizontal: hp.width / 25)),
                      onTap: () {
                        print(
                            "imagesListSendtoserver  ${imagesListSendtoserver.length}");
                        if (mounted) {
                          setState(() {
                            if (widget.isEdit) {
                              comeFrom = "";
                              imagesList.clear();
                            }
                            // comeFrom = "";
                            /*if(isMixPosting) {
                              imagesList.clear();
                            }git*/
                            widget.file = "";
                            imagePicker.showDialog(context);
                          });
                        }
                      }),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Checkbox(
                        value: rememberMe,
                        activeColor: Colors.blue,
                        onChanged: _onRememberMeChanged,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "I agree that this post follows the",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: SizeConfig.safeBlockHorizontal * 4.0),
                          ),
                          GestureDetector(
                            onDoubleTap: () {},
                            onTap: () {
                              settingContentAPi("EULA");
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: SizeConfig.screenHeight * .005),
                              child: Text(
                                "community guidelines",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize:
                                        SizeConfig.safeBlockHorizontal * 4.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ])),
                flag
                    ? Container()
                    : Container(
                        height: hp.height,
                        width: hp.width,
                        color: Colors.black87,
                        child: const SpinKitFoldingCube(color: Colors.white),
                      )
              ],
            )));
  }

  bool rememberMe = false;

  void _onRememberMeChanged(bool newValue) => setState(() {
        rememberMe = newValue;
        print("rememberMe    $rememberMe");
      });

  List<Asset> images = <Asset>[];

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: const CupertinoOptions(
          takePhotoIcon: "chat",
          doneButtonTitle: "Fatto",
        ),
        materialOptions: const MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {}

    if (!mounted) return;

    setState(() {
      images = resultList;
    });
  }

  ContentResponseModel contentModel;

  settingContentAPi(String text) async {
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    userController = UserController(context, state);
    final prefs = await controller.sharedPrefs;
    final hp = controller.hp;
    if (mounted) {
      setState(() {
        flag = false;
      });
    }

    await userController.waitUntilGetContent(text).then((value) {
      contentModel = userController.contentModel;
      if (contentModel.responseData.content.description.isNotEmpty) {
        if (mounted) {
          setState(() {
            flag = true;

            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AboutUsPage(
                        data: contentModel.responseData.content.description,
                        titleText: contentModel.responseData.content.title,
                      )),
            );
            //didGetResponse = true;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final state =
        context.findAncestorStateOfType<GetBuilderState<PostController>>() ??
            GetBuilderState<PostController>();
    return GetBuilder<PostController>(
        didChangeDependencies: didChange,
        builder: pageBuilder,
        init: PostController(context, state));
  }

  @override
  userImage(XFile _image) {
    // TODO: implement userImage
    print("file....... $_image");
    if (mounted) {
      setState(() {
        comeFrom = "1";
        if (_image != null) {
          image = _image;
        } else {
          //print('No image selected.');
        }
      });
    }
  }

  @override
  userImageForGallery(List<File> _image) {
    // TODO: implement userImageForGallery
    if (mounted) {
      setState(() {
        comeFrom = "2";
        if (_image.length != null) {
          print("lengthhh    ${_image.length}  ${imagesList.length}");

          if (widget.isEdit) {
            //imagesListSendtoserver.insertAll(localOne, _image);
            imagesList = _image;
            // imagesList.addAll(_image);
            print("ediiiii    ${imagesListSendtoserver.length}");
          } else {
            print("kkkkk  ${imagesList.length}");
            if (videoFile != null) {
              imagesList.clear();
              imagesList.addAll(_image);
              imagesList.insert(localIndex + 1, videoFile);
              isMixPosting = true;
            } else {
              print("hhhhhh");
              imagesList = _image;
              //imagesList.add(_image);
            }
          }
        } else {
          //print('No image selected.');
        }
      });
    }
  }

  bool isMixPosting = false;

  File videoFile;
  @override
  userVideo(File _image) {
    // TODO: implement userVideo
    print("_image.......   ${_image}");

    if (mounted) {
      setState(() {
        comeFrom = "3";

        if (_image != null) {
          videoFile = _image;
          if (!widget.isEdit) {
            if (imagesList.isNotEmpty) {
              imagesList.insert(localIndex + 1, _image);
              isMixPosting = true;
            } else {
              imagesList.add(_image);
            }

            //comeFrom = "4";

          }
        } else {
          // print('No image selected.');
        }
      });
    }
  }

  File thumb;

  @override
  sendFile(File thumbUrl) {
    // TODO: implement sendFile
    print("thumbUrl...... $thumbUrl");
    if (thumbUrl != null) {
      if (mounted) {
        setState(() {
          thumb = thumbUrl;
          /*  if(isMixPosting){
            imagesList.insert(localIndex + 1, thumbUrl);
          }else{
            imagesList.add(thumbUrl);
          }*/
        });
      }
    }
  }
}

abstract class UploadPostPageInterface {
  apiCallFunction();
}
