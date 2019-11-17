import 'package:flutter/material.dart';
import '../vo/article_vo.dart';
import '../utils/image_helper.dart';
import '../utils/my_colors.dart';
import '../utils/constants.dart';
import 'package:flutter_html/flutter_html.dart';

class ProjectItem extends StatelessWidget {
  final ArticleVO item;

  const ProjectItem({Key key, this.item}) : super(key: key);

  Widget buildTag(String name, int id) {
    return Container(
      height: 30,
      padding: EdgeInsets.only(left: 8, right: 8),
      margin: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(color: MyColors.dividerColor, borderRadius: BorderRadius.circular(4)),
      child: Center(
        child: Text(
          name,
          style: const TextStyle(fontSize: 12, color: MyColors.textColor),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Constants.channel.invokeMethod("toWeb", item.link);
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: MyColors.dividerColor, width: 0.5))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Column(
                children: <Widget>[
                  Html(
                    data:item.title,
                    defaultTextStyle: const TextStyle(fontSize: 16, color: MyColors.titleColor),
                  ),
                  Html(
                    data: item.desc,
                    defaultTextStyle: const TextStyle(fontSize: 14, color: MyColors.textColor),
                  )
                ],
              ),
            ),
            FadeInImage.assetNetwork(
              placeholder: ImageHelper.placeHolder(),
              image: item.envelopePic,
              width: 60,
              height: 100,
              fit: BoxFit.cover,
            )
          ],
        ),
      ),
    );
  }
}

