import 'dart:collection';

import 'package:smooth_api/src/callbacks/response_callback.dart';
import 'package:smooth_api/src/datamodels/outgoing_data.dart';

class CallbackRegistry{

  HashMap<int, ResponseCallback> callbacks = HashMap();

  void addCallback(ResponseCallback responseCallback){
    callbacks.putIfAbsent(generateKey(), () => responseCallback);
  }

  void sendCallback(int key, ResponseData responseData){
    callbacks.remove(key)?.onResponse(responseData);
  }

  int generateKey(){
    return DateTime.now().microsecond;
  }
}