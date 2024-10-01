import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:griot_legacy_social_media_app/src/models/alluserlistmodel.dart';
import 'package:griot_legacy_social_media_app/src/repos/user_repos.dart';
import 'package:griot_legacy_social_media_app/src/utils/constant_class.dart';
import 'package:http/http.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:griot_legacy_social_media_app/src/models/reply.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';

import '../models/track_show_response_model.dart';

final gc = GlobalConfiguration();

Future<Reply> addPost(Map<String, dynamic> body) async {
  final response = await post(
      Uri.parse(Constant.CREATE_POST_URL),

      // Uri.parse("https://nodeserver.mydevfactory.com:2109/api/" + "post/createPost"),
      body: body);
  return Reply.fromMap(json.decode(response.body));
}

Future<Reply> createNormalPost(Map<String, dynamic> body,bool isEdit) async {
  try {
    final prefs = await sharedPrefs;

   // print("${Uri.parse(Constant.UPDATE_POST_URL) }  \n $body");

    final response = await post(
        isEdit ?Uri.parse(Constant.UPDATE_POST_URL) :Uri.parse(Constant.CREATE_POST_URL),
        //Uri.parse("https://nodeserver.mydevfactory.com:2109/api/post/createPost"),
        body: body,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + prefs.getString("spAuthToken")
        });
    return Reply.fromMap(json.decode(response.body));
  } catch (e) {
    rethrow;
  }
}



Future<AllUserListModel> getAllUserData(Map<String, dynamic> body) async {
  //print(body);
  try {
    final prefs = await sharedPrefs;
    final response = await post(
        Uri.parse(Constant.GET_USER_URL),
        //Uri.parse("https://nodeserver.mydevfactory.com:2109/api/user/getUser"),
        body: body,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + prefs.getString("spAuthToken")
        });
    //print(response.body);
    log(response.body);
    return AllUserListModel.fromJson(json.decode(response.body));
  } catch (e) {
   // print(e);
    rethrow;
  }
}


Future<TrackUsageResponseModel> getShowUsage(Map<String, dynamic>  body) async {
 // print("body   ${Constant.appUsageUrl} $body");
  try {
    final response = await post(
        Uri.parse(Constant.appUsageUrl),
        body: body,
        headers: {
          "Content-Type":"application/x-www-form-urlencoded",
          'Accept': 'application/json',
        }
        );
    //print(response.body);
    log("response.body   ${response.body}");
    return TrackUsageResponseModel.fromJson(json.decode(response.body));
  } catch (e) {
    // print(e);
    rethrow;
  }
}

Future<Reply> createFilePost(Map<String, String> body, String filePath,bool isEdit) async {
  var request = http.MultipartRequest(
      'POST',isEdit ?Uri.parse(Constant.UPDATE_POST_URL)    :Uri.parse(Constant.CREATE_POST_URL));
     // Uri.parse("https://nodeserver.mydevfactory.com:2109/api/post/createPost"));
  //request.headers.
  //print("${Uri.parse(Constant.UPDATE_POST_URL) }  \n $body");
  request.fields.addAll(body);
  request.files.add(await http.MultipartFile.fromPath('image', filePath));
  http.StreamedResponse response = await request.send();
  String resp;
  if (response.statusCode == 200) {
    resp = await response.stream.bytesToString();
  } else {
   // print(response.reasonPhrase);
  }
  return Reply.fromMap(json.decode(resp));
}

Future<Reply> createFileWithThumbUrl(Map<String, String> body, String filePath,String thumb,isEdit) async {
  //print("${Uri.parse(Constant.UPDATE_POST_URL) }  \n $body");

  var request = http.MultipartRequest(
      'POST',  isEdit ?Uri.parse(Constant.UPDATE_POST_URL) :Uri.parse(Constant.CREATE_POST_URL));
      //Uri.parse("https://nodeserver.mydevfactory.com:2109/api/post/createPost"));
  //request.headers.
  request.fields.addAll(body);
 // print("3333333333");

  request.files.add(await http.MultipartFile.fromPath('image', filePath,));
 // print("44444444444");
 request.files.add(await http.MultipartFile.fromPath('thumb', thumb));
 // print("555555555");

  http.StreamedResponse response = await request.send();
  //print("6666666666");

  String resp;
  if (response.statusCode == 200) {
   // print("respsneeeeeeee");
    resp = await response.stream.bytesToString();
   // print("respsneeeeeeee    $resp");

  } else {
    //print("elssssssssssss");

   // print(response.reasonPhrase);
  }
  return Reply.fromMap(json.decode(resp));
}


Future<Reply> uploadMultipleImage(Map<String, String> body,List<File> files,bool isEdit) async {

  //print("${Uri.parse(Constant.UPDATE_POST_URL) }  \n $body");
// string to uri

// create multipart request
//print("files.... ${files.length}");
  var request = http.MultipartRequest(
      'POST',
      isEdit ?Uri.parse(Constant.UPDATE_POST_URL) : Uri.parse(Constant.CREATE_POST_URL));
      //Uri.parse("https://nodeserver.mydevfactory.com:2109/api/post/createPost"));
//print("request.... ${request}");

  for (var file in files) {
    String fileName = file.path.split("/").last;
    var stream =  http.ByteStream(DelegatingStream.typed(file.openRead()));

    // get file length

    var length = await file.length(); //imageFile is your image file

    // multipart that takes file
    var multipartFileSign =  http.MultipartFile('image', stream, length, filename: fileName);
   // print("multipartFileSign..... ${multipartFileSign}");

    request.files.add(multipartFileSign);
  }

for(var index in body.entries) {
  request.fields[index.key] = index.value;

}

//request.fields.addAll(body);

//print("request....   ${request.files.length}");
  http.StreamedResponse response = await request.send();
  String resp;
  if (response.statusCode == 200) {
   // print("response.statusCode    ${response.statusCode}");
    resp = await response.stream.bytesToString();
  } else {
    //print(response.reasonPhrase);
  }
  return Reply.fromMap(json.decode(resp));
}

Future<Reply> uploadMultipleImageWithThumb(Map<String, String> body,List<File> files,String thumb,bool isEdit) async {

 // print("${Uri.parse(Constant.UPDATE_POST_URL) }  \n $body");
// string to uri

// create multipart request
 // print("files.... ${files.length}");
  var request = http.MultipartRequest(
      'POST',
      isEdit ?Uri.parse(Constant.UPDATE_POST_URL) : Uri.parse(Constant.CREATE_POST_URL));
  //Uri.parse("https://nodeserver.mydevfactory.com:2109/api/post/createPost"));
  //print("request.... ${request}");

  for (var file in files) {
    String fileName = file.path.split("/").last;
    var stream =  http.ByteStream(DelegatingStream.typed(file.openRead()));

    // get file length

    var length = await file.length(); //imageFile is your image file

    // multipart that takes file
    var multipartFileSign =  http.MultipartFile('image', stream, length, filename: fileName);
   // print("multipartFileSign..... ${multipartFileSign}");

    request.files.add(multipartFileSign);

  }
  request.files.add(await http.MultipartFile.fromPath('thumb', thumb));


  for(var index in body.entries) {
    request.fields[index.key] = index.value;

  }

//request.fields.addAll(body);

  //print("request....   ${request.files.length}");
  http.StreamedResponse response = await request.send();
  String resp;
  if (response.statusCode == 200) {
 //   print("response.statusCode    ${response.statusCode}");
    resp = await response.stream.bytesToString();
  } else {
    //print(response.reasonPhrase);
  }
  return Reply.fromMap(json.decode(resp));
}


