import 'package:smooth_api/smooth_api.dart';

void main() async{
  var client = SmoothApiClient();
  await client.get(Uri.http("google.com"), callback: (response){
    print(response);
  });
}
