class BannerVO {
  final int id;
  final String title;
  final String desc;
  final int type;
  final String url;
  final String imagePath;

  BannerVO(this.id, this.title, this.desc, this.type, this.url, this.imagePath);

  factory BannerVO.fromJson(Map<dynamic, dynamic> map) {
    return BannerVO(map["id"], map["title"], map["desc"], map["type"], map["url"], map["imagePath"]);
  }
}
