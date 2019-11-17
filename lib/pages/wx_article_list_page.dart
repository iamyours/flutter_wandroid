import 'package:flutter/material.dart';
import '../vo/article_vo.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../widgets/article_item.dart';
import '../repository/wan_repository.dart';
import '../utils/widget_util.dart';

class WxArticleListPage extends StatefulWidget {
  final int id;

  const WxArticleListPage({Key key, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WxArticleListPageState(id);
  }
}

class _WxArticleListPageState extends State<WxArticleListPage> with AutomaticKeepAliveClientMixin {
  RefreshController controller = RefreshController(initialRefresh: true);
  List<ArticleVO> articleList = [];
  int page = 1;
  final int id;

  _WxArticleListPageState(this.id);

  void loadData() async {
    try {
      var articlePage = await WanRepository.wxArticlePage(page, id);
      if (articlePage.curPage == 1) {
        articleList.clear();
      }
      articleList.addAll(articlePage.datas);
      setState(() {});
    } catch (e) {}
    if (page == 1)
      controller.refreshCompleted();
    else
      controller.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SmartRefresher(
      enablePullUp: true,
      onLoading: () {
        page++;
        loadData();
      },
      onRefresh: () {
        page = 1;
        loadData();
      },
      header: ClassicHeader(refreshingIcon: WidgetUtil.loading20),
      footer: ClassicFooter(
        loadingIcon: WidgetUtil.loading20,
      ),
      controller: controller,
      child: ListView.builder(
          itemCount: articleList.length,
          itemBuilder: (ctx, index) => ArticleItem(
                item: articleList[index],
              )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
