import 'package:http/http.dart' as http;

void main() async {
  var url = Uri.http("localhost:5000", "/jobsRaw", {'q': '{http'});

  var response = await http.get(url);

  if (response.statusCode == 200 || response.statusCode == 201) {
    print(response.body);
  } else {
    print('Something bad happened');
  }
}
