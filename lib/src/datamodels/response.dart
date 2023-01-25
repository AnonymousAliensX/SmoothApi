import 'package:http/http.dart' as http;

class Response extends http.Response{
  Response(super.body, super.statusCode);
}
