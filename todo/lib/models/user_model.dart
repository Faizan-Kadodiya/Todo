import "package:todo/utils/global.dart" as global;

class UserModel {
  ////!SECTION Variables
  int? id;
  String? sessionToken;
  ////!SECTION Constructor
  UserModel({this.id});
  ////!SECTION fromJson  Function: get Response From Backend side
  UserModel.fromJson(Map<String, dynamic> json) {
    try {
      id = json["id"];
      sessionToken = json["sessionToken"];
    } catch (e) {
      global.exceptionMessage(
        classNameWithoutExt: "user_model.dart",
        functionNameWithoutBraces: "fromJson()",
        e: e,
      );
    }
  }
  ////!SECTION toJson Function: send Response from App side to Backend
  Map<String, dynamic> toJson() => {"id": id, "sessionToken": sessionToken};
}
