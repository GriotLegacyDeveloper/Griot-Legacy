import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:get/get.dart';
import 'package:griot_legacy_social_media_app/size_config.dart';
import 'package:griot_legacy_social_media_app/src/controllers/post_controller.dart';
import 'package:griot_legacy_social_media_app/src/controllers/user_controller.dart';
import 'package:griot_legacy_social_media_app/src/helpers/helper.dart';
import 'package:griot_legacy_social_media_app/src/models/alluserlistmodel.dart';
import 'package:griot_legacy_social_media_app/src/widgets/my_button.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:multi_select_item/multi_select_item.dart';

import '../models/selction_model.dart';
import 'all_user_list_dialog.dart';

final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();

class CreateTribeScreen extends StatefulWidget {
  const CreateTribeScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CreateTribeScreenState();
  }
}

StateSetter setStateInternal;

// ignore: prefer_typing_uninitialized_variables
var imagePath;

class CreateTribeScreenState extends State<CreateTribeScreen>
    with AllUserListTribeDiloagInterface {
  TextEditingController tribeNameController = TextEditingController();
  TextEditingController addPeopleController = TextEditingController();
  String dropdownValue = "Tribe";
  final _formKey = GlobalKey<FormState>();
  var image;
  final picker = ImagePicker();
  bool loaderFlag = true;
  bool flag = true;
  List<bool> isValidated = [true, true, true];
  bool changeDetected = false;
  bool displayImageOptions = false;
  bool loaderStatus = true;
  bool didGetResponse = false;
  bool isSelecte = false;

  List<SelectionModel> _selectedList = <SelectionModel>[];

  AllUserListModel allUserData;
  List<AllUserData> dataList = <AllUserData>[];
  var firstCamera;
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  PostController controller;
  List selectedTribeName = [];
  List selectedTribeID = [];
  List items = [];
  //List itemsLocal = [];
  MultiSelectController multiSelectcontroller = MultiSelectController();
  List multiSelectList = [];
  int indexLocal;

  @override
  void initState() {
    super.initState();
    //  initializeCamera();

    getAllUser();
  }

  Widget _tagBuildingWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: SizeConfig.screenHeight * .03),
      child: Container(
        height: _selectedList.length > 4
            ? SizeConfig.screenHeight * .15
            : SizeConfig.screenHeight * .08,
        color: Colors.transparent,
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3.0,
                mainAxisSpacing: 0.0,
                crossAxisSpacing: 1.0),
            itemCount: _selectedList.length,
            //scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        //print("_selectedList.length   ${_selectedList.length}");
                        for (int i = 0;
                            i < allUserData.responseData.data.length;
                            i++) {
                          if (_selectedList.elementAt(index).id ==
                              allUserData.responseData.data
                                  .elementAt(i)
                                  .userId) {
                            if (mounted) {
                              setState(() {
                                allUserData.responseData.data[i].isSelected =
                                    false;
                              });
                            }
                            /* print("hhhhh ${_selectedList.elementAt(index).id} ${allUserData.responseData.data.elementAt(i).userId} ${allUserData.responseData.data.elementAt(i).isSelected}");*/

                          }
                        }
                        if (mounted) {
                          setState(() {
                            _selectedList.removeAt(index);
                          });
                        }
                        //if(_selectedList.contains(allUserData.responseData.data.elementAt(index).userId))

                        /*for(int i; i <=allUserData.responseData.data.length;i++){
                     print("selcttt   ${dataList.elementAt(i).isSelected}");
                   }*/
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Row(
                          children: [
                            Text(
                              _selectedList.elementAt(index).name,
                              style: TextStyle(
                                  fontSize:
                                      SizeConfig.safeBlockHorizontal * 4.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: SizeConfig.screenWidth * .02),
                              child: Icon(
                                Icons.cancel,
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
    /* return Container(
        margin: (items.isNotEmpty)
            // ignore: prefer_const_constructors
            ? EdgeInsets.only(top: 32, left: 8, right: 8)
            : const EdgeInsets.only(top: 16, left: 8, right: 8),
        child: Tags(
          key: _tagStateKey,
          itemCount: items.length,
          itemBuilder: (int index) {
            return ItemTags(
              border: Border.all(color: Colors.white, width: 0.5),
              alignment: MainAxisAlignment.start,
              // activeColor: Color(0xFFFF8527),
              combine: ItemTagsCombine.withTextAfter,
              textActiveColor: Colors.white,
              activeColor: Colors.black,
              key: Key(index.toString()),
              index: index,
              title: items[index],
              textStyle: const TextStyle(
                //color: Colors.white,
                fontSize: 17,
                fontStyle: FontStyle.normal,
              ),
              removeButton: ItemTagsRemoveButton(
                backgroundColor: CommonColor.Boxcolors,
                color: Colors.black,
                onRemoved: () {
                  print("hhhh");
                  setState(() {
                    items.removeAt(index);
                    selectedTribeName.removeAt(index);
                    selectedTribeID.removeAt(index);
                    print("iffffff  $selectedTribeID");

                  });
                  //required
                  return true;
                },
              ),
              onPressed: (item) {
                print("bbbbb");
              },
              onLongPressed: (item) {},
            );
          },
        ),
      );*/
  }

  getAllUser() async {
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
    // print(obj);
    controller.waitUntilGetAllUserList(obj).then((value) {
      setState(() {
        loaderStatus = true;
        allUserData = controller.allUserModelData;
        didGetResponse = true;
        for (var index = 0;
            index < allUserData.responseData.data.length;
            index++) {
          multiSelectList.add({
            "images": allUserData.responseData.data[index].profileImage,
            "desc": allUserData.responseData.data[index].fullName
          });
        }
        multiSelectcontroller.disableEditingWhenNoneSelected = true;
        multiSelectcontroller.set(multiSelectList.length);
      });
    });
  }

  void add() {
    multiSelectList.add({"images": multiSelectList.length});
    multiSelectList.add({"desc": multiSelectList.length});

    setState(() {
      multiSelectcontroller.set(multiSelectList.length);
    });
  }

  void delete() {
    var list = multiSelectcontroller.selectedIndexes;
    list.sort((b, a) => a.compareTo(b));
    list.forEach((element) {
      multiSelectList.removeAt(element);
    });

    setState(() {
      multiSelectcontroller.set(multiSelectList.length);
    });
  }

  void selectAll() {
    setState(() {
      multiSelectcontroller.toggleAll();
    });
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        //  print('No image selected.');
      }
    });
  }

  Future initializeCamera() async {
    await fetchCamera();
    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  Future fetchCamera() async {
    final cameras = await availableCameras();
    setState(() {
      firstCamera = cameras[1];
    });
  }

  void didChange(GetBuilderState<UserController> state) {
    state.controller.hp.lockScreenRotation();
  }

  Widget setupAlertDialoadContainer(BuildContext context, UserController con) {
    final hp = con.hp;

    return StatefulBuilder(// You need this, notice the parameters below:
        builder: (BuildContext context, StateSetter setState) {
      return SizedBox(
          height: hp.height, // Change as per your requirement
          width: hp.width - 100, // Change as per your requirement
          child: didGetResponse
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        margin: const EdgeInsets.only(left: 4, right: 4),
                        padding: const EdgeInsets.only(bottom: 16),
                        height: hp.height - 240,
                        child: ListView.builder(
                          itemCount: multiSelectList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Container(
                                color: /*selectedTribeID.contains(allUserData
                            .responseData.data[index].userId)*/
                                    multiSelectcontroller.isSelected(index)
                                        ? Colors.grey.shade200
                                        : Colors.white,
                                height: 55,
                                child: GestureDetector(
                                  onTap: () {
                                    print(
                                        "isSelecte ${allUserData.responseData.data[index].isSelected}");
                                    if (mounted) {
                                      setState(() {
                                        indexLocal = index;
                                        if (selectedTribeID.contains(allUserData
                                            .responseData.data[index].userId)) {
                                          if (allUserData.responseData
                                              .data[index].isSelected) {
                                            //  print("iffffff");
                                            selectedTribeName.remove(allUserData
                                                .responseData
                                                .data[index]
                                                .fullName);
                                            items.remove(allUserData
                                                .responseData
                                                .data[index]
                                                .fullName);
                                            if (mounted) {
                                              setState(() {
                                                allUserData
                                                    .responseData
                                                    .data[index]
                                                    .isSelected = false;
                                              });
                                            }
                                            selectedTribeID.remove(allUserData
                                                .responseData
                                                .data[index]
                                                .userId);

                                            print(
                                                "itemsLocaliffff ${selectedTribeID.length}");
                                          }
                                        } else {
                                          //print("elsssss");
                                          //multiSelectcontroller.isSelected(index);
                                          if (!allUserData.responseData
                                              .data[index].isSelected) {
                                            selectedTribeName.add(allUserData
                                                .responseData
                                                .data[index]
                                                .fullName);
                                            items.add(allUserData.responseData
                                                .data[index].fullName);
                                            if (mounted) {
                                              setState(() {
                                                allUserData
                                                    .responseData
                                                    .data[index]
                                                    .isSelected = true;
                                              });
                                            }

                                            selectedTribeID.add(allUserData
                                                .responseData
                                                .data[index]
                                                .userId);

                                            /*print(
                                        "itemsLocalelsss ${selectedTribeID.length}");*/
                                          }
                                        }
                                        multiSelectcontroller.toggle(index);
                                      });
                                    }

                                    setState(() {});
                                  },
                                  child: Row(
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                            decoration: const BoxDecoration(
                                                //color: Colors.blue,
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/images/dummy.jpeg'))),
                                            height:
                                                SizeConfig.screenHeight * .07,
                                            width:
                                                SizeConfig.screenHeight * .07,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              //color: Colors.blue,
                                              shape: BoxShape.circle,
                                              image: allUserData
                                                          .responseData
                                                          .data[index]
                                                          .profileImage !=
                                                      null
                                                  ? DecorationImage(
                                                      image: NetworkImage(
                                                          allUserData
                                                                  .responseData
                                                                  .userImageUrl +
                                                              allUserData
                                                                  .responseData
                                                                  .data[index]
                                                                  .profileImage),
                                                      fit: BoxFit.fitWidth)
                                                  : const DecorationImage(
                                                      image: const AssetImage(
                                                          "assets/images/dummy.jpeg")),
                                            ),
                                            height:
                                                SizeConfig.screenHeight * .07,
                                            width:
                                                SizeConfig.screenHeight * .07,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      Expanded(
                                          child: Text(allUserData.responseData
                                              .data[index].fullName)),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(4),
                      child: MaterialButton(
                        color: hp.theme.primaryColor,
                        onPressed: () {
                          Navigator.of(context).pop();
                          /*   setState(() {

                  });*/
                        },
                        child: Text(
                          "Done",
                          style:
                              TextStyle(color: hp.theme.secondaryHeaderColor),
                        ),
                      ),
                    )
                  ],
                )
              : Container());
    });
  }

  Widget pageBuilder(UserController controller) {
    final hp = controller.hp;
    return Container(
      color: Colors.black,
      child: SafeArea(
          child: Scaffold(
              backgroundColor: hp.theme.primaryColor,
              body: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: hp.width * 0.05),
                    child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: hp.height / 50),
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Container(
                                      height: SizeConfig.screenHeight * .17,
                                      // width: SizeConfig.screenHeight *.14,
                                      color: Colors.transparent,

                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Stack(
                                            children: <Widget>[
                                              Container(
                                                height:
                                                    SizeConfig.screenHeight *
                                                        .13,
                                                width: SizeConfig.screenHeight *
                                                    .13,
                                                decoration: BoxDecoration(
                                                    image: const DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image: AssetImage(
                                                            "assets/images/tribe_placeholder.jpg")),
                                                    border: Border.all(
                                                        color: hp.theme
                                                            .selectedRowColor,
                                                        width: 2),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                10.0))),
                                              ),
                                              Container(
                                                height:
                                                    SizeConfig.screenHeight *
                                                        .13,
                                                width: SizeConfig.screenHeight *
                                                    .13,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: hp.theme
                                                          .selectedRowColor,
                                                      width: 2),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(
                                                              10.0)),
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: FileImage(
                                                        image ?? File(''),
                                                      ) /* _image!=null?  FileImage(_image,) :
                                                    NetworkImage(profileImage),*/
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white),
                                      child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              displayImageOptions =
                                                  !displayImageOptions;
                                            });
                                          },
                                          icon: Icon(
                                            Icons.camera_alt_rounded,
                                            color: Colors.black,
                                            size: hp.height * 0.028,
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                              !displayImageOptions
                                  ? Container()
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        MyButton(
                                            label: "Take Photo",
                                            labelWeight: FontWeight.w500,
                                            onPressed: () async {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              final pickedFile =
                                                  await picker.getImage(
                                                      source:
                                                          ImageSource.camera);
                                              setState(() {
                                                if (pickedFile != null) {
                                                  image = File(pickedFile.path);
                                                } else {
                                                  //  print('No image selected.');
                                                }
                                              });
                                              /* Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          Camera(firstCamera,
                                                              hp.theme)))
                                                  .then((value) {
                                                setState(() {
                                                  if (imagePath != "") {
                                                    _image = imagePath;
                                                    imagePath = "";
                                                  }
                                                });
                                              });*/
                                            },
                                            heightFactor: 50,
                                            widthFactor: 16,
                                            radiusFactor: 160),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: hp.width * 0.02)),
                                        MyButton(
                                            label: "  Upload  ",
                                            labelWeight: FontWeight.w500,
                                            onPressed: () async {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              getImage();
                                            },
                                            heightFactor: 50,
                                            widthFactor: 14,
                                            radiusFactor: 160),
                                      ],
                                    ),
                              Padding(
                                  padding: EdgeInsets.only(top: hp.height / 50),
                                  child: TextFormField(
                                      autocorrect: false,
                                      enableSuggestions: false,
                                      // ignore: missing_return
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          isValidated[0] = false;
                                          return "Name can't be empty";
                                        } else {
                                          isValidated[0] = true;
                                        }
                                      },
                                      onChanged: (value) {
                                        setState(() {
                                          changeDetected = true;
                                        });
                                      },
                                     /* inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp('[a-z A-Z 0-9 ]'))
                                      ],*/
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      decoration: InputDecoration(
                                          counterText: "",
                                          enabledBorder:
                                              const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0)),
                                            // borderSide: BorderSide(color: Colors.red, width: 2),
                                          ),
                                          focusedBorder:
                                              const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0)),
                                            //borderSide: BorderSide(color: Colors.red),
                                          ),
                                          filled: true,
                                          fillColor: hp.theme.cardColor,
                                          hintStyle: TextStyle(
                                              color:
                                                  hp.theme.primaryColorLight),
                                          // enabledBorder: OutlineInputBorder(),
                                          prefixIcon: Icon(
                                              Icons.people_alt_outlined,
                                              color:
                                                  hp.theme.primaryColorLight),
                                          contentPadding: EdgeInsets.only(
                                              left: hp.width / 40,
                                              top: hp.height / 50,
                                              bottom: hp.height / 50),
                                          border: InputBorder.none,
                                          hintText: "Tribe Name"),
                                     // keyboardType: TextInputType.name,
                                      style: TextStyle(
                                          color: hp.theme.secondaryHeaderColor),
                                      controller: tribeNameController)),
                              Padding(
                                  padding: EdgeInsets.only(top: hp.height / 40),
                                  child: DropdownButtonFormField<String>(
                                      dropdownColor: hp.theme.cardColor,
                                      decoration: InputDecoration(
                                          enabledBorder:
                                              const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0)),
                                            // borderSide: BorderSide(color: Colors.red, width: 2),
                                          ),
                                          focusedBorder:
                                              const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0)),
                                            //borderSide: BorderSide(color: Colors.red),
                                          ),
                                          filled: true,
                                          fillColor: hp.theme.cardColor,
                                          hintStyle: TextStyle(
                                              color:
                                                  hp.theme.primaryColorLight),
                                          contentPadding: EdgeInsets.only(
                                              left: hp.width / 40,
                                              top: hp.height / 50,
                                              bottom: hp.height / 50),
                                          border: InputBorder.none,
                                          hintText: "Tribe Type"),
                                      value: dropdownValue,
                                      onChanged:
                                          controller.onChangedRelationStatus,
                                      items: <String>["Tribe", "INNERCIRCLE"]
                                          .map((e) => DropdownMenuItem<String>(
                                              onTap: () {
                                                controller
                                                    .onChangedRelationStatus(e);
                                                setState(() {
                                                  dropdownValue = e;
                                                  print(
                                                      "dropdownValue   $dropdownValue");
                                                });
                                              },
                                              value: e,
                                              child: Text(e.capitalizeFirst,
                                                  style: TextStyle(
                                                      color: hp.theme
                                                          .secondaryHeaderColor))))
                                          .toList())),
                              Padding(
                                  padding: EdgeInsets.only(top: hp.height / 50),
                                  child: TextField(
                                      readOnly: true,
                                      onTap: () {
                                        print("hhhhh");
                                        (allUserData.responseData.data.isEmpty)
                                            ? Helper.showToast("No User Found")
                                            : showDialog(
                                                context: context,
                                                barrierColor:
                                                    Colors.transparent,
                                                builder: (
                                                  BuildContext context,
                                                ) {
                                                  return AllUserListTribeDiloag(
                                                    mListenr: this,
                                                    allUserData: allUserData,
                                                    selctionList: _selectedList,
                                                  );
                                                  /*AlertDialog(
                                                        elevation: 1,
                                                        title: const Text(
                                                            'Tribe User List'),
                                                        content:
                                                            setupAlertDialoadContainer(
                                                                context,
                                                                controller),
                                                      );*/
                                                });
                                        setState(() {});
                                      },
                                      decoration: InputDecoration(
                                          enabledBorder:
                                              const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0)),
                                            // borderSide: BorderSide(color: Colors.red, width: 2),
                                          ),
                                          focusedBorder:
                                              const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0)),
                                            //borderSide: BorderSide(color: Colors.red),
                                          ),
                                          filled: true,
                                          fillColor: hp.theme.cardColor,
                                          hintStyle: TextStyle(
                                              color:
                                                  hp.theme.primaryColorLight),
                                          // enabledBorder: OutlineInputBorder(),
                                          prefixIcon: Icon(
                                              Icons.person_outlined,
                                              color:
                                                  hp.theme.primaryColorLight),
                                          contentPadding: EdgeInsets.only(
                                              left: hp.width / 40,
                                              top: hp.height / 50,
                                              bottom: hp.height / 50),
                                          border: InputBorder.none,
                                          hintText: "Add People"),
                                      keyboardType: TextInputType.name,
                                      style: TextStyle(
                                          color: hp.theme.secondaryHeaderColor),
                                      controller: addPeopleController)),
                              _tagBuildingWidget(context),
                              Padding(
                                padding: EdgeInsets.only(top: hp.height / 30),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: MyButton(
                                      label: "Submit",
                                      labelWeight: FontWeight.w500,
                                      onPressed: () async {
                                        print(
                                            "tribeList    ${_selectedList.length}");
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        //  print(controller.dobc.text);
                                        if (!isValidated.contains(false) &&
                                            changeDetected) {
                                          print("iffff");

                                          var tribeID = "";
                                          var people = "";
                                          final prefs =
                                              await controller.sharedPrefs;

                                          if (_selectedList.isEmpty) {
                                            Helper.showToast(
                                                "At least add one people in tribe");

                                            /* people =
                                                prefs.getString("spUserID") ?? "";*/
                                          } else {
                                            for (var i = 0;
                                                i < _selectedList.length;
                                                i++) {
                                              tribeID = tribeID +
                                                  _selectedList
                                                      .elementAt(i)
                                                      .id +
                                                  ",";
                                            }
                                            tribeID = tribeID.substring(
                                                0, tribeID.length - 1);
                                            people = tribeID;
                                            print("people    $people");
                                            setState(() {
                                              loaderFlag = false;
                                            });

                                            final body = {
                                              "userId":
                                                  prefs.getString("spUserID") ??
                                                      "",
                                              "loginId": prefs
                                                      .getString("spLoginID") ??
                                                  "",
                                              "appType": prefs
                                                      .getString("spAppType") ??
                                                  "",
                                              "name": tribeNameController.text,
                                              'type': dropdownValue,
                                              'people': people
                                            };
                                            print(body);
                                            await controller
                                                .waitUntilCreateTribe(
                                                    body, image)
                                                .then((value) {
                                              Future.delayed(
                                                  const Duration(
                                                      milliseconds: 100), () {
                                                setState(() {
                                                  loaderFlag = true;
                                                });
                                                if (value) {
                                                  Navigator.pop(context);
                                                }
                                              });
                                            });
                                          }
                                        } else {
                                          Helper.showToast(
                                              "Please Enter tribe name and add add at least one people");
                                        }
                                      },
                                      heightFactor: 50,
                                      widthFactor: 3.2,
                                      radiusFactor: 160),
                                ),
                              )
                            ],
                          ),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: hp.width / 40)),
                  ),
                  loaderFlag
                      ? Container()
                      : Container(
                          height: hp.height,
                          width: hp.width,
                          color: Colors.black87,
                          child: const SpinKitFoldingCube(color: Colors.white),
                        )
                ],
              ),
              appBar: AppBar(
                backgroundColor: hp.theme.primaryColor,
                foregroundColor: hp.theme.secondaryHeaderColor,
                title: const Text("Create Tribe"),
                /* Image.asset("assets/images/title.png",
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.fill,
                    width: hp.width / 3.2,
                    height: hp.height / 40),*/
                /*  actions: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: hp.width * 0.04),
                    child: CircleAvatar(
                        child: const Icon(
                          Icons.notifications_rounded,
                          color: Colors.white,
                        ),
                        backgroundColor: Colors.white24,
                        foregroundColor: hp.theme.primaryColor),
                  )
                ],*/
              ))),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    return GetBuilder<UserController>(
        didChangeDependencies: didChange,
        builder: pageBuilder,
        init: UserController(context, state));
  }

  @override
  addFunction(list, selctTribName, AllUserListModel model,
      List<SelectionModel> multiSelect) {
    // TODO: implement addFunction
    print("length   ${multiSelect.length}");
    setState(() {
      _selectedList.clear();
      _selectedList.addAll(multiSelect);
    });
  }
}

