import 'dart:convert';

ResponseApi responseApiFromMap(String str) =>
    ResponseApi.fromMap(json.decode(str));

String responseApiToMap(ResponseApi data) => json.encode(data.toMap());

class ResponseApi {
  bool? success;
  String? message;
  dynamic data;

  ResponseApi({this.success, this.message, this.data});

  factory ResponseApi.fromMap(Map<String, dynamic> json) => ResponseApi(
      success: json["success"], message: json["message"], data: json["data"]);

  Map<String, dynamic> toMap() =>
      {"success": success, "message": message, "data": data};
}
