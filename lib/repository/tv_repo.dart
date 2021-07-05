import 'package:live_tv/models/tv_response.dart';
import 'package:live_tv/networking/ApiProvider.dart';
import 'dart:async';

class TvRepo{
  ApiProvider _apiProvider =ApiProvider();

  Future<tvResponse> fetchTvResponse () async {

    final response = await _apiProvider.get("/product/read.php");
    return tvResponse.fromJson(response);
  }
}