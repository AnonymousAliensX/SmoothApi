import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:smooth_api/src/datamodels/request.dart';

String generateMd5(Request request) {
  String strReq =
      request.toString() + request.headers.toString() + request.body.toString();
  return md5.convert(utf8.encode(strReq)).toString();
}
