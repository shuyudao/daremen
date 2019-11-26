import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_app/domain/type.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/view/about.dart';
import 'package:flutter_app/MainProvider.dart';
import './Common/request.dart';
import 'package:flutter_app/view/index.dart';
import 'Common/CustomRoute.dart';
import 'package:flutter_app/view/list.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(ChangeNotifierProvider<MainProvider>.value(
    value: MainProvider(),
    child: MyApp(),
  ));
}

//自定义组件
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TabControllerPage(),
      theme: ThemeData(primarySwatch: Colors.red),
      debugShowCheckedModeBanner: false
    );
  }
}

class TabControllerPage extends StatefulWidget {
  @override
  _TabControllerPageState createState() => _TabControllerPageState();
}

class _TabControllerPageState extends State<TabControllerPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _tabController; //需要定义一个Controller
  List tabs = [];
  @override
  bool get wantKeepAlive => true;

  Future<List<Type>> init(context) async {
    List<Type> typeList = [];
    var e = await Request.request("GetAllType");
    var data = json.decode(e)['Data']['全部'];
    for (Map item in data) {
      Type typeItem =
          Type(item['id'], item['name'], item['sort'], item['type']);
      typeList.add(typeItem);
    }

//我的订阅
    List<Type> mylist = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> mylistMap = prefs.getStringList("mylist");
    if (mylistMap == null) {
      mylistMap = [];
      mylist = [
        Type("83", "百度热搜", "1", ""),
        Type("58", "微博", "2", ""),
        Type("123", "观察者", "2", ""),
        Type("1", "知乎", "2", ""),
        Type("85", "GitHub", "2", ""),
      ];
      for(var i = 0 ; i < mylist.length ; i++){
        mylistMap.add(json.encode(mylist[i]));
      }
      prefs.setStringList("mylist", mylistMap);
    } else {
      for (String item in mylistMap) {
        var map = json.decode(item);
        Type itemtype = Type(map['id'], map['name'], map['sort'], map['type']);
        mylist.add(itemtype);
      }
    }
    
    //更新数据
    for (var i = 0; i < mylist.length; i++) {
      for (var j = 0; j < typeList.length; j++) {
        if (typeList[j].name == mylist[i].name) {
          typeList[j].isC = true;
          break;
        }
      }
    }

    Provider.of<MainProvider>(context).setTypeList(typeList);

    tabs = mylist;
    return mylist;
  }

  getData() {
    List<Widget> list = [];
    for (Type item in tabs) {
      list.add(IndexView(item.id));
    }
    return list;
  }

  getBuild() {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            "大热门",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          actions: <Widget>[
            new PopupMenuButton<String>(
                //这是点击弹出菜单的操作，点击对应菜单后，改变屏幕中间文本状态，将点击的菜单值赋予屏幕中间文本
                onSelected: (String value) {
                  Navigator.push(context, CustomRoute(AboutView()));
                },
                padding: EdgeInsets.all(2.0),
                //这是弹出菜单的建立，包含了两个子项，分别是增加和删除以及他们对应的值
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      PopupMenuItem(
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Icon(Icons.info, color: Colors.red),
                            new Text('关于',
                                style: TextStyle(color: Colors.red)),
                          ],
                        ),
                        value: 'about',
                      )
                    ])
          ],
          // bottom: ,
        ),
        body: Column(
          children: <Widget>[
            Container(
              height: 48.0,
              color: Colors.red,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 8,
                    child: TabBar(
                        isScrollable: true,
                        unselectedLabelColor: Colors.white70,
                        controller: _tabController,
                        indicatorColor: Colors.white,
                        tabs: tabs.map((e) => Tab(text: e.name)).toList()),
                  ),
                  Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            boxShadow: [
                              ///阴影颜色/位置/大小等
                              BoxShadow(
                                color: Colors.black26, offset: Offset(1, 1),

                                ///模糊阴影半径
                                blurRadius: 3,
                              ),
                            ]),
                        child: Container(
                          color: Colors.red,
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(context, CustomRoute(ListWrap((){
                                _future_init = null;
                                _page_data = null;
                              })));
                            },
                            icon: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            color: Colors.white,
                          ),
                        ),
                      ))
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: getData(),
              ),
            )
          ],
        ));
  }

  var _future_init;
  var _page_data;
  var chang;

  @override
  void initState() {
    super.initState();
    _future_init = init(context);
  }

  re(){
    _future_init = init(context);
    return _future_init;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future_init==null?re():_future_init,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            _tabController =
                TabController(length: snapshot.data.length, vsync: this);
            if (_page_data == null) {
              _page_data = getBuild();
            }
            return _page_data;
          } else {
            // 请求未结束，显示loading
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "大热门",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                centerTitle: true,
              ),
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
