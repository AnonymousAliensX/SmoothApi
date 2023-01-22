import 'dart:async';
import 'dart:isolate';
import 'package:hive/hive.dart';
import 'package:smooth_api/src/objects_initializer.dart';

/// This class will only be initialised in ExternalApiAdapter.
class ApiIsolate{
  ReceivePort receivePort = ReceivePort();
  Completer sendPortCompleter = Completer();

  /// This method spawns a new isolate and returns a SendPort object
  /// returns [SendPort]
  Future<dynamic> runIsolate() async{
    listenToReceivedData();
    await Isolate.spawn(_worker, receivePort.sendPort);
    return sendPortCompleter.future;
  }

  /// This method listens to data coming from secondary isolate
  /// it also handles receiving of sendPort from secondary isolate
  void listenToReceivedData(){
    receivePort.listen((receivedData) {
      if(receivedData is SendPort){
        sendPortCompleter.complete(receivedData);
      }else{

      }
    });
  }

  /// [static] Method through which all data will be processed in secondary isolate
  static void _worker(SendPort sendPort) async{
    ReceivePort receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    var objs = await ObjectInitializer.get();
    receivePort.listen((incomingData) {
      try{
        /// Putting example call
        /// sendPort.send(await InternalApiAdapter.process(incomingData))
      }catch(e, s){
        print(e);
        print(s);
      }
    });
  }
}

Future<void> main() async {
  final isolate = ApiIsolate();
  SendPort sendPort = await isolate.runIsolate();
  sendPort.send("message");
}