import 'package:http/http.dart' as http;

class Request extends http.Request{
  late bool returnJson;
  Request(super.method, super.url, {this.returnJson = true});
}