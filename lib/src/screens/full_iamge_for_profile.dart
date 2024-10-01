import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:griot_legacy_social_media_app/size_config.dart';
import 'package:photo_view/photo_view.dart';

import '../../main.dart';

class FullImageForProfileActivity extends StatefulWidget {
  final String image;
  const FullImageForProfileActivity({Key key, this.image}) : super(key: key);

  @override
  _FullImageForProfileActivityState createState() => _FullImageForProfileActivityState();
}

class _FullImageForProfileActivityState extends State<FullImageForProfileActivity> {
  String image="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  initData()async{
    final prefs = await sharedPreferences;
    String imageStr=prefs.getString("image");
    setState(() {
      image=imageStr;
    });
  //  print("image   $image");
  }



  @override
  Widget build(BuildContext context) {
  //  print("image     ${widget.image}");
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        //title: const Text("Inner Circl"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: SizedBox(
        height: SizeConfig.screenHeight,
        child: PhotoView(
          minScale: 0.1,
          maxScale: 0.8,
          imageProvider: NetworkImage(widget.image),

        ),

      ),
    );
  }


  /*widget for getTopDesign*/
  Widget getImage(double parentHeight, double parentWidth,int index){
    return PhotoView(
      backgroundDecoration: const BoxDecoration(
        color: Colors.white,

      ),
      minScale: 0.5,
      maxScale: 0.8,
      imageProvider: CachedNetworkImageProvider(widget.image),
    );
  }
}
