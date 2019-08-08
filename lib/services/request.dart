import 'dart:convert';
import 'dart:io';
class RequestApi{
//  RequestApi();
  getData(String url) async{
    var httpClient = new HttpClient();
    try{
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var json = await response.transform(utf8.decoder).join();
        return jsonDecode(json);
      }else {
        print('Error getting data:\nHttp status ${response.statusCode}');
      }
    }catch(exception){
      print("vision_error:$exception");
    }
  }

}
