import 'package:cached_network_image/cached_network_image.dart';
import 'package:griot_legacy_social_media_app/src/utils/constant_class.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class ShowVideoApp extends StatefulWidget {
  final ShowVideoAppInterface mListener;
  final String videoUrl;
  final String thumb;
  final String come;

  const ShowVideoApp({Key key, this.videoUrl, this.mListener, this.thumb, this.come})
      : super(key: key);
  @override
  _ShowVideoAppState createState() => _ShowVideoAppState();
}

class _ShowVideoAppState extends State<ShowVideoApp> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    //print("showVidepo   ${widget.videoUrl}");
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
        if(widget.come=="2"){
          _controller.play();
        }
        _controller.setLooping(true);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          InteractiveViewer(
            panEnabled: true,
            scaleEnabled: true,
            minScale: 1.0,
            maxScale: 2.2,
            child: Center(
              child: _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : Container(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: CachedNetworkImage(
                            imageUrl:
                            Constant.SERVER_URL +
                                    widget.thumb,
                            fit: BoxFit.fitWidth,
                            placeholder: (BuildContext context, url) {
                              return const Image(
                                  image: AssetImage('assets/images/noimage.png'));
                            },
                          )),
                    ),
            ),
          ),
          Visibility(
            visible: widget.come!="1"?true:false,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                });
              },
              child: Center(
                child: Container(

                   color: Colors.grey,
                  child: _controller.value.isPlaying
                      ? const Icon(
                    Icons.pause,
                    color: Colors.white,
                    size: 30,
                  )
                      : const Icon(
                    Icons.play_circle,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

abstract class ShowVideoAppInterface {}
