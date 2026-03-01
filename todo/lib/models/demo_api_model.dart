import 'package:todo/utils/global.dart' as global;

class DemoApiModel {
  ////!SECTION Variables
  int? id;
  String? answer;
  ////!SECTION Constructor
  DemoApiModel({this.id, this.answer});
  ////!SECTION fromJson  Function: get Response From Backend side
  DemoApiModel.fromJson(Map<String, dynamic> json) {
    try {
      id = json["id"];
      answer = json["answer"];
    } catch (e) {
      global.exceptionMessage(
        classNameWithoutExt: "demo_api_model.dart",
        functionNameWithoutBraces: "DemoApiModel.fromJson",
        e: e,
      );
    }
  }
  ////!SECTION toJson Function: send Response from App side to Backend
  Map<String, dynamic> toJson() => {"id": id, "answer": answer};
}
