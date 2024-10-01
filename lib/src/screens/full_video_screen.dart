
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class FullVideoScreen extends StatefulWidget {
  final ShowVideoAppInterface mListener;
  final String videoUrl;
  final String thumb;

  const FullVideoScreen({Key key, this.videoUrl, this.mListener, this.thumb,})
      : super(key: key);
  @override
  _FullVideoScreenState createState() => _FullVideoScreenState();
}

class _FullVideoScreenState extends State<FullVideoScreen> {
  VideoPlayerController _controller;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _isLoading = false;
        });
        _controller.play();

        _controller.setLooping(true);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.black,
        child: Stack(
          children: [
            Center(
              child: _controller.value.isInitialized
               ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
              : Container()
            ),
            Visibility(
             // visible: _isLoading ?false :true,
              visible: _controller.value.isPlaying  ?false :true,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                   if( _controller.value.isPlaying){
                     _controller.pause();
                   }
                   else{
                     _isLoading=true;
                     _controller.play();
                   }
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
            ),
            // Loading screen overlay
            if (_isLoading)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 15),
                    Text("Loading...",
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                  ],
                ),
              ),
          ],
        ),
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
