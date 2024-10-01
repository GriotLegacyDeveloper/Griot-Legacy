import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:griot_legacy_social_media_app/src/controllers/other_controller.dart';
import 'package:griot_legacy_social_media_app/src/services/calls_and_messages_service.dart';
import 'package:griot_legacy_social_media_app/src/services/service_locator.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class InviteFriendsPage extends StatefulWidget {
  final String comesFrom;
  const InviteFriendsPage({Key key, @required this.comesFrom})
      : super(key: key);

  @override
  InviteFriendsState createState() => InviteFriendsState();
}

class InviteFriendsState extends State<InviteFriendsPage> {
  bool isEmailSelected = true;
  final CallsAndMessagesService _service = locator<CallsAndMessagesService>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OtherController>(
        builder: pageBuilder,
        init: OtherController(
            context, context.findAncestorStateOfType<GetBuilderState>()));
  }






  void _createEmail() async{
    const url = 'mailto:?subject=App Feedback&body=A friend or family member has invited you to be a part of their tribe on Griot Legacy please download the app to join.';

    if(await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not Email';
    }
  }








  String encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }


  setSms() async{
    print("gggggg");
    Uri smsUri = Uri(
      scheme: 'sms',
      path: '',
      query: encodeQueryParameters(<String, String>{
        'body':'A friend or family member has invited you to be a part of their tribe on Griot Legacy please download the app to join.'
      }),
    );

    try {
      print("rrrrr");

      if (await canLaunch(smsUri.toString())) {
        print("bbcbcbbbc");
        await launch(smsUri.toString());
      }else{
        print("cccccc");
      }
    } catch (e) {
      print("eeeee");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Some error occured'),
        ),
      );
    }
  }




  Widget pageBuilder(OtherController con) {
    final hp = con.hp;
    hp.lockScreenRotation();
    return SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
            appBar: widget.comesFrom == "Login"
                ? null
                : AppBar(
                    leadingWidth: 0,
                    backgroundColor: hp.theme.primaryColor,
                    foregroundColor: hp.theme.secondaryHeaderColor,
                    title: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(con.buildContext);
                          },
                          child: Container(
                            color: Colors.transparent,
                            padding: const EdgeInsets.only(left: 30),
                            child: const Text(
                              "Invite Friends",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                      ],
                    )),
            backgroundColor: hp.theme.primaryColor,
            body: Container(
              color: Colors.transparent,
              // padding: const EdgeInsets.only(top: 64, left: 24, right: 24),
              margin: widget.comesFrom == "Login"
                  ? const EdgeInsets.only(top: 128, left: 4, right: 4)
                  : const EdgeInsets.only(top: 15, left: 4, right: 4),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                image: const DecorationImage(
                                    fit: BoxFit.fill,
                                    image: AssetImage(
                                        "assets/images/back-img.png")),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(hp.radius / 100))),
                            height: 150,
                            width: 150,
                            margin: EdgeInsets.only(right: hp.width / 32)),
                        SizedBox(
                          width: 80,
                          height: 80,
                          //
                          child: Container(
                            decoration: BoxDecoration(
                                image: const DecorationImage(
                                    fit: BoxFit.fill,
                                    image: AssetImage(
                                        "assets/images/invite_friends.png")),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(hp.radius / 100))),
                            // height: 150,
                            // width: 150,
                            // margin: EdgeInsets.only(right: hp.width / 32)
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: hp.height / 50),
                        child: Text("Invite Friends By",
                            style: TextStyle(
                                fontFamily: "Work Sans",
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 21,
                                color: hp.theme.secondaryHeaderColor))),
                    const SizedBox(
                      height: 32,
                    ),
                    Container(
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: MaterialButton(
                                onPressed: () {
                                  setState(() {
                                    isEmailSelected = false;
                                    setSms();
                                   /* if(Platform.isAndroid) {
                                      sendMessage();
                                    }else if(Platform.isIOS){
                                      setSms
                                    }*/

                                  });
                                },
                                child: Container(
                                  height: 52,
                                  // width: 120,
                                  decoration: BoxDecoration(
                                      color: isEmailSelected
                                          ? hp.theme.primaryColor
                                          : hp.theme.secondaryHeaderColor,
                                      border: Border.all(
                                          color: isEmailSelected
                                              ? hp.theme.selectedRowColor
                                              : Colors.transparent,
                                          width: 2),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.sms_outlined,
                                        color: isEmailSelected
                                            ? hp.theme.secondaryHeaderColor
                                            : hp.theme.primaryColor,
                                      ),
                                      const SizedBox(
                                        width: 6,
                                      ),
                                      Text(
                                        "SMS",
                                        style: TextStyle(
                                            color: isEmailSelected
                                                ? hp.theme.secondaryHeaderColor
                                                : hp.theme.primaryColor,
                                            fontSize: 18,
                                            fontStyle: FontStyle.normal),
                                      )
                                    ],
                                  ),
                                )),
                          ),
                          Expanded(
                            child: MaterialButton(
                                onPressed: () {
                                  setState(() {
                                    isEmailSelected = true;
                                    _createEmail();


                                    // _sendingMails();
                                  });
                                },
                                child: Container(
                                  height: 52,
                                  // width: 120,
                                  decoration: BoxDecoration(
                                      color: isEmailSelected
                                          ? hp.theme.secondaryHeaderColor
                                          : hp.theme.primaryColor,
                                      border: Border.all(
                                          color: isEmailSelected
                                              ? Colors.transparent
                                              : hp.theme.selectedRowColor,
                                          width: 2),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.email_outlined,
                                        color: isEmailSelected
                                            ? hp.theme.primaryColor
                                            : hp.theme.secondaryHeaderColor,
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      Text(
                                        "EMAIL",
                                        style: TextStyle(
                                            color: isEmailSelected
                                                ? hp.theme.primaryColor
                                                : hp.theme.secondaryHeaderColor,
                                            fontSize: 18,
                                            fontStyle: FontStyle.normal),
                                      )
                                    ],
                                  ),
                                )),
                          )
                        ],
                      ),
                    ),
                    widget.comesFrom == "Login"
                        ? Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(top: 128),
                            child: MaterialButton(
                              child: const Text(
                                "SKIP",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              onPressed: () {
                                //print("skip");
                                hp.goToRouteWithNoWayBack("/screens", true);
                              },
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            )));
  }
}
