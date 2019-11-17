import '../http/http_manager.dart';
import 'dart:async';
import '../vo/page_vo.dart';
import '../vo/article_vo.dart';
import '../vo/banner_vo.dart';
import '../vo/project_category_vo.dart';
import '../vo/wx_chapter_vo.dart';

class WanRepository {
  /*
    首页文章列表
   */
  static Future<PageVO<ArticleVO>> articlePage(int page) async {
    var res = await HttpManager.get("article/list/$page/json", {});
    return toArticlePage(res);
  }

  static PageVO<ArticleVO> toArticlePage(Map<String, dynamic> res) {
    var data = res["data"];
    var list = data["datas"].map<ArticleVO>((item) => ArticleVO.fromJson(item)).toList();
    return PageVO(data["curPage"], list, data["offset"], data["over"], data["pageCount"], data["size"], data["total"]);
  }

  /*
   * banner数据
   */
  static Future<List<BannerVO>> bannerList() async {
    var res = await HttpManager.get("banner/json", {});
    return res["data"].map<BannerVO>((map) => BannerVO.fromJson(map)).toList();
  }

  /*
   * 项目分类
   */
  static Future<List<ProjectCategoryVO>> projectTree() async {
    var res = await HttpManager.get("project/tree/json", {});
    return res["data"].map<ProjectCategoryVO>((map) => ProjectCategoryVO.fromJson(map)).toList();
  }

  /*
   * 项目分类下项目列表
   */
  static Future<PageVO<ArticleVO>> projectArticlePage(int page, int pid) async {
    var res = await HttpManager.get("project/list/$page/json", {"cid": pid});
    return toArticlePage(res);
  }

  /*
   * 微信文章列表
   */
  static Future<PageVO<ArticleVO>> wxArticlePage(int page, int id) async {
    var res = await HttpManager.get("wxarticle/list/$id/$page/json", {});
    return toArticlePage(res);
  }

  static Future<List<WXChapterVO>> wxChapters() async {
    var res = await HttpManager.get("wxarticle/chapters/json", {});
    return res["data"].map<WXChapterVO>((item) => WXChapterVO.fromJson(item)).toList();
  }
}
