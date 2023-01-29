import 'dart:collection';

import 'package:smooth_api/src/datamodels/response.dart';

class CallbackRegistry{

  static HashMap<int, Function> callbacks = HashMap();

  static int addCallback(Function responseCallback){
    int key = generateKey();
    callbacks.putIfAbsent(key, () => responseCallback);
    return key;
  }

  static void sendCallback(int key, Response response){
    if(response.isCache){
      callbacks[key]?.call(response);
      return;
    }
    callbacks.remove(key)?.call(response);
  }

  static int generateKey(){
    return DateTime.now().microsecondsSinceEpoch;
  }
}