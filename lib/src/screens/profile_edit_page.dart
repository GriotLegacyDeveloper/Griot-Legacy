import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:griot_legacy_social_media_app/size_config.dart';
import 'package:griot_legacy_social_media_app/src/controllers/user_controller.dart';
import 'package:griot_legacy_social_media_app/src/widgets/gender_grid_widget.dart';
import 'package:griot_legacy_social_media_app/src/widgets/my_button.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

Future fetchStr() async {
  await Future.delayed(const Duration(seconds: 5), () {});
  return 'Hello World';
}

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ProfileEditPageState();
  }
}

IconData getCameraLensIcon(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return Icons.camera_rear;
    case CameraLensDirection.front:
      return Icons.camera_front;
    case CameraLensDirection.external:
      return Icons.camera;
    default:
      throw ArgumentError('Unknown lens direction');
  }
}

void logError(String code, String message) {
  if (message != null) {
    //print('Error: $code\nError Message: $message');
  } else {
   // print('Error: $code');
  }
}

// ignore: prefer_typing_uninitialized_variables
var imagePath;

class ProfileEditPageState extends State<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  var _image;
  final picker = ImagePicker();
  bool loaderFlag = true;
  bool flag = true;
  List<bool> isValidated = [true, true, true];
  bool changeDetected = false;
  String localDateKey="";
  bool displayImageOptions = false;
  // ignore: prefer_typing_uninitialized_variables
  var firstCamera;
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  //Permission _permission;
 // PermissionStatus _permissionStatus=PermissionStatus.denied;
