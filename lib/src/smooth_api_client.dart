import 'dart:async';
import 'dart:convert';
import 'package:smooth_api/src/callback_registry.dart';
import 'package:smooth_api/src/datamodels/incoming_data.dart';
import 'package:smooth_api/src/datamodels/request.dart';

import 'isolate/api_isolate.dart';

class SmoothApiClient{

  Future<void> head(Uri url, {Map<String, String>? headers,
    required Function callback}) =>
      _wrapToRequest('HEAD', url, headers, callback);

  Future<void> get(Uri url, {Map<String, String>? headers,
    required Function callback}) =>
      _wrapToRequest('GET', url, headers, callback);

  Future<void> post(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding,
        required Function callback}) =>
      _wrapToRequest('POST', url, headers, callback, body, encoding);

  Future<void> put(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding,
        required Function callback}) =>
      _wrapToRequest('PUT', url, headers, callback, body, encoding);

  Future<void> patch(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding,
        required Function callback}) =>
      _wrapToRequest('PATCH', url, headers, callback, body, encoding);

  Future<void> delete(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding,
        required Function callback}) =>
      _wrapToRequest('DELETE', url, headers, callback, body, encoding);

  Future<void> _wrapToRequest(String method, Uri url, Map<String, String>? headers,
      Function callback,
      [Object? body, Encoding? encoding]) async{
    var request = Request(method=method, url=url);
    if (headers != null) request.headers.addAll(headers);
    if (encoding != null) request.encoding = encoding;
    if (body != null) {
      if (body is String) {
        request.body = body;
      } else if (body is List) {
        request.bodyBytes = body.cast<int>();
      } else if (body is Map) {
        request.bodyFields = body.cast<String, String>();
      } else {
        throw ArgumentError('Invalid request body "$body".');
      }
    }
    print("Wrapping to Request");
    IncomingData incomingData = IncomingData();
    incomingData.request = request;
    incomingData.callbackKey = CallbackRegistry.addCallback(callback);
    ApiIsolate.send(incomingData);
  }
}