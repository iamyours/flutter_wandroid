class ProjectCategoryVO {
  final int id;
  final String name;
  String icon;
  bool selected = false;

  ProjectCategoryVO(this.id, this.name);

  factory ProjectCategoryVO.fromJson(Map<dynamic, dynamic> map) {
    return ProjectCategoryVO(map["id"], map["name"]);
  }
}
