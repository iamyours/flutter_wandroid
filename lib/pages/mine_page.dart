import 'package:flutter/material.dart';
import '../utils/my_colors.dart';
import '../utils/image_helper.dart';

class MinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MinePageState();
  }
}

class _MinePageState extends State<MinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.bgDark,
      body: SafeArea(
          child: Column(
        children: <Widget>[
          Center(
            child: Text(
              "我",
              style: const TextStyle(fontSize: 16, color: MyColors.titleColor),
            ),
          ),
          Divider(
            color: MyColors.dividerColor,
            thickness: 0.5,
          ),
          _SetItem(
            icon: "ic_tab_collect_s",
            name: "收藏的文章",
            onTap: () {
              RegExp jianShuReg =  RegExp(r"(<style data-vue-ssr-id=[\s\S]*?>)(.*?)(<\s*/\s*style>)");
              RegExp bodyReg = RegExp(r"<body class=(.*?)>");
              var str = "test<style data-vue-ssr-id=\"275a6f71:0 a9b12c3c:0 eb\">test12312</style><style>sss</style>";
              var item = jianShuReg.firstMatch(str);
              print(item.groupCount);
              print(item.group(0));
              print(item.group(1));
              print(item.group(2));
              print(item.group(3));
              var s = str.replaceFirst(jianShuReg, "test");
              print("==============");
              print(s);

              var bodyStr = "<body class=\"tet\">test</body>";
              print("---------");
              print(bodyStr.replaceFirst(bodyReg, "ttt"));
            },
          )
        ],
      )),
    );
  }
}

class _SetItem extends StatelessWidget {
  final String icon;
  final String name;
  final GestureTapCallback onTap;

  const _SetItem({Key key, this.icon, this.name, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: MyColors.dividerColor, width: 0.5))),
        child: Row(
          children: <Widget>[
            ImageHelper.icon(icon, width: 15),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                name,
                style: const TextStyle(fontSize: 15, color: MyColors.titleColor),
              ),
            )
          ],
        ),
      ),
    );
  }
}
