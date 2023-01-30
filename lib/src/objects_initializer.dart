import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class ObjectInitializer {
  bool initialised = false;
  late Box getResponseBox, postResponseBox;
  late http.Client client;
  static late ObjectInitializer _instance;

  ObjectInitializer._() {
    Hive.init("/HttpCache");
    client = http.Client();
    // initialised.
  }

  /// method to give singleton object of [ObjectInitializer] as well as
  /// helping in initialising all async objects inside this.
  static Future<ObjectInitializer> get() async {
    try {
      if (_instance.initialised) {
        return _instance;
      } else {
        return await _initialise();
      }
    } catch (e) {
      return await _initialise();
    }
  }

  static Future<ObjectInitializer> _initialise() async {
    _instance = ObjectInitializer._();
    _instance.getResponseBox = await Hive.openBox("getCache");
    _instance.postResponseBox = await Hive.openBox("postCache");
    _instance.initialised = true;
    return _instance;
  }
}
