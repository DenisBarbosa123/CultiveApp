import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cultiveapp/model/topico_model.dart';
import 'package:dio/dio.dart';

class TopicApi extends BlocBase {
  StreamController<List<TopicoModel>> _streamController =
      StreamController<List<TopicoModel>>.broadcast();

  Stream<List<TopicoModel>> get output => _streamController.stream;

  String _url() => "https://cultiveapp.herokuapp.com/api/topicos";

  Future<void> getTopicList() async {
    Response response = await Dio().get(_url());
    List<TopicoModel> topicList = topicoModelFromJson(response.data);
    _streamController.sink.add(topicList);
  }

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
  }
}
