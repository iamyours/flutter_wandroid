class WXChapterVO {
  final int id;
  final String name;

  WXChapterVO(this.id, this.name);

  factory WXChapterVO.fromJson(Map<dynamic, dynamic> map) {
    return WXChapterVO(map["id"], map["name"]);
  }
}
