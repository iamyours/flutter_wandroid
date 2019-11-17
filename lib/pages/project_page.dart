import 'package:flutter/material.dart';
import '../utils/my_colors.dart';
import '../widgets/project_category_item.dart';
import '../vo/project_category_vo.dart';
import '../repository/wan_repository.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../utils/widget_util.dart';
import '../vo/article_vo.dart';
import '../widgets/project_item.dart';

class ProjectPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProjectPageState();
  }
}

class _ProjectPageState extends State<ProjectPage> with AutomaticKeepAliveClientMixin{
  List<ProjectCategoryVO> categories = [];
  List<ArticleVO> articleList = [];
  RefreshController _controller = RefreshController();
  int page = 1;
  int projectId = 0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    var list = await WanRepository.projectTree();
    setState(() {

      categories = list;
    });
    if (list.length > 0) loadCategory(0);
  }

  void loadCategory(int index) {
    print("index");
    for (var i = 0; i < categories.length; i++) {
      categories[i].selected = index == i;
    }
    setState(() {});
    page = 1;
    projectId = categories[index].id;
    _controller.requestRefresh();
  }

  void loadProjects() async {
    try {
      var articlePage = await WanRepository.projectArticlePage(page, projectId);
      if (articlePage.curPage == 1) {
        setState(() {
          articleList.clear();
        });
      }

      setState(() {
        articleList.addAll(articlePage.datas);
      });
    } catch (e) {}
    _controller.loadComplete();
    _controller.refreshCompleted();
  }

  Widget buildLeft() {
    return Container(
      width: 100,
      child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (ctx, index) => ProjectCategoryItem(
                item: categories[index],
                idx: index,
                callback: (_index) {
                  loadCategory(_index);
                },
              )),
    );
  }

  Widget buildRight() {
    return Expanded(
      child: SafeArea(
          child: SmartRefresher(
        controller: _controller,
        enablePullUp: true,
        onRefresh: () {
          page = 1;
          loadProjects();
        },
        onLoading: () {
          page++;
          loadProjects();
        },
        header: ClassicHeader(refreshingIcon: WidgetUtil.loading20),
        footer: ClassicFooter(
          loadingIcon: WidgetUtil.loading20,
        ),
        child: ListView.builder(
            itemCount: articleList.length,
            itemBuilder: (ctx, index) {
              return ProjectItem(item: articleList[index]);
            }),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: MyColors.bgDark,
      body: SafeArea(
          child: Row(
        children: <Widget>[buildLeft(), buildRight()],
      )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
