import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_app/domain/type.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainProvider with ChangeNotifier {//1

  List<Type> typeList;
  List<Type> myList;

  setTypeList(List<Type> data){
    typeList = data;
  }
  setMyList(List<Type> data){
    myList = data;
  }

  updateList(Type data) async{
    for(var i = 0 ; i <= typeList.length ; i++){
      if(data.name == typeList[i].name){
        typeList[i].isC = data.isC;
        break;
      }
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList("mylist");
    if(data.isC){
      list.add(json.encode(data));
    }else{
      for(String s in list){
        if(s.indexOf(data.name)>-1){
          list.remove(s);
          break;
        }
      }
    }
    prefs.setStringList("mylist", list);
    
  }

}