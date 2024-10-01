import 'dart:io';

import 'package:flutter/material.dart';
import 'package:griot_legacy_social_media_app/size_config.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FullImageActivityWebView extends StatefulWidget {
  final FullImageActivityWebViewInterface mListner;

  const FullImageActivityWebView(
      {Key key, this.imageUrl, this.comingFrom, this.mListner})
      : super(key: key);
  final String imageUrl;
  final String comingFrom;

  @override
  State<FullImageActivityWebView> createState() =>
      _FullImageActivityWebViewState();
}

class _FullImageActivityWebViewState extends State<FullImageActivityWebView> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: WebView(
        backgroundColor: const Color(0xff141414),
        initialUrl: widget.imageUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onPageStarted: (String url) {
          print("sattata $url");
        },
        onPageFinished: (String url) {
          if (Platform.isAndroid) {
            print("urlll $url");
            var splistUrl = url.split('?');
            print("urlll1111 ${splistUrl[0]}");
            if (widget.comingFrom == "2") {
              if (splistUrl[0] ==
                  "https://54.177.127.20:2109/api/payment/paymentSuccess") {
                Future.delayed(const Duration(seconds: 3)).then((value) {
                  Navigator.pop(context);
                  if (widget.mListner != null) {
                    widget.mListner.addBackPaymentScreen();
                  }
                });
              }
            }
          }
        },
      ),
    );
  }
}

abstract class FullImageActivityWebViewInterface {
  addBackPaymentScreen();
}
