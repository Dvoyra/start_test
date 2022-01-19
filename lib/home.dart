// var url = 'https://soft-b2b.ru/clothes/';

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

// import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';

class MyHomePage extends StatefulWidget {
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  late WebViewController _webController;
  double progress = 0;
  Color color = Color(0xff8a0f8d);

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if (await _webController.canGoBack()) {
            _webController.goBack();
          } else {
            log('Нет записи в истории');
          }
          return false;
        },
        child: Scaffold(
          body: Column(
            children: [
              LinearProgressIndicator(
                value: progress,
                color: color,
                backgroundColor: Colors.white,
              ),
              Expanded(
                child: WebView(
                  initialUrl: 'https://soft-b2b.ru/',
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (controller) {
                    _webController = controller;
                  },
                  onProgress: (progress) {
                    this.progress = progress / 100;

                    setState(() {});
                  },
                  onPageStarted: (url) {
                    if (url.startsWith('https://soft-b2b.ru/flowers')) {
                      color=Color(0xff61b5be);
                      SystemChrome.setSystemUIOverlayStyle(
                        SystemUiOverlayStyle(
                            statusBarColor: color,
                            systemNavigationBarColor:color),
                      );
                    }else if (url.startsWith('https://soft-b2b.ru/clothes')) {
                      color=Color(0xFF8a0f8d);
                      SystemChrome.setSystemUIOverlayStyle(
                        SystemUiOverlayStyle(
                            statusBarColor: color,
                            systemNavigationBarColor: color),
                      );
                    }else if (url.startsWith('https://soft-b2b.ru')) {
                      color=Color(0xFF8a0f8d);
                      SystemChrome.setSystemUIOverlayStyle(
                        SystemUiOverlayStyle(
                            statusBarColor: color,
                            systemNavigationBarColor: color),
                      );
                    }

                  },
                  onPageFinished: (url) {},
                  navigationDelegate: (NavigationRequest request) {
                    if (request.url.startsWith('https://soft-b2b.ru')) {
                      return NavigationDecision.navigate;
                    } else {
                      _launchURL(request.url);
                      return NavigationDecision.prevent;
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Не удалось запустить';
  }
}
