import 'dart:collection';

import 'package:smooth_api/src/callbacks/response_callback.dart';
import 'package:smooth_api/src/datamodels/response.dart';

class CallbackRegistry{

  HashMap<int, ResponseCallback> callbacks = HashMap();

  void addCallback(ResponseCallback responseCallback){
    callbacks.putIfAbsent(generateKey(), () => responseCallback);
  }

  void sendCallback(int key, Response response){
    callbacks.remove(key)?.onResponse(response);
  }

  int generateKey(){
    return DateTime.now().microsecond;
  }
}