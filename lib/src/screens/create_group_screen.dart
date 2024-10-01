import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../size_config.dart';
import '../controllers/user_controller.dart';
import '../helpers/helper.dart';
import '../image_picker_handler.dart';
import '../utils/common_color.dart';
import '../utils/constant_class.dart';
import 'create_group_user_list_class.dart';
import 'main_screen.dart';

class CreateGroupScreen extends StatefulWidget {
  final List<SelectUser> list;
  const CreateGroupScreen({Key key, this.list}) : super(key: key);

  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> with  TickerProviderStateMixin, ImagePickerListener {


  bool flag=true;
  TextEditingController msgController = TextEditingController();
  UserController controller;
  final picker = ImagePicker();
  XFile image;

  ImagePickerHandler imagePicker;
  AnimationController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    imagePicker = ImagePickerHandler(this, _controller,"2");
    imagePicker.init();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    return pageBuilder(UserController(context, state));
  }


  Future createGroupApi(people,String text) async {
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    controller = UserController(context, state);
    final prefs = await controller.sharedPrefs;
    final obj = {
      "userId": prefs.getString("spUserID"),
      "chatName": text,
      "appType": prefs.getString("spAppType"),
      "users": people,
    };
    setState(() {
      // flag = false;

    });
   // print(obj);
    controller.waitUntilCreateGroupMsg(obj).then((value) {
     // print("groupIdlocal   ${controller.groupIdlocal}");

      if(controller.sucessCode==200){
        if(image!=null){
          final body = {
            "group_id":controller.groupIdlocal
          };
          controller.waitUntilUploadGroupPhoto(body,image.path).then((value) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const MainScreen()
                ));

          });
        }else{
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const MainScreen()
              ));
        }
      }
      if(controller.sucessCode==400){
        Helper.showToast("Group name must be unique");
      }




    });
  }

  Widget pageBuilder(UserController con) {
    final hp = con.hp;

    hp.lockScreenRotation();
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            foregroundColor: Colors.white,
            backgroundColor: Colors.black,
            title: getCustomAppBar(
                SizeConfig.screenHeight, SizeConfig.screenWidth),
          ),
          body: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Column(
                children: [
                 Padding(
                   padding:  EdgeInsets.only(left: SizeConfig.screenWidth*.05),
                   child: Row(
                     children: [
                       GestureDetector(
                         onTap: (){
                           imagePicker.showDialog(context);
                         },
                         onDoubleTap: (){},
                         child: Stack(
                           children: <Widget>[
                             Container(
                                 decoration: BoxDecoration(
                                   shape: BoxShape.circle,
                                   border: Border.all(
                                       color: hp.theme
                                           .secondaryHeaderColor,
                                       width: 1),
                                   image: const DecorationImage(
                                       fit: BoxFit.fill,
                                       image: AssetImage(
                                           "assets/images/noimage.png")),
                                 ),
                                 height: SizeConfig.screenHeight*.055,
                                 width: SizeConfig.screenHeight*.055,
                                 margin: EdgeInsets.only(
                                     right: hp.width / 32)
                             ),
                             Container(
                                 child: image!=null?ClipOval(

                                   child: Image.file(
                                     File(image.path),
                                     fit: BoxFit.fitWidth,
                                   ),
                                 ):Container(),
                                 decoration: BoxDecoration(

                                   shape: BoxShape.circle,
                                   border: Border.all(
                                       color: hp.theme
                                           .secondaryHeaderColor,
                                       width: hp.width / 100),
                                 ),
                                 height: SizeConfig.screenHeight*.055,
                                 width: SizeConfig.screenHeight*.055,

                             ),
                           ],
                         ),
                       ),
                       Expanded(
                         child: TextFormField(
                           autocorrect: false,
                           enableSuggestions: false,
                           controller: msgController,
                           maxLines: null,
                           showCursor: true,
                           cursorWidth: 1.0,

                           style: TextStyle(
                               color: hp.theme.secondaryHeaderColor),


                           decoration: const InputDecoration(



                             /*border: OutlineInputBorder(
                                 borderSide:  BorderSide(color: Colors.teal)
                             ),
                             focusedBorder:OutlineInputBorder(
                                 borderSide:  BorderSide(color: Colors.grey)
                             ) ,*/
                           //  labelStyle: TextStyle(color: Colors.white),
                             hintText: "Type group name...",
                             helperStyle: TextStyle(color: Colors.white),


                           ),
                           cursorColor: Colors.black,
                         ),
                       ),
                     ],
                   ),
                 ),
                  Padding(
                    padding:  EdgeInsets.only(top: SizeConfig.screenHeight*.015,left: SizeConfig.screenWidth*.02),
                    child: Text(
                      "Provide a group subject and optional group icon",
                      style: TextStyle(
                          color:
                          hp.theme.secondaryHeaderColor,
                          fontSize: SizeConfig
                              .blockSizeHorizontal *
                              3.5),
                      textScaleFactor: 1.1,
                    ),
                  ),


                  Padding(
                    padding:  EdgeInsets.only(top: SizeConfig.screenHeight*.07,left: SizeConfig.screenWidth*.02),
                    child: Row(
                      children: [
                        Text(
                          "Participants:",
                          style: TextStyle(
                              color:
                              hp.theme.secondaryHeaderColor,
                              fontSize: SizeConfig
                                  .blockSizeHorizontal *
                                  3.8),
                          textScaleFactor: 1.1,
                        ),
                        Text(
                          widget.list.length.toString(),
                          style: TextStyle(
                              color:
                              hp.theme.secondaryHeaderColor,
                              fontSize: SizeConfig
                                  .blockSizeHorizontal *
                                  3.5),
                          textScaleFactor: 1.1,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.only(top: SizeConfig.screenHeight*.02,left: SizeConfig.screenWidth*.03,
                        right: SizeConfig.screenWidth*.03),
                    child: Container(
                      height: SizeConfig.screenHeight*.1,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        // controller: _scrollController,
                        itemCount: widget.list.length,
                        itemBuilder: (context, index) {

                          return Column(
                            children: [
                              Stack(
                                children: <Widget>[
                                  Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: hp.theme
                                                .secondaryHeaderColor,
                                            width: 1),
                                        image: const DecorationImage(
                                            fit: BoxFit.fill,
                                            image: AssetImage(
                                                "assets/images/noimage.png")),
                                      ),
                                      height: hp.height / 14,
                                      width: hp.width / 7,
                                      margin: EdgeInsets.only(
                                          right: hp.width / 32)),
                                  Container(
                             child: AspectRatio(
                               aspectRatio: 1 / 1,
                               child: ClipOval(
                                   child: FadeInImage.assetNetwork(
                                       fit: BoxFit.fill,
                                       placeholder:
                                       'assets/images/noimage.png',
                                       image: Constant.userPicServerUrl+ widget.list.elementAt(index).profilePic)),
                             ),
                             decoration: BoxDecoration(
                               shape: BoxShape.circle,
                               border: Border.all(
                                   color: hp.theme
                                       .secondaryHeaderColor,
                                   width: hp.width / 100),
                             ),
                             height: hp.height / 14,
                             width: hp.width / 7,
                             margin: EdgeInsets.only(
                                 right: hp.width / 32)),
                                ],
                              ),
                              Text(
                                widget.list.elementAt(index).name,
                                style: TextStyle(
                                    color:
                                    hp.theme.secondaryHeaderColor,
                                    fontSize: SizeConfig
                                        .blockSizeHorizontal *
                                        3.5),
                                textScaleFactor: 1.1,
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: (){
                  FocusScope.of(context).requestFocus(FocusNode());

                  bool status =true;
                  //var id='';
                  List<String> list=[];
                 /* var tribeID = "";
                  var people = "";*/

                  if(mounted){
                    setState(() {
                      if(msgController.text.isEmpty){
                        status=false;
                        Helper.showToast("Please enter group name");

                      }if(widget.list.isNotEmpty){
                    
                        for (var ele in widget.list){
                          list.add(ele.id);
                         // familyMemberGender.add(familyMember["gender"]);
                          //print(familyMemberName);
                        }
                        json.encode(list);

                      }
                  //     print("id...   ${json.encode(list)}");


                      if(status){
                       createGroupApi(list,
                           msgController.text);


                      }
                    });
                  }

               /*   Navigator.push(
                    hp.context,
                    MaterialPageRoute(builder: (context) => const CreateGroupScreen()),
                  );*/
                },
                onDoubleTap: (){},
                child: Padding(
                  padding:  EdgeInsets.only(bottom: SizeConfig.screenHeight*.02,right: SizeConfig.screenWidth*.02),
                  child: Container(
                    height: SizeConfig.screenHeight*.055,
                    width: SizeConfig.screenHeight*.055,
                    decoration: BoxDecoration(
                        color: CommonColor.goldenColor,
                        shape: BoxShape.circle
                    ),
                    child: Icon(Icons.arrow_forward,color: Colors.white,),
                  ),
                ),
              )
            ],
          )
        ),
        flag
            ? Container()
            : Container(
          height: hp.height,
          width: hp.width,
          color: Colors.black87,
          child: const SpinKitFoldingCube(color: Colors.white),
        )
      ],
    );
  }


  Widget getCustomAppBar(double parentHeight, double parentWidth) {
    return Row(
      children: [
        Text(
          "New group",
          style: TextStyle(
              color: Colors.white,
              fontSize: SizeConfig.blockSizeHorizontal * 4.2),
          textScaleFactor: 1.0,
        )
      ],
    );
  }

  @override
  userImage(XFile _image) {
    // TODO: implement userImage
    //print("file....... $_image");
    if (mounted) {
      setState(() {
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
  }

  @override
  userVideo(File _image) {
    // TODO: implement userVideo
  }
}
