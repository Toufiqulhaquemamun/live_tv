
import 'dart:async';
import 'package:live_tv/models/tv_response.dart';
import 'package:live_tv/networking/Response.dart';
import 'package:live_tv/repository/tv_repo.dart';

class TvBloc{
  TvRepo _tvRepo;
  StreamController _streamController;

  StreamSink<Response<tvResponse>> get tvDataSink =>
      _streamController.sink;

  Stream<Response<tvResponse>> get tvDataStream =>
      _streamController.stream;

  TvBloc() {
    _streamController = StreamController<Response<tvResponse>>();
    _tvRepo = TvRepo();
    fetchTv();
  }
  fetchTv() async {
    tvDataSink.add(Response.loading('Loading..'));
    try {
      tvResponse response = await _tvRepo.fetchTvResponse();
      tvDataSink.add(Response.completed(response));
    }
    catch (e) {
      tvDataSink.add(Response.error(e.toString()));
      print(e);
    }
  }
    dispose(){
      _streamController?.close();
    }
}


