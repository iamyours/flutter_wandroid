import 'package:flutter/material.dart';
import '../repository/wan_repository.dart';
import '../utils/my_colors.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../widgets/article_item.dart';
import '../vo/article_vo.dart';
import '../utils/widget_util.dart';
import '../vo/banner_vo.dart';
import '../utils/image_helper.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  RefreshController _controller = RefreshController(initialRefresh: true);
  List<ArticleVO> articles = [];
  List<BannerVO> banners = [];
  int page = 0;

  void _loadData() async {
    if (page == 0) _loadBanner();
    try {
      var data = await WanRepository.articlePage(page);
      if (data.curPage == 1) {
        articles.clear();
      }
      articles.addAll(data.datas);
      setState(() {});
    } catch (e) {}
    if (page == 0)
      _controller.refreshCompleted();
    else
      _controller.loadComplete();
  }

  void _loadBanner() async {
    var list = await WanRepository.bannerList();
    setState(() {
      banners = list;
    });
  }

  Widget buildBanner() {
    return Container(
      height: 160,
      child: banners.length == 0
          ? null
          : Swiper(
              itemCount: banners.length,
              itemBuilder: (BuildContext ctx, int index) {
                return FadeInImage.assetNetwork(
                    placeholder: ImageHelper.placeHolder(), fit: BoxFit.cover, image: banners[index].imagePath);
              },
              onTap: (index) {
                var item = banners[index];
//          Navigator.pushNamed(context, "loan_info", arguments: item);
              },
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: MyColors.bgDark,
        body: SafeArea(
            child: SmartRefresher(
          controller: _controller,
          enablePullUp: true,
          onRefresh: () {
            page = 0;
            _loadData();
          },
          onLoading: () {
            page++;
            _loadData();
          },
          header: ClassicHeader(refreshingIcon: WidgetUtil.loading20),
          footer: ClassicFooter(
            loadingIcon: WidgetUtil.loading20,
          ),
          child: ListView.builder(
              itemCount: articles.length + 1,
              itemBuilder: (ctx, index) {
                if (index == 0) {
                  return buildBanner();
                } else {
                  return ArticleItem(item: articles[index - 1]);
                }
              }),
        )));
  }

  @override
  bool get wantKeepAlive => true;
}
