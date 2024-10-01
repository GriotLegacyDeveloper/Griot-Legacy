import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:griot_legacy_social_media_app/size_config.dart';
import 'package:griot_legacy_social_media_app/src/controllers/post_controller.dart';
import 'package:griot_legacy_social_media_app/src/controllers/user_controller.dart';
import 'package:griot_legacy_social_media_app/src/widgets/my_button.dart';
import 'chat_activity.dart';


class SearchScreen extends StatefulWidget {
  final SearchScreenInterface mListener;
  const SearchScreen({Key key, this.mListener}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SearchScreenState();
  }
}

class SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchTextFieldController =
      TextEditingController();
  bool flag = true;
  String userImageUrl = "";
  List data = [];
  bool noUser = false;

  Widget pageBuilder(UserController con) {
    final hp = con.hp;
    return SafeArea(
        child: Scaffold(
            backgroundColor: hp.theme.primaryColor,
            body: Container(
              margin: const EdgeInsets.only(top: 30),
              child: Stack(
                children: [
                  SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, right: 8),
                                child: TextField(
                                    autocorrect: false,
                                    controller: _searchTextFieldController,
                                    textInputAction: TextInputAction.done,
                                    //readOnly: true,
                                    onTap: () {
                                      //hp.goToRoute("/uploadPost");
                                    },
                                    onSubmitted: (value) async {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      if (_searchTextFieldController
                                          .text.isNotEmpty) {
                                        setState(() {
                                          // flag = false;
                                        });
                                        final prefs = await con.sharedPrefs;
                                        Map<String, dynamic> body = {
                                          "userId": prefs.getString("spUserID"),
                                          "loginId":
                                              prefs.getString("spLoginID"),
                                          "appType":
                                              prefs.getString("spAppType"),
                                          "search":
                                              _searchTextFieldController.text
                                        };
                                        await con
                                            .waitUntilSearchUser(body)
                                            .then((value) {
                                          setState(() {
                                            flag = true;
                                            if (value) {
                                              data = con.searchResultList;
                                              userImageUrl = con.userImageUrl;
                                              if (data.isEmpty) {
                                                noUser = true;
                                              } else {
                                                noUser = false;
                                              }
                                            }
                                          });
                                        });
                                      }
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        noUser = false;
                                        data = [];
                                      });
                                    },
                                    //
                                    decoration: InputDecoration(

                                        suffixIcon: IconButton(
                                          icon: const Icon(Icons.search,
                                              color: Colors.white),
                                          onPressed: () async {
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                            if (_searchTextFieldController
                                                .text.isNotEmpty) {
                                              setState(() {
                                                flag = false;
                                              });
                                              final prefs =
                                                  await con.sharedPrefs;
                                              Map<String, dynamic> body = {
                                                "userId":
                                                    prefs.getString("spUserID"),
                                                "loginId": prefs
                                                    .getString("spLoginID"),
                                                "appType": prefs
                                                    .getString("spAppType"),
                                                "search":
                                                    _searchTextFieldController
                                                        .text
                                              };
                                              //print("body    $body");
                                              await con
                                                  .waitUntilSearchUser(body)
                                                  .then((value) {
                                                setState(() {
                                                  flag = true;
                                                  if (value) {
                                                    data = con.searchResultList;
                                                    userImageUrl =
                                                        con.userImageUrl;
                                                    if (data.isEmpty) {
                                                      noUser = true;
                                                    } else {
                                                      noUser = false;
                                                      // flag = false;
                                                    }
                                                  }
                                                });
                                              });
                                            }
                                          },
                                        ),
                                        filled: true,
                                        enabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                         // borderSide: BorderSide(color: Colors.red, width: 2),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                          //borderSide: BorderSide(color: Colors.red),
                                        ),
                                        fillColor: hp.theme.cardColor,

                                        hintStyle: TextStyle(
                                            color: hp.theme.primaryColorLight),
                                        /*prefixIcon: Icon(Icons.person_outline_outlined,
                                            color: hp.theme.primaryColorLight),*/
                                       // border: const OutlinedBorder(),
                                      //  border: InputBorder.none,
                                        hintText: "Enter name"),
                                    style: TextStyle(
                                        color: hp.theme.secondaryHeaderColor)),
                              ),
                              height: hp.height / 16),
                          SizedBox(height: hp.height / 50),
                          noUser && _searchTextFieldController.text.isNotEmpty
                              ? Container(
                            alignment: Alignment.center,
                                height: SizeConfig.screenHeight*.60,
                                child: Text(
                                  "No result found for " +
                                      _searchTextFieldController.text +
                                      " !",
                                  style: TextStyle(
                                      color: hp.theme.secondaryHeaderColor,fontSize: SizeConfig.safeBlockHorizontal*5.5),
                                ),
                              )
                              : Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    itemCount: data.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Card(
                                          color: Colors.black.withOpacity(0.5),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  GestureDetector(
                                                    onTap: (){
                                                      widget.mListener.addDetailsPage(data[index]["userId"]);

                                                    },
                                                    onDoubleTap: (){},
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        children: [
                                                          data[index]["profileImage"] ==
                                                                  ""
                                                              ? Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    border: Border.all(
                                                                        color: hp
                                                                            .theme
                                                                            .secondaryHeaderColor,
                                                                        width: 1),
                                                                    image: const DecorationImage(
                                                                        fit: BoxFit
                                                                            .contain,
                                                                        image: AssetImage(
                                                                            "assets/images/dummy.jpeg")),
                                                                  ),
                                                                  height:
                                                                      hp.height /
                                                                          9,
                                                                  width:
                                                                      hp.width /
                                                                          5,
                                                                  margin: EdgeInsets.only(
                                                                      right:
                                                                          hp.width /
                                                                              32))
                                                              : Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    border: Border.all(
                                                                        color: hp
                                                                            .theme
                                                                            .secondaryHeaderColor,
                                                                        width: 1.5),
                                                                    image: DecorationImage(
                                                                        fit: BoxFit
                                                                            .contain,
                                                                        image: NetworkImage(userImageUrl +
                                                                            data[index]
                                                                                [
                                                                                "profileImage"])),
                                                                  ),
                                                                  height:
                                                                      hp.height /
                                                                          9,
                                                                  width:
                                                                      hp.width /
                                                                          5,
                                                                  margin: EdgeInsets.only(
                                                                      right:
                                                                          hp.width /
                                                                              32)),
                                                          Text(
                                                            data[index]
                                                                ["fullName"],
                                                            style: TextStyle(
                                                                color: hp.theme
                                                                    .secondaryHeaderColor,
                                                                fontSize:
                                                                    hp.height *
                                                                        0.022),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                hp.width * 0.0),
                                                    child: CircleAvatar(
                                                        child: IconButton(
                                                          icon: Icon(
                                                              Icons
                                                                  .cancel_outlined,
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.5)),
                                                          onPressed: () {
                                                            setState(() {
                                                              data.removeAt(
                                                                  index);
                                                            });
                                                          },
                                                        ),
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        foregroundColor:
                                                            Colors.transparent),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8.0),
                                                child: MyButton(
                                                    label: data[index]['isAccepted']=="RDY_TO_CONNECT"? "Send Invitation" :data[index]['isAccepted']=="PENDING" ?"Invited":"Message",
                                                    textStyle: const TextStyle(
                                                        fontSize: 20),
                                                    labelWeight:
                                                        FontWeight.w700,
                                                    onPressed: () async {
                                                      if(data[index]["isAccepted"] =="RDY_TO_CONNECT") {


                                                        //print("nnnnnn");
                                                        FocusScope.of(context)
                                                            .requestFocus(
                                                            FocusNode());
                                                        setState(() {
                                                          flag = false;
                                                        });
                                                        final prefs =
                                                        await con.sharedPrefs;
                                                        Map<String,
                                                            dynamic> body = {
                                                          "userId": prefs
                                                              .getString(
                                                              "spUserID"),
                                                          "toUserId": data[index]["userId"],
                                                          "appType": prefs
                                                              .getString(
                                                              "spAppType"),
                                                          "loginId": prefs
                                                              .getString(
                                                              "spLoginID"),

                                                        };
                                                        await con
                                                            .waitUntilSendInvitation(
                                                            body)
                                                            .then((value) {
                                                          setState(() {
                                                            flag = true;
                                                            if (value) {

                                                            }
                                                          });
                                                        });
                                                      }
                                                      else if(data[index]['isAccepted']=="ACCEPTED"){
                                                        //print("hello");
                                                        Navigator.push(
                                                            hp.context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                               ChatActivity(otherUserId: data[index]["userId"],
                                                                 name: data[index]["fullName"],profilePic:"https://54.177.127.20:2109/img/profile-pic/"+data[index]["profileImage"],),
                                                            ));
                                                      }

                                                    },

                                                    heightFactor: 50,
                                                    widthFactor: 3.4,
                                                    radiusFactor: 160),
                                              ),
                                              const SizedBox(
                                                height: 16,
                                              )
                                            ],
                                          ));
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        color: Colors.black,
                                        height: 16,
                                      );
                                    },
                                  ),
                                )
                        ],
                      ),
                      padding: EdgeInsets.symmetric(horizontal: hp.width / 50)),
                  flag
                      ? Container()
                      : Container(
                          height: hp.height,
                          width: hp.width,
                          color: Colors.black87,
                          child: const SpinKitFoldingCube(color: Colors.white),
                        )
                ],
              ),
            )));
  }

  void didChange(GetBuilderState<PostController> state) {
    state.controller.hp.lockScreenRotation();
  }

  @override
  Widget build(BuildContext context) {
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    return pageBuilder(UserController(context, state));
  }
}


abstract class SearchScreenInterface{

addDetailsPage(String id);

}
