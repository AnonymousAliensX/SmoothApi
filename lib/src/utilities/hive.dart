import 'package:hive/hive.dart';
import 'package:smooth_api/src/datamodels/request.dart';
import 'package:smooth_api/src/datamodels/response.dart';
import 'crypto.dart';

Future<void> cacheResponse(Request request, Response response) async{
  var box = await Hive.openBox("responses");
  box.put(generateMd5(request), response.bodyBytes);
}

Future<Response> getCacheResponse(Request request) async {
  String key = generateMd5(request);
  var box = await Hive.openBox("responses");
  return Response.bytes(box.get(key), 400);
}