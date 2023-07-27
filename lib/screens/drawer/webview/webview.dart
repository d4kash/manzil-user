import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewContainer extends StatelessWidget {
  WebViewContainer();

  final _key = UniqueKey();
  late final WebViewController _controller = WebViewController()
    ..loadRequest(
      Uri.parse('https://p5digital.in/privacy.html'),
    );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Expanded(
                child: WebViewWidget(
              key: _key,
              controller: _controller,
            ))
          ],
        ));
  }
}
