import 'package:json_store/json_store.dart';

class JsonStoreUtil {
  JsonStore jsonStore = JsonStore();

  void saveJson(String key, Map<String, dynamic> mapToSave) async {
    await jsonStore.setItem(key, mapToSave);
  }

  Future<Map<String, dynamic>> getJsonByKey(String key) async {
    return await jsonStore.getItem(key);
  }

  Future<void> deleteJsonByKey(String key) async {
    await jsonStore.deleteItem(key);
  }
}