//-------------------------Camera---------------------------------------------

class Camera extends StatefulWidget {
  final firstCamera;
  final theme;
  const Camera(this.firstCamera, this.theme);

  @override
  CameraState createState() => CameraState();
}

class CameraState extends State<Camera> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  String img = '';
  File imageFile;
  var firstCamera;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future initializeCamera() async {
    await fetchCamera();
    _controller = CameraController(
      widget.firstCamera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  Future fetchCamera() async {
    final cameras = await availableCameras();
    setState(() {
      firstCamera = cameras.first;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: widget.theme.primaryColor,
        appBar: AppBar(
          backgroundColor: widget.theme.primaryColor,
          foregroundColor: widget.theme.secondaryHeaderColor,
          title: const Text("Take Photo"),
        ),
        body: img != ''
            ? Column(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.file(File(img)),
                  Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.005)),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                img = '';
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.49,
                              height: MediaQuery.of(context).size.height * 0.06,
                              padding: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).size.width * 0.03,
                              ),
                              color: Colors.white,
                              child: const Center(
                                child: Text("Retake"),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.49,
                              height: MediaQuery.of(context).size.height * 0.06,
                              padding: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).size.width * 0.03,
                              ),
                              color: Colors.white,
                              child: const Center(
                                child: Text("Save"),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FutureBuilder<void>(
                    future: _initializeControllerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return CameraPreview(_controller);
                      } else {
                        return const Center(
                            child: SpinKitFoldingCube(color: Colors.white));
                      }
                    },
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0XFF004178),
                    ),
                    child: IconButton(
                      onPressed: () async {
                        var image;
                        try {
                          await _initializeControllerFuture;

                          /*final path = join(
                      (await getTemporaryDirectory()).path,
                      '${DateTime.now()}.png',
                    );*/

                          await _controller.takePicture().then((value) {
                            setState(() {
                              image = value;
                              //img = value.path;
                              imagePath = value;
                            });
                          });
                        } catch (e) {
                          //  print(e);
                        }
                        /*ImagePicker imagePicker = ImagePicker();
                  PickedFile compressedImage = await imagePicker.getImage(
                    source: ImageSource.camera,
                    imageQuality: 35,
                  );
                  setState(() {
                    image = compressedImage;
                    img = image.path;
                    print('compressedimagesize: ${image.lengthSync()}');
                  });*/
                        /*final path = join(
                    (await getTemporaryDirectory()).path,
                    '${DateTime.now()}.jpg',
                  );
                  File compressedImage = await FlutterImageCompress.compressAndGetFile(
                    image.path,
                    path,
                    quality: 25,
                  );*/
                        setState(() {
                          //image = compressedImage;
                          img = image.path;
                        });
                        // List<int> imageBytes = await image.readAsBytes();
                        /*String base64Image = base64Encode(imageBytes);
                  setState(() {
                    imageBase64List.add(base64Image);
                    if(imgBase64Strings == "")
                      imgBase64Strings = base64Image;
                    else
                      imgBase64Strings = base64Image + ";" + base64Image;
                  });*/
                      },
                      icon: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                      iconSize: MediaQuery.of(context).size.height * 0.06,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(0.1))
                ],
              ),
      ),
    );
  }
}
