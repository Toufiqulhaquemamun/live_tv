import 'package:live_tv/models/tv_categories.dart';
import 'package:live_tv/networking/ApiProvider.dart';
import 'dart:async';

class TvCategoryRepo{
  ApiProvider _apiProvider = ApiProvider();

  Future<tvCategories> fetchtvCategoriesData() async {

    final response = await _apiProvider.get("/category/read.php");
    return tvCategories.fromJson(response);
  }
}