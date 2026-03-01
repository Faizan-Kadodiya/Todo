import 'package:todo/utils/global.dart' as global;

class APIResult<T> {
  String? status;
  bool? isDisplayMessage;
  String? message;
  T? recordList;
  int? totalRecords;
  dynamic value;
  Error? error;

  APIResult({
    required this.status,
    required this.isDisplayMessage,
    required this.message,
    required this.recordList,
    required this.totalRecords,
    required this.value,
    required this.error,
  });

  APIResult.fromJson(Map<String, dynamic> json, T recordList) {
    try {
      status = json["status"].toString();
      isDisplayMessage = json['isDisplayMessage'];
      message = json["message"];
      recordList = recordList;
      totalRecords = json["totalRecords"];
      value = json["value"];
      error = Error.fromJson(json["error"]);
    } catch (e) {
      global.exceptionMessage(
        classNameWithoutExt: "api_result.dart",
        functionNameWithoutBraces: "APIResult.fromJson",
        e: e,
      );
    }
  }
}

class Error {
  String? apiName;
  String? apiType;
  String? fileName;
  dynamic functionName;
  dynamic lineNumber;
  dynamic typeName;
  String? stack;

  Error({
    required this.apiName,
    required this.apiType,
    required this.fileName,
    required this.functionName,
    required this.lineNumber,
    required this.typeName,
    required this.stack,
  });

  Error.fromJson(Map<String, dynamic> json) {
    try {
      apiName = json["apiName"];
      apiType = json["apiType"];
      fileName = json["fileName"];
      functionName = json["functionName"];
      lineNumber = json["lineNumber"];
      typeName = json["typeName"];
      stack = json["stack"];
    } catch (e) {
      global.exceptionMessage(
        classNameWithoutExt: "api_result.dart",
        functionNameWithoutBraces: "Error.fromJson",
        e: e,
      );
    }
  }
}
