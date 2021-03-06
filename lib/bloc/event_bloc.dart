import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cultiveapp/model/event_model.dart';
import 'package:cultiveapp/utils/path_constants.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EventBloc extends BlocBase {
  List<Event> events = [];
  StreamController<List<Event>> _listEventsController =
      StreamController<List<Event>>.broadcast();

  Stream<List<Event>> get output => _listEventsController.stream;

  StreamController<List<Event>> _searchListEventsController =
      StreamController<List<Event>>.broadcast();

  Stream<List<Event>> get search => _searchListEventsController.stream;

  void getListEvent() async {
    print("Loading Events From Cultive App server");
    Response response = await Dio().get(PathConstants.getAllEvents());
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

  void editEvent(
      {String token,
      int eventId,
      Event event,
      VoidCallback onSuccess,
      VoidCallback onFail}) async {
    print("Editing event...");
    print("payload: ${event.toJson()}");
    try {
      Response response = await Dio().put(
          PathConstants.editEvent(eventId.toString()),
          data: event.toJson(),
          options: RequestOptions(headers: {"Authorization": token}));
      if (response.statusCode == 200) {
        print("Event edited with successfully");
        onSuccess();
      } else {
        print("Fault during editing event");
        onFail();
      }
    } catch (e) {
      print("Exception during edit event" + e.toString());
      onFail();
    }
  }

  Future<void> deleteEvent(
      {String token,
      Event event,
      VoidCallback onDeleteSuccess,
      VoidCallback onDeleteFail}) async {
    print("Delete performing to exclude event with id ${event.id}");
    try {
      deleteEventPhoto(event.imagem);
      Response response = await Dio().delete(
          PathConstants.deleteEvent(event.id.toString()),
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

  Future<void> deleteEventPhoto(String imageUrl) async {
    if (imageUrl == null) {
      return;
    }

    StorageReference storageReference = await FirebaseStorage.instance
        .ref()
        .getStorage()
        .getReferenceFromUrl(imageUrl);
    storageReference.delete().then((value) => print("deleted event photo"));
  }

  bool isMine(int myUserId, int userId) {
    return myUserId == userId;
  }

  @override
  void dispose() {
    super.dispose();
    _listEventsController.close();
    _searchListEventsController.close();
  }

  Future<void> getSearchListEvents(int filter, String query) async {
    _searchListEventsController.add(null);
    Response response = await Dio().get(_prepareEndPoint(filter, query));
    if (response.statusCode == 200) {
      var jsonDecoded = response.data;
      List<Event> newEvents = [];
      newEvents = jsonDecoded.map<Event>((map) {
        return Event.fromJson(map);
      }).toList();
      events.addAll(newEvents);
      _searchListEventsController.add(events);
    } else {
      throw Exception("Failed to load the sales!");
    }
  }

  String _prepareEndPoint(int filter, String query) {
    String endPoint;
    switch (filter.toString()) {
      case '0':
        {
          endPoint = PathConstants.getEventsByParameter('corpo', query);
        }
        break;
      default:
        {
          endPoint = PathConstants.getAllEvents();
        }
        break;
    }
    return endPoint;
  }
}
