import 'package:flutter/material.dart';
import 'package:flutter_app/MainProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/domain/type.dart';

class ListWrap extends StatefulWidget {
  ListWrap(this.fun, {Key key}) : super(key: key);
  Function fun;
  @override
  _ListWrapState createState() => _ListWrapState(fun);
}

class _ListWrapState extends State<ListWrap> {
  Function fun;
  _ListWrapState(fun) {
    this.fun = fun;
  }

  List listdata = [];
  List<Widget> itemlist = [
    Center(
      child: Text("加载数据..."),
    )
  ];

  getData() {
    Future.delayed(Duration(milliseconds: 700), () {
      setState(() {
        listdata = Provider.of<MainProvider>(context).typeList;
      });
    });
  }

  getItem() {
    if(listdata.isEmpty){
      return [
        Center(
                child: CircularProgressIndicator(),
              )
      ];
    }
    itemlist = [];
    for (Type item in listdata) {
      itemlist.add(ChoiceChip(
        backgroundColor: Color.fromRGBO(239, 239, 239, 1),
        disabledColor: Colors.black54,
        selectedColor: Colors.red,
        label: Text(
          item.name,
          style: TextStyle(color: item.isC ? Colors.white : Colors.black87),
        ),
        selected: item.isC,
        onSelected: (bool boolean) {
          setState(() {
            item.isC = !item.isC;
          });
          Provider.of<MainProvider>(context).updateList(item);
          fun();
        },
      ));
    }
    return itemlist;
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("添加订阅"),
        ),
        body: ListView(padding: EdgeInsets.all(10), children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
            child: Text(
              "订阅你的内容：",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 0,
            children: getItem(),
          ),
        ]));
  }
}
