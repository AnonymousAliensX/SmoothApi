import 'package:smooth_api/src/datamodels/incoming_data.dart';
import 'package:smooth_api/src/datamodels/outgoing_data.dart';

abstract class ResponseCallback{
  void onResponse(ResponseData responseData);
}