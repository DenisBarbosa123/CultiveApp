import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cultiveapp/model/event_model.dart';
import 'package:cultiveapp/utils/path_constants.dart';
import 'package:dio/dio.dart';

class EventBloc extends BlocBase{
  List<Event> events = [];
  StreamController<List<Event>> _listEventsController =
  StreamController<List<Event>>();

  Stream<List<Event>> get output => _listEventsController.stream;

  void getListEvent() async {
    print("Loading Events From Cultive App server");
    Response response = await Dio().get(
        PathConstants.getAllEvents());
    if (response.statusCode == 200) {
      print("Everything ok with Events API response");
      var jsonDecoded = response.data;
      List<Event> newEvents = [];
      newEvents = jsonDecoded.map<Event>((map) {
        return Event.fromJson(map);
      }).toList();
      events.addAll(newEvents);
      _listEventsController.add(events);
    } else {
      throw Exception("Failed to load the sales!");
    }
  }

  void createEvent(
      {int userId,
        String token,
        Event event,
        VoidCallback onSuccess,
        VoidCallback onFail}) async {
    print("Saving event...");
    try {
      Response response = await Dio().post(
          PathConstants.createEvent(userId.toString()),
          data: event.toJson(),
          options: RequestOptions(headers: {"Authorization": token}));
      if (response.statusCode == 200) {
        print("Event saved with successfully");
        Event eventCreated = Event.fromJson(response.data);
        events.add(eventCreated);
        _listEventsController.add(events);
        onSuccess();
      } else {
        print("Fault during saving event");
        onFail();
      }
    } catch (e) {
      print("Exception during event sale" + e.toString());
      onFail();
    }
  }

  Future<void> deleteEvent(
      {String token,
        int eventId,
        VoidCallback onDeleteSuccess,
        VoidCallback onDeleteFail}) async {
    print("Delete performing to exclude event with id $eventId");
    try {
      Response response = await Dio().delete(
          PathConstants.deleteEvent(eventId.toString()),
          options: RequestOptions(headers: {"Authorization": token}));
      if (response.statusCode == 204) {
        print("Event was excluded successfully");
        onDeleteSuccess();
      } else {
        print("Error during event exclusion");
        onDeleteFail();
      }
    } catch (e) {
      print("Exception during event exclusion");
      onDeleteFail();
    }
  }

  bool isMine(int myUserId, int userId) {
    return myUserId == userId;
  }

  @override
  void dispose() {
    super.dispose();
    _listEventsController.close();
  }
}