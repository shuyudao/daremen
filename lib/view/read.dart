import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ReadView extends StatelessWidget {
  ReadView(this.url, this.title, {Key key}) : super(key: key);

  String url;
  String title;
  WebViewController _controller;

  openUrl(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: IconButton(
                icon: Icon(Icons.open_in_new),
                onPressed: () async {
                  url = url.startsWith("//")?"http:"+url:url;
                  openUrl(url);
                },
              ),
            )
          ],
        ),
        body: WebView(
          userAgent:"Mozilla/5.0 (Linux; U; Android 8.1.0; zh-CN; EML-AL00 Build/HUAWEIEML-AL00) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/57.0.2987.108 UCBrowser/11.9.4.974 UWS/2.13.1.48 Mobile Safari/537.36 AliApp(DingTalk/4.5.11) com.alibaba.android.rimet/10487439 Channel/227200 language/zh-CN",
          onWebViewCreated: (WebViewController webViewController) {
            _controller = webViewController;
          },
          navigationDelegate: (NavigationRequest request) {
            if (!request.url.startsWith('http')) { //如果不是以http开头的请求，就使用url_launcher调用外部程序打开
              openUrl(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          initialUrl: url.startsWith("//")?"http:"+url:url,
          javascriptMode: JavascriptMode.unrestricted,
        ));
  }
}
