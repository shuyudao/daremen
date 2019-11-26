import 'package:flutter/material.dart';

class AboutView extends StatelessWidget {
  const AboutView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("关于"),
      ),
      body: Center(
        child: Container(
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "大热门",
                      style: TextStyle(
                          fontSize: 36,
                          color: Colors.red,
                          fontWeight: FontWeight.w600),
                    ),
                    Text("version: 1.0.0"),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "追踪全网热点、简单高效阅读",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 20, 0, 30),
                            child: Text(
                                "聚合国内外各大热门网站的聚合信息,包括了知乎、微博、百度热搜、贴吧、Github、抖音、今日头条等等,在这里你能够轻松了解全网最新资讯以及兴趣内容。"),
                          ),
                          Text("山区的孩子没水喝",style: TextStyle(fontWeight: FontWeight.w600),),
                          Center(child: Image.asset("images/good.png"))
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
