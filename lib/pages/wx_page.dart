import 'package:flutter/material.dart';
import '../utils/my_colors.dart';
import '../vo/wx_chapter_vo.dart';
import 'wx_article_list_page.dart';
import '../utils/widget_util.dart';
import '../repository/wan_repository.dart';

class WXPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WXPageState();
  }
}

class _WXPageState extends State<WXPage> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  List<WXChapterVO> chapters = [];
  TabController _controller;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    var list = await WanRepository.wxChapters();

    setState(() {
      chapters = list;
      _controller = TabController(length: chapters.length, vsync: this);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: MyColors.bgDark,
        body: chapters.length > 0
            ? SafeArea(
                child: Column(
                  children: <Widget>[
                    TabBar(
                      controller: _controller,
                      labelColor: MyColors.tabSelected,
                      indicatorColor: MyColors.tabSelected,
                      unselectedLabelColor: MyColors.tabUnSelected,
                      isScrollable: true,
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: chapters
                          .map<Widget>((c) => Padding(
                                padding: EdgeInsets.only(top: 5, bottom: 5),
                                child: Text(
                                  c.name,
                                ),
                              ))
                          .toList(),
                    ),
                    Expanded(
                      flex: 1,
                      child: TabBarView(
                          controller: _controller,
                          children: chapters
                              .map<WxArticleListPage>((c) => WxArticleListPage(
                                    id: c.id,
                                  ))
                              .toList()),
                    )
                  ],
                ),
              )
            : Center(
                child: WidgetUtil.loading20,
              ));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
