import 'package:hive/hive.dart';
import 'crypto.dart';

Future<void> cacheResponse(String request, dynamic response) async{
  var box = await Hive.openBox("responses");
  box.put(generateMd5(request), response);
}

Future<dynamic> getCacheResponse(String request) async {
  String key = generateMd5(request);
  var box = await Hive.openBox("responses");
  return await box.get(key);
}