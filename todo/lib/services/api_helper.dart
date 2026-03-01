import 'dart:convert';
import 'dart:developer';
import 'package:todo/models/demo_api_model.dart';
import 'package:todo/services/api_result.dart';
import "package:todo/utils/global.dart" as global;
import 'package:http/http.dart' as http;

class APIHelper {
  //bind your api result using it
  // ignore: strict_top_level_inference
  dynamic getAPIResult<T>(final response, T recordList) {
    try {
      dynamic result;
      result = APIResult.fromJson(json.decode(response.body), recordList);
      return result;
    } catch (e) {
      global.exceptionMessage(
        classNameWithoutExt: "api_helper",
        functionNameWithoutBraces: "getAPIResult",
        e: e,
      );
    }
  }

  //get you customers
  Future<dynamic> getCustomers({
    required int startIndex,
    required int fetchRecord,
  }) async {
    try {} catch (e) {
      global.exceptionMessage(
        classNameWithoutExt: "api_helper",
        functionNameWithoutBraces: "getCustomers",
        e: e,
      );
    }
  }

  //add customer
  Future<dynamic> addCustomer(
    String firstName,
    String email,
    String mobile,
    var imagePath,
  ) async {
    try {} catch (e) {
      global.exceptionMessage(
        classNameWithoutExt: "api_helper",
        functionNameWithoutBraces: "addCustomer",
        e: e,
      );
    }
  }

  //edit cutsomer
  Future<dynamic> editCustomer(
    int id,
    String firstName,
    String email,
    String mobile,
    String imagePath,
  ) async {
    try {} catch (e) {
      global.exceptionMessage(
        classNameWithoutExt: "api_helper",
        functionNameWithoutBraces: "editCustomer",
        e: e,
      );
    }
  }

  //remove customer
  Future<dynamic> removeCustomer(int id) async {
    try {} catch (e) {
      global.exceptionMessage(
        classNameWithoutExt: "api_helper",
        functionNameWithoutBraces: "removeCustomer",
        e: e,
      );
    }
  }

  //demo Api
  Future<dynamic> demoApi() async {
    try {
      global.showOnlyLoaderDialog();
      log(
        '${global.appParameters[global.appMode]['apiUrl']}api/partner/faqs/getFaqs',
      );
      final response = await http.post(
        Uri.parse(
          "${global.appParameters[global.appMode]['apiUrl']}api/partner/faqs/getFaqs",
        ),
        // headers: await global.getApiHeaders(true),
        // body: json.encode({}),
      );
      log('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<DemoApiModel>.from(
          json
              .decode(response.body)["recordList"]
              .map((x) => DemoApiModel.fromJson(x)),
        );
      } else {
        recordList = null;
      }
      global.hideLoader();

      return getAPIResult(response, recordList);
    } catch (e) {
      global.hideLoader();
      global.exceptionMessage(
        classNameWithoutExt: "api_helper",
        functionNameWithoutBraces: "demoApi",
        e: e,
      );
    }
  }
}
