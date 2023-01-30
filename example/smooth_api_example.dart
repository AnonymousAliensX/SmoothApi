import 'package:smooth_api/smooth_api.dart';

void main() async {
  var client = SmoothApiClient();
   client.get(Uri.http("google.com"), callback: (response) {
    print("1st");
  });
  await client.get(Uri.http("google.com"), callback: (response) {
    print("2nd");
  });
  // client.get(Uri.http("google.com"),
  //     headers: {"auth": "fdfdfd", "isTrue": "true"}, callback: (response) {
  //       print((response as Response).body);
  //     });
}
