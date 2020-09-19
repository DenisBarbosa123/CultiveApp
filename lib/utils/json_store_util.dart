import 'package:json_store/json_store.dart';

class JsonStoreUtil {
  JsonStore jsonStore = JsonStore();

  void saveJson(String key, Map<String, dynamic> mapToSave) async {
    dynamic batch = await jsonStore.startBatch();
    await jsonStore.setItem(key, mapToSave, batch: batch);
    jsonStore.commitBatch(batch);
  }

  Future<Map<String, dynamic>> getJsonByKey(String key) async {
    Map<String, dynamic> userMap = await jsonStore.getItem(key);
    if (userMap == null)
      return null;
    else
      return userMap;
  }

  Future<void> deleteJsonByKey(String key) async {
    await jsonStore.deleteItem(key);
  }
}
