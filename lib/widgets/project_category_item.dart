import 'package:flutter/material.dart';
import '../vo/project_category_vo.dart';
import '../utils/image_helper.dart';
import '../utils/my_colors.dart';
import 'package:flutter_html/flutter_html.dart';

typedef ProjectCategoryCallback = void Function(int index);

class ProjectCategoryItem extends StatelessWidget {
  final ProjectCategoryVO item;
  final ProjectCategoryCallback callback;
  final int idx;

  const ProjectCategoryItem({Key key, this.item, this.callback, this.idx}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => callback(idx),
      child: Container(
        width: 100,
        height: 44,
        color: item.selected ? MyColors.selectCatetoryColor : null,
        padding: EdgeInsets.only(left: 5, right: 5),
        alignment: Alignment.centerLeft,
        child: Row(
          children: <Widget>[
            ImageHelper.icon("ic_category$idx", width: 15, color: MyColors.tabSelected),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 4),
                child: Html(
                  data: item.name,
                  defaultTextStyle: TextStyle(fontSize: 12, color: MyColors.textColor),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