String profileImage="";
  @override
  void initState() {
    super.initState();
  // _listenForPermissionStatus();
   //initializeCamera();
  }

 /* void _listenForPermissionStatus() async {
    var status = await Permission.photos.status;
    setState(() => _permissionStatus = status);
  }
*/
  Future getImage() async {
    var status = await Permission.photos.request();
    if(status.isGranted){
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
     // final pickedFile = await picker.getVideo(source: ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
        //  print('No image selected.');
        }
      });
    }


  }

  openGallery() async {
    final ImagePicker _picker = ImagePicker();
    final XFile image = await _picker.pickImage(source: ImageSource.gallery);
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

  Widget pageBuilder(UserController controller) {
    final hp = controller.hp;
    final user = controller.user.value;
    final gender = user.gender.toLowerCase();
    if (flag) {
      Future.delayed(const Duration(milliseconds: 500), () {
        controller.setGender(gender == "male"
            ? 0
            : gender == "female"
                ? 1
                : gender == "non-binary"
                    ? 2
                    : 3);
        controller.nc.text = user.fullName;
        controller.phc.text = user.phone;
        controller.ec.text = user.emailID;
        controller.dobc.text = user.dateOfBirth;
        profileImage=user.imageURL;


        setState(() {
          flag = false;
        });
      });
    }
    return Container(
      color: Colors.black,
      child: SafeArea(
        top: false,
          bottom: false,
          child: Scaffold(
              backgroundColor: hp.theme.primaryColor,
            appBar: AppBar(
              // leading: Container(),
                backgroundColor: hp.theme.primaryColor,
                foregroundColor: hp.theme.secondaryHeaderColor,
                title: Image.asset("assets/images/title.png",
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.fill,
                   // width: hp.width,

                    /// 3.2
                    height: hp.height / 40),
                actions: [
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.notifications))
                ]),
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
                                       height: SizeConfig.screenHeight *.17,
                                      // width: SizeConfig.screenHeight *.14,
                                       color: Colors.transparent,

                                       child: Row(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: [
                                           Stack(
                                            children: <Widget>[
                                              Container(
                                                height: SizeConfig.screenHeight*.13,
                                                width: SizeConfig.screenHeight*.13,
                                                decoration: BoxDecoration(
                                                    image: const DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image: AssetImage(
                                                            "assets/images/dummy.jpeg")),
                                                    border: Border.all(
                                                        color: hp
                                                            .theme.selectedRowColor,
                                                        width: 2),
                                                    borderRadius: const BorderRadius.all(
                                                        Radius.circular(10.0))),

                                              ),
                                              Container(
                                                height: SizeConfig.screenHeight*.13,
                                                width: SizeConfig.screenHeight*.13,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: hp
                                                          .theme.selectedRowColor,
                                                      width: 2),
                                                  borderRadius: const BorderRadius.all(
                                                      Radius.circular(10.0)),
                                                  image:  DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: _image!=null?  FileImage(_image,) :
                                                    NetworkImage(profileImage),
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
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        MyButton(
                                            label: "Take Photo",
                                            labelWeight: FontWeight.w500,
                                            onPressed: () async {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              final pickedFile = await picker.getImage(source: ImageSource.camera);
                                              setState(() {
                                                if (pickedFile != null) {
                                                  _image = File(pickedFile.path);
                                                } else {
                                                 // print('No image selected.');
                                                }
                                              });
                                            /*  Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          Camera(firstCamera,
                                                              hp.theme)))
                                                  .then((value) {
                                                setState(() {
                                                  if (imagePath != "") {
                                                    _image = imagePath;
                                                    print("_image   $value");
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
                                            label: "   Gallery  ",
                                            labelWeight: FontWeight.w500,
                                            onPressed: () async {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              final pickedFile = await picker.getImage(source: ImageSource.gallery);
                                              setState(() {
                                                if (pickedFile != null) {
                                                  _image = File(pickedFile.path);
                                                } else {
                                                  //print('No image selected.');
                                                }
                                              });
                                              //getImage();
                                            },
                                            heightFactor: 50,
                                            widthFactor: 14,
                                            radiusFactor: 160),
                                      ],
                                    ),
                              Padding(
                                  padding: EdgeInsets.only(top: hp.height / 50),
                                  child: TextFormField(
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
                                      maxLength: 30,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[a-z,A-Z,]'))],

                                      decoration: InputDecoration(
                                        counterText: "",
                                          enabledBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                            // borderSide: BorderSide(color: Colors.red, width: 2),
                                          ),
                                          focusedBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                            //borderSide: BorderSide(color: Colors.red),
                                          ),
                                          filled: true,
                                          fillColor: hp.theme.cardColor,
                                          hintStyle: TextStyle(
                                              color: hp.theme.primaryColorLight),
                                          // enabledBorder: OutlineInputBorder(),
                                          prefixIcon: Icon(Icons.person_outline,
                                              color: hp.theme.primaryColorLight),
                                          contentPadding: EdgeInsets.only(
                                              left: hp.width / 40,
                                              top: hp.height / 50,
                                              bottom: hp.height / 50),
                                          border: InputBorder.none,
                                          hintText: "Name"),
                                      keyboardType: TextInputType.name,
                                      style: TextStyle(
                                          color: hp.theme.secondaryHeaderColor),
                                      controller: controller.nc)),
                              Padding(
                                  padding: EdgeInsets.only(
                                    top: hp.height / 40,
                                  ),
                                  child: TextFormField(
                                    autocorrect: false,
                               enableSuggestions: false,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          isValidated[1] = false;
                                          return "Email id can't be empty";
                                        } else {
                                          isValidated[1] = true;
                                        }
                                      },
                                      onChanged: (value) {
                                        setState(() {
                                          changeDetected = true;
                                        });
                                      },
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      decoration: InputDecoration(
                                          filled: true,
                                          enabledBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                            // borderSide: BorderSide(color: Colors.red, width: 2),
                                          ),
                                          focusedBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                            //borderSide: BorderSide(color: Colors.red),
                                          ),
                                          fillColor: hp.theme.cardColor,
                                          hintStyle: TextStyle(
                                              color: hp.theme.primaryColorLight),
                                          // enabledBorder:const OutlineInputBorder(),
                                          prefixIcon: Icon(Icons.mail_outline,
                                              color: hp.theme.primaryColorLight),
                                          contentPadding: EdgeInsets.only(
                                              left: hp.width / 40,
                                              top: hp.height / 50,
                                              bottom: hp.height / 50),
                                          border: InputBorder.none,
                                          hintText: "Email"),
                                      keyboardType: TextInputType.emailAddress,
                                      style: TextStyle(
                                          color: hp.theme.secondaryHeaderColor),
                                      controller: controller.ec)),
                              Padding(
                                  padding: EdgeInsets.only(
                                    top: hp.height / 40,
                                  ),
                                  child: TextFormField(
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          isValidated[2] = false;
                                          return "Phone number can't be empty";
                                        } else {
                                          isValidated[2] = true;
                                        }
                                      },
                                      onChanged: (value) {
                                        setState(() {
                                          changeDetected = true;
                                        });
                                      },
                                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],

                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      decoration: InputDecoration(
                                          filled: true,
                                          enabledBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                            // borderSide: BorderSide(color: Colors.red, width: 2),
                                          ),
                                          focusedBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                            //borderSide: BorderSide(color: Colors.red),
                                          ),
                                          fillColor: hp.theme.cardColor,
                                          hintStyle: TextStyle(
                                              color: hp.theme.primaryColorLight),
                                          // enabledBorder: OutlineInputBorder(),
                                          prefixIcon: Icon(Icons.call_outlined,
                                              color: hp.theme.primaryColorLight),
                                          contentPadding: EdgeInsets.only(
                                              left: hp.width / 40,
                                              top: hp.height / 50,
                                              bottom: hp.height / 50),
                                          border: InputBorder.none,
                                          hintText: "Mobile Number"),
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(
                                          color: hp.theme.secondaryHeaderColor),
                                      controller: controller.phc)),
                              Padding(
                                  padding: EdgeInsets.only(
                                      top: hp.height / 40,
                                      bottom: hp.height / 50),
                                  child: TextField(
                                      readOnly: true,
                                      onChanged: (value) {
//                                        print("value   $value");
                                        setState(() {
                                          changeDetected = true;
                                        });
                                      },
                                      onTap: () async {
                                        setState(() {
                                          changeDetected = true;
                                        });
                                       /* final dt = await hp.getDatePicker(
                                            controller.dobc, true,controller.dobForServer);*/
                                      },
                                      decoration: InputDecoration(
                                          enabledBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                            // borderSide: BorderSide(color: Colors.red, width: 2),
                                          ),
                                          focusedBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                            //borderSide: BorderSide(color: Colors.red),
                                          ),
                                          suffixIcon: IconButton(
                                              icon: Icon(
                                                  Icons.date_range_outlined,
                                                  color: hp.theme
                                                      .secondaryHeaderColor),
                                              onPressed: () async {

                                           //     print("Hi");
                                                final dt =
                                                    await hp.getDatePicker(
                                                    controller.dobc, true,controller.dobForServer);
                                                hp.validateDate(
                                                    controller.dobc.text);

                                              }
                                              ),

                                          filled: true,
                                          fillColor: hp.theme.cardColor,
                                          hintStyle: TextStyle(
                                              color: hp.theme.primaryColorLight),
                                          // enabledBorder: OutlineInputBorder(),
                                          prefixIcon: Icon(Icons.cake_outlined,
                                              color: hp.theme.primaryColorLight),
                                          contentPadding: EdgeInsets.only(
                                              left: hp.width / 40,
                                              top: hp.height / 50,
                                              bottom: hp.height / 50),
                                          border: InputBorder.none,
                                          hintText: "Date Of Birth"),
                                      keyboardType: TextInputType.datetime,
                                      style: TextStyle(
                                          color: hp.theme.secondaryHeaderColor),
                                      controller: controller.dobc)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding:
                                          EdgeInsets.only(top: hp.height / 200),
                                      child: Text("Gender:",
                                          style: TextStyle(
                                              color: hp
                                                  .theme.secondaryHeaderColor))),
                                ],
                              ),
                              SizedBox(
                                  child: const GenderGridWidget(),
                                  height: hp.height / 15,
                                  width: double.infinity),

                              Padding(
                                padding: const EdgeInsets.only(top: 25),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: MyButton(
                                      label: "Submit",
                                      labelWeight: FontWeight.w500,
                                      onPressed: () async {
                                        if (gender != controller
                                                .genders[controller.genderIndex]
                                                .toLowerCase()) {
                                          setState(() {
                                            changeDetected = true;
                                          });
                                        }
                                        setState(() {
                                          if(controller
                                              .genders[controller.genderIndex]=="NON BINARY"){
                                            controller
                                                .genders[controller.genderIndex]="NON_BINARY";

                                          }else if(controller
                                              .genders[controller.genderIndex]=="PREFER NOT TO REVEAL IT"){
                                            controller
                                                .genders[controller.genderIndex]="PREFER_NOT_TO_REVEAL_IT";
                                          }
                                        });
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());


                                        if (!isValidated.contains(false) &&
                                            changeDetected) {
                                          setState(() {
                                            loaderFlag = false;
                                          });


                                          final prefs =
                                              await controller.sharedPrefs;
                                       //   print("controller.dobForServer.text   ${controller.dobForServer.text}");

                                          final body = {
                                            "userId": prefs.getString("spUserID"),
                                            "loginId": prefs.getString("spLoginID"),
                                            "appType": Platform.isAndroid
                                                ? "ANDROID"
                                                : (Platform.isIOS
                                                    ? "IOS"
                                                    : "BROWSER"),
                                            "fullName": controller.nc.text,
                                            "email": controller.ec.text,
                                            "countryCode": user.countryCode,
                                            "phone": controller.phc.text,
                                            "dateOfBirth": controller.dobForServer.text,
                                            "gender":
                                            //controller.gender
                                            controller
                                                .genders[controller.genderIndex],
                                            "relationship": "SINGLE"
                                          };
                                          controller
                                              .waitUntilProfileUpdate(body)
                                              .then((value) {
                                            Future.delayed(
                                                const Duration(milliseconds: 1000),
                                                () {
                                              Future.delayed(
                                                  const Duration(milliseconds: 100),
                                                  () {
                                                setState(() {
                                                  loaderFlag = true;
                                                });
                                                if (value) {
                                                  Navigator.pop(context);
                                                }
                                              });
                                            });
                                          });
                                        }
                                        if (_image != null) {
                                          setState(() {
                                            loaderFlag = false;
                                          });
                                          final prefs =
                                              await controller.sharedPrefs;
                                          final body = {
                                            "userId":
                                                prefs.getString("spUserID") ?? "",
                                            "loginId":
                                                prefs.getString("spLoginID") ?? "",
                                            "appType": Platform.isAndroid
                                                ? "ANDROID"
                                                : (Platform.isIOS
                                                    ? "IOS"
                                                    : "BROWSER"),
                                          };
                                          controller
                                              .waitUntilProfileImageUpdate(
                                                  body, _image.path)
                                              .then((value) {
                                            Future.delayed(
                                                const Duration(milliseconds: 100),
                                                () {
                                                  if(mounted)
                                              setState(() {
                                                loaderFlag = true;
                                                if (value) {
                                                  //_image = null;
                                                }
                                              });
                                            });
                                          });
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
                        padding: EdgeInsets.symmetric(horizontal: hp.width / 40)),
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

              /*appBar: AppBar(
                backgroundColor: hp.theme.primaryColor,
                foregroundColor: hp.theme.secondaryHeaderColor,
                title: Image.asset("assets/images/title.png",
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.fill,
                    width: hp.width / 3.2,
                    height: hp.height / 40),
                actions: [
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
                ],
              )*/
          )),
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
          title: Text("Take Photo"),
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
