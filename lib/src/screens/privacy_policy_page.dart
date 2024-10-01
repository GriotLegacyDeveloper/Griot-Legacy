import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:griot_legacy_social_media_app/src/helpers/helper.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hp =
        Helper.of(context, context.findAncestorStateOfType<GetBuilderState>());
    const str =
        "To create the REST architectural style, Fielding identified the requirements that apply when creating a world-wide network-based application, such as the need for a low entry-barrier to enable global adoption. He also surveyed many existing architectural styles for network-based applications, identifying which features are shared with other styles, such as caching and client-server features, and those which are unique to REST, such as the concept of resources. Fielding was trying to both categorise the existing architecture of the current implementation and identify which aspects should be considered central to the behavioural and performance requirements of the Web.";
    hp.lockScreenRotation();
    return Container(
      color: Colors.black,

      child: SafeArea(
          child: Scaffold(
              backgroundColor: hp.theme.primaryColor,
              body: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Divider(
                        color: Colors.grey,
                      ),
                      Padding(padding: EdgeInsets.only(top: hp.height * 0.02)),
                      Text(str,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: str.length ~/ 10,
                          style: TextStyle(color: hp.theme.secondaryHeaderColor)),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: hp.width / 32)),
              appBar: AppBar(
                  title: const Text("Privacy & Policy"),
                  foregroundColor: hp.theme.secondaryHeaderColor,
                  backgroundColor: hp.theme.primaryColor))),
    );
  }
}
