import 'dart:async';
import 'dart:isolate';
import 'package:smooth_api/src/callback_registry.dart';
import 'package:smooth_api/src/datamodels/incoming_data.dart';
import 'package:smooth_api/src/datamodels/outgoing_data.dart';
import 'package:smooth_api/src/objects_initializer.dart';

import 'internal_api.dart';

/// This class will only be initialised in ExternalApiAdapter.
class ApiIsolate {
  ReceivePort receivePort = ReceivePort();
  ReceivePort errorReceivePort = ReceivePort();
  late SendPort sendPort;
  Completer sendPortCompleter = Completer();
  static ApiIsolate? _instance;

  static Future<ApiIsolate?> get() async {
    if (_instance != null) {
      return _instance;
    }
    _instance = ApiIsolate();
    _instance?.sendPort = await _instance?.runIsolate();
    return _instance;
  }

  /// This method spawns a new isolate and returns a SendPort object
  /// returns [SendPort]
  Future<dynamic> runIsolate() async {
    listenToReceivedData();
    var isolate = await Isolate.spawn(_worker, receivePort.sendPort);
    isolate.addErrorListener(errorReceivePort.sendPort);
    return sendPortCompleter.future;
  }

  /// This method listens to data coming from secondary isolate
  /// it also handles receiving of sendPort from secondary isolate
  void listenToReceivedData() {
    receivePort.listen((receivedData) {
      if (receivedData is SendPort) {
        sendPortCompleter.complete(receivedData);
      } else {
        var outgoingData = receivedData as OutgoingData;
        CallbackRegistry.sendCallback(
            outgoingData.callbackKey, outgoingData.response);
      }
    });

    errorReceivePort.listen((message) {
      print("Error in api isolate");
      print(message);
    });
  }

  /// [static] Method through which all data will be processed in secondary isolate
  static void _worker(SendPort sendPort) async {
    ReceivePort receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    await ObjectInitializer.get();
    receivePort.listen((incomingData) async {
      try {
        print("Worker got Work");

        /// Putting example call
        sendPort.send(await InternalApi.process(incomingData, sendPort));
      } catch (e, s) {
        print(e);
        print(s);
      }
    });
  }

  /// [static] method to send the incoming request data to secondary isolate
  static void send(IncomingData incomingData) async {
    (await ApiIsolate.get())?.sendPort.send(incomingData);
  }
}

Future<void> main() async {
  final isolate = ApiIsolate();
  SendPort sendPort = await isolate.runIsolate();
  sendPort.send("message");
  sendPort.send("message");
}
