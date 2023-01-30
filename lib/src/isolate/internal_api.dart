import 'dart:async';
import 'dart:isolate';

import 'package:smooth_api/src/datamodels/incoming_data.dart';
import 'package:smooth_api/src/datamodels/outgoing_data.dart';
import 'package:smooth_api/src/datamodels/request.dart';
import 'package:smooth_api/src/datamodels/response.dart';
import 'package:smooth_api/src/objects_initializer.dart';
import 'package:smooth_api/src/utilities/hive.dart';

class InternalApi {
  static Future<void> returnCache(
      int key, Request request, SendPort sendPort) async {
    Completer<void> completer = Completer();
    try {
      Response resp = await getCacheResponse(request);
      resp.isCache = true;
      OutgoingData outgoingData = OutgoingData();
      outgoingData.callbackKey = key;
      outgoingData.response = resp;
      sendPort.send(outgoingData);
      completer.complete();
    } catch (ignored) {
      completer.complete();
    }
    return completer.future;
  }

  static Future<Response> getResponse(Request request) async {
    return Response.fromStream(
        await (await ObjectInitializer.get()).client.send(request));
  }

  static Future<OutgoingData> process(
      IncomingData incomingData, SendPort sendPort) async {
    OutgoingData outgoingData = OutgoingData();
    outgoingData.callbackKey = incomingData.callbackKey;
    await returnCache(outgoingData.callbackKey, incomingData.request, sendPort);
    outgoingData.response = await getResponse(incomingData.request);
    cacheResponse(incomingData.request, outgoingData.response);
    return outgoingData;
  }
}
