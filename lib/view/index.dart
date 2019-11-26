import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/Common/request.dart';
import 'package:flutter_app/domain/info.dart';
import 'package:flutter_app/view/read.dart';
import 'package:flutter_app/Common/CustomRoute.dart';

class IndexView extends StatefulWidget {
  var id;

  IndexView(this.id, {Key key}) : super(key: key);

  @override
  _IndexViewState createState() => _IndexViewState(id);
}

class _IndexViewState extends State<IndexView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<Info> listdata = [];
  var id;
  _IndexViewState(this.id);

  Future<List<Info>> init() async {
    var response = await Request.request("GetAllInfoGzip?id=" + id);
    var data = json.decode(response)['Data'];
    for (Map temp in data) {
      listdata.add(Info(temp['Title'].trim(), temp['Url'], temp['Desc']));
    }
    return listdata;
  }

  getData() {
    List<Widget> list = [];

    for (Info temp in listdata) {
      Widget wig = InkWell(
        onTap: () {
          Navigator.push(context, CustomRoute(ReadView(temp.url, temp.title)));
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.black12, width: 0.4))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  child: Text(
                    temp.title,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  padding: temp.desc == ""
                      ? EdgeInsets.fromLTRB(0, 20, 0, 20)
                      : EdgeInsets.fromLTRB(0, 20, 0, 12),
                ),
                Offstage(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
                    child: Text(
                      temp.desc,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                  offstage: temp.desc == "" ? true : false,
                )
              ],
            ),
          ),
        ),
      );

      list.add(wig);
    }
    return list.toList();
  }

  var _future_init;

  @override
  void initState() {
    super.initState();
    _future_init = init();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Scrollbar(
          child: FutureBuilder(
            future: _future_init,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ListView(
                  children: getData(),
                );
              } else {
                // 请求未结束，显示loading
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ));
  }
}
