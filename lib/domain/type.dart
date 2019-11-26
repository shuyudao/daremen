/**
 * Type类型
 */

class Type {
  
  //id
  String id;

  //名称
  String name;

  //排序号
  String sort;

  //type
  String type;

  bool isC = false;

  Type(
    this.id,
    this.name,
    this.sort,
    this.type
  );

  Map toJson() {
    Map map = new Map();
    map["id"] = this.id;
    map["name"] = this.name;
    map['sort'] = this.sort;
    map['type'] = this.type;
    map['isC'] = this.isC;
    return map;
  }

}