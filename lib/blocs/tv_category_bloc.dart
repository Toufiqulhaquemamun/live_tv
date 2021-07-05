import 'dart:async';

import 'package:live_tv/models/tv_categories.dart';
import 'package:live_tv/networking/Response.dart';
import 'package:live_tv/repository/tv_category_repo.dart';

class TvCategoryBloc {
  TvCategoryRepo _tvCategoryRepo;
  StreamController _controller;

  StreamSink<Response<tvCategories>> get categoryListSink =>
      _controller.sink;

  Stream<Response<tvCategories>> get categoryListStream =>
  _controller.stream;

  TvCategoryBloc(){
    _controller = StreamController<Response<tvCategories>>();
    _tvCategoryRepo = TvCategoryRepo();
    fetchCategories();
  }

  fetchCategories() async {
    categoryListSink.add(Response.loading('Loading Category.'));
    try{
      tvCategories categories = await _tvCategoryRepo.fetchtvCategoriesData();
      categoryListSink.add(Response.completed(categories));
    }
    catch (e) {
      categoryListSink.add(Response.error(e.toString()));
      print(e);
    }

  }
  dispose() {
    _controller?.close();
  }

}