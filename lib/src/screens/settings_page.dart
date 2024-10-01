import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:griot_legacy_social_media_app/src/controllers/post_controller.dart';
import 'package:griot_legacy_social_media_app/src/models/quick_link.dart';
import 'package:griot_legacy_social_media_app/src/widgets/settings_list_widget.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key key}) : super(key: key);

  void didChange(GetBuilderState<PostController> state) {
    state.controller.hp.lockScreenRotation();
  }

  Widget pageBuilder(PostController con) {
    final hp = con.hp;
    return SafeArea(
        child: Scaffold(
            body: SettingsListWidget(links: [
              QuickLink("Account Settings", () {
                hp.goToRoute("/accountSettings");
              }),
              QuickLink("About Us", () {
                hp.goToRoute("/aboutUs");
              }),
              QuickLink("Terms & Conditions", () {
                hp.goToRoute("/termsAndConditions");
              }),
              QuickLink("Privacy & Policy", () {
                hp.goToRoute("/privacyPolicy");
              }),
              QuickLink("FAQ", () async {
              //  final prefs = await con.sharedPrefs;
               // print(prefs.getKeys());
                hp.goToRoute("/faq");
              }),
              QuickLink("Contact Us", () {
                hp.goToRoute("/contactUs");
              })
            ]),
            backgroundColor: hp.theme.primaryColor));
  }

  @override
  Widget build(BuildContext context) {
    final state =
        context.findAncestorStateOfType<GetBuilderState<PostController>>() ??
            GetBuilderState<PostController>();
    return pageBuilder(PostController(context, state));
  }
}
