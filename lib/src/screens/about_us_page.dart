import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:griot_legacy_social_media_app/size_config.dart';
import 'package:griot_legacy_social_media_app/src/controllers/other_controller.dart';

class AboutUsPage extends StatefulWidget {
  final String data;
  final String titleText;
  const AboutUsPage({Key key, this.data, this.titleText}) : super(key: key);

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  Widget pageBuilder(OtherController con) {


    final hp = con.hp;
    const str =
        "To create the REST architectural style, Fielding identified the requirements that apply when creating a world-wide network-based application, such as the need for a low entry-barrier to enable global adoption. He also surveyed many existing architectural styles for network-based applications, identifying which features are shared with other styles, such as caching and client-server features, and those which are unique to REST, such as the concept of resources. Fielding was trying to both categorise the existing architecture of the current implementation and identify which aspects should be considered central to the behavioural and performance requirements of the Web.";
    hp.lockScreenRotation();
    return Scaffold(
        backgroundColor:Colors.black,
        body: SingleChildScrollView(
            child: Column(
              children: [
                const Divider(
                  color: Colors.grey,
                ),
                Padding(padding: EdgeInsets.only(top: hp.height * 0.02)),

                Html(
                  data: widget.data,
                  style: {
                    "body": Style(
                        fontFamily: "Poppins",
                        color: Colors.white
                    ),
                  },


                ),

              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: hp.width / 32)),
        appBar: AppBar(
            title:  Text(widget.titleText,style:  TextStyle(fontSize:SizeConfig.safeBlockHorizontal*5.5,
                fontWeight: FontWeight.normal,
                fontFamily: "Poppins",
                color: Colors.white),),
            foregroundColor: Colors.white,
            backgroundColor: Colors.black));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OtherController>(
        builder: pageBuilder,
        init: OtherController(
            context, context.findAncestorStateOfType<GetBuilderState>()));
  }
}
