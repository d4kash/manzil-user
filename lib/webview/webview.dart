import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomWebView extends StatelessWidget {
  CustomWebView({super.key});

  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        // onNavigationRequest: (NavigationRequest request) {
        // if (request.url.startsWith('https://p5digital.in/privacy.html')) {
        //   return NavigationDecision.prevent;
        // }
        // return NavigationDecision.navigate;
        // },
      ),
    )
    ..loadRequest(Uri.parse('https://p5digital.in/privacy.html'));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: WebViewWidget(controller: controller),
    );
  }
}
