import 'dart:io';

import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'package:path_provider/path_provider.dart';

class VideoApp extends StatefulWidget {
  final VideoAppInterface mListener;
  final File videoUrl;

  const VideoApp({Key key, this.videoUrl, this.mListener}) : super(key: key);
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    thumnail();
    print("videooooo");
    _controller = VideoPlayerController.file(widget.videoUrl)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
        _controller.play();
        //_controller.setLooping(true);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : Container(),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _controller.value.isPlaying
                    ? _controller.pause()
                    : _controller.play();
              });
            },
            child: Center(
              child: Container(
                // color: Colors.white,
                child: _controller.value.isPlaying
                    ? Icon(
                        Icons.pause,
                        color: Colors.white,
                        size: 30,
                      )
                    : Icon(
                        Icons.play_circle,
                        color: Colors.white,
                        size: 30,
                      ),
              ),
            ),
          )
        ],
      ),
    );
  }

  thumnail() async {
    final fileName = await VideoThumbnail.thumbnailFile(
      video: widget.videoUrl.path,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.JPEG,
      // maxHeight: 64, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
      quality: 50,
    );
    print("fileName   $fileName");
    if (widget.mListener != null) {
      widget.mListener.sendFile(File(fileName));
    }
    return fileName;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

abstract class VideoAppInterface {
  sendFile(File thumbUrl);
}
