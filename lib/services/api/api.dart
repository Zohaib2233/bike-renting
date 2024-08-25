import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bike_gps/core/enums/network_status.dart';
import 'package:bike_gps/core/utils/network_connectivity.dart';
import 'package:bike_gps/core/utils/snackbars.dart';
import 'package:http/http.dart' as http;

Map<String, String> basicHeaderInfo() => {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/json",
    };

Future<Map<String, String>> bearerHeaderInfo() async {
  // String accessToken = box.read('token');
  String accessToken = "";

  return {
    HttpHeaders.acceptHeader: "application/json",
    HttpHeaders.contentTypeHeader: "application/json",
    HttpHeaders.authorizationHeader: "Bearer $accessToken",
  };
}

class APIService {
  // Private constructor
  APIService._privateConstructor();

  // Singleton instance variable
  static APIService? _instance;

  //This code ensures that the singleton instance is created only when it's accessed for the first time.
  //Subsequent calls to APIService.instance will return the same instance that was created before.

  // Getter to access the singleton instance
  static APIService get instance {
    _instance ??= APIService._privateConstructor();
    return _instance!;
  }

  //method to check if the device is connected to internet
  Future<bool> isConnectedToInternet() async {
    NetworkStatus networkStatus =
        await NetworkConnectivity.instance.getNetworkStatus();

    if (networkStatus == NetworkStatus.online) {
      return true;
    } else {
      return false;
    }
  }

  // Get method
  Future<Map<String, dynamic>?> get(
    String url,
    bool isBasic, {
    int successCode = 200,
    int duration = 15,
    bool showResult = false,
  }) async {
    //checking if the device is connected to internet
    bool isConnected = await isConnectedToInternet();

    if (isConnected == false) {
      CustomSnackBars.instance.showFailureSnackbar(
          title: "No Internet Connection",
          message: "Please check your internet connection and try again!");
      return null;
    }

    try {
      final response = await http
          .get(
            Uri.parse(url),
            headers: isBasic ? basicHeaderInfo() : await bearerHeaderInfo(),
          )
          .timeout(Duration(seconds: duration));

      if (showResult) {
        log("GET API RESPONSE ($url): ${response.body}");
        log("GET API STATUS CODE ($url): ${response.statusCode}");
      }

      if (response.statusCode == successCode) {
        return jsonDecode(response.body);
      } else {
        log('Get API call failed with status code ($url): ${response.statusCode}');

        // ErrorResponse res = ErrorResponse.fromJson(jsonDecode(response.body));

        // CustomSnackBar.error(res.message!.error!.first.toString());

        return jsonDecode(response.body);
      }
    } on SocketException {
      log('Error Alert on Socket Exception ($url)');

      CustomSnackBars.instance.showFailureSnackbar(
          title: "Failure",
          message: "Check your Internet Connection and try again!");

      return null;
    } on TimeoutException {
      log('Error Alert Timeout Exception ($url)');

      CustomSnackBars.instance.showFailureSnackbar(
          title: "Request Timeout", message: "Something Went Wrong! Try Again");

      return null;
    } on http.ClientException catch (err, stackrace) {
      log('Error Alert Client Exception ($url)');

      log(err.toString());

      log(stackrace.toString());

      CustomSnackBars.instance.showFailureSnackbar(
          title: "Client Exception",
          message: "Something Went Wrong! Try Again");

      return null;
    } catch (e) {
      log("This exception occured while hitting Get API call ($url): $e");

      return null;
    }
  }

  // Post Method
  Future<Map<String, dynamic>?> post(
    String url,
    Map<String, dynamic> body,
    bool isBasic, {
    int successCode = 200,
    int duration = 30,
    bool showResult = false,
    Map<String, String>? headers,
  }) async {
    //checking if the device is connected to internet
    bool isConnected = await isConnectedToInternet();

    if (isConnected == false) {
      CustomSnackBars.instance.showFailureSnackbar(
          title: "No Internet Connection",
          message: "Please check your internet connection and try again!");
      return null;
    }
    try {
      final response = await http
          .post(
            Uri.parse(url),
            body: jsonEncode(body),
            headers: isBasic ? basicHeaderInfo() : headers,
          )
          .timeout(Duration(seconds: duration));

      if (showResult) {
        log("POST API RESPONSE ($url): ${response.body}");
        log("POST API STATUS CODE ($url): ${response.statusCode}");
      }

      if (response.statusCode == successCode) {
        return jsonDecode(response.body);
      } else {
        log('POST API call failed with status code ($url): ${response.statusCode}');

        // ErrorResponse res = ErrorResponse.fromJson(jsonDecode(response.body));

        // CustomSnackBar.error(res.message!.error!.first.toString());

        return jsonDecode(response.body);
      }
    } on SocketException {
      log('Error Alert on Socket Exception ($url)');

      CustomSnackBars.instance.showFailureSnackbar(
          title: "Failure",
          message: "Check your Internet Connection and try again!");

      return null;
    } on TimeoutException {
      log('Error Alert Timeout Exception ($url)');

      CustomSnackBars.instance.showFailureSnackbar(
          title: "Request Timeout", message: "Something Went Wrong! Try Again");

      return null;
    } on http.ClientException catch (err, stackrace) {
      log('Error Alert Client Exception ($url)');

      log(err.toString());

      log(stackrace.toString());

      CustomSnackBars.instance.showFailureSnackbar(
          title: "Client Exception",
          message: "Something Went Wrong! Try Again");

      return null;
    } catch (e) {
      log("This exception occured while hitting Post API call ($url): $e");

      return null;
    }
  }

  // Post Method with string response
  Future<String?> postWithStringResponse(
    String url,
    Map<String, dynamic> body,
    bool isBasic, {
    int successCode = 200,
    int duration = 30,
    bool showResult = false,
    Map<String, String>? headers,
  }) async {
    //checking if the device is connected to internet
    bool isConnected = await isConnectedToInternet();

    if (isConnected == false) {
      CustomSnackBars.instance.showFailureSnackbar(
          title: "No Internet Connection",
          message: "Please check your internet connection and try again!");
      return null;
    }
    try {
      final response = await http
          .post(
            Uri.parse(url),
            body: jsonEncode(body),
            headers: isBasic ? basicHeaderInfo() : headers,
          )
          .timeout(Duration(seconds: duration));

      if (showResult) {
        log("POST API RESPONSE ($url): ${response.body}");
        log("POST API STATUS CODE ($url): ${response.statusCode}");
      }

      if (response.statusCode == successCode) {
        return response.body;
      } else {
        log('POST API call failed with status code ($url): ${response.statusCode}');

        // ErrorResponse res = ErrorResponse.fromJson(jsonDecode(response.body));

        // CustomSnackBar.error(res.message!.error!.first.toString());

        return response.body;
      }
    } on SocketException {
      log('Error Alert on Socket Exception ($url)');

      CustomSnackBars.instance.showFailureSnackbar(
          title: "Failure",
          message: "Check your Internet Connection and try again!");

      return null;
    } on TimeoutException {
      log('Error Alert Timeout Exception ($url)');

      CustomSnackBars.instance.showFailureSnackbar(
          title: "Request Timeout", message: "Something Went Wrong! Try Again");

      return null;
    } on http.ClientException catch (err, stackrace) {
      log('Error Alert Client Exception ($url)');

      log(err.toString());

      log(stackrace.toString());

      CustomSnackBars.instance.showFailureSnackbar(
          title: "Client Exception",
          message: "Something Went Wrong! Try Again");

      return null;
    } catch (e) {
      log("This exception occured while hitting Post API call ($url): $e");

      return null;
    }
  }

  // Patch Method
  Future<Map<String, dynamic>?> patch(String url, bool isBasic,
      {int successCode = 200,
      int duration = 30,
      bool showResult = false}) async {
    //checking if the device is connected to internet
    bool isConnected = await isConnectedToInternet();

    if (isConnected == false) {
      CustomSnackBars.instance.showFailureSnackbar(
          title: "No Internet Connection",
          message: "Please check your internet connection and try again!");
      return null;
    }
    try {
      final response = await http
          .patch(
            Uri.parse(url),
            headers: isBasic ? basicHeaderInfo() : await bearerHeaderInfo(),
          )
          .timeout(Duration(seconds: duration));

      if (showResult) {
        log("patch API RESPONSE ($url): ${response.body}");
        log("patch API STATUS CODE ($url): ${response.statusCode}");
      }

      if (response.statusCode == successCode) {
        return jsonDecode(response.body);
      } else {
        log('patch API call failed with status code ($url): ${response.statusCode}');

        // ErrorResponse res = ErrorResponse.fromJson(jsonDecode(response.body));

        // CustomSnackBar.error(res.message!.error!.first.toString());

        return jsonDecode(response.body);
      }
    } on SocketException {
      log('Error Alert on Socket Exception ($url)');

      CustomSnackBars.instance.showFailureSnackbar(
          title: "Failure",
          message: "Check your Internet Connection and try again!");

      return null;
    } on TimeoutException {
      log('Error Alert Timeout Exception ($url)');

      CustomSnackBars.instance.showFailureSnackbar(
          title: "Request Timeout", message: "Something Went Wrong! Try Again");

      return null;
    } on http.ClientException catch (err, stackrace) {
      log('Error Alert Client Exception ($url)');

      log(err.toString());

      log(stackrace.toString());

      CustomSnackBars.instance.showFailureSnackbar(
          title: "Client Exception",
          message: "Something Went Wrong! Try Again");

      return null;
    } catch (e) {
      log("This exception occurred while hitting patch API call ($url): $e");

      return null;
    }
  }

  // Put Method
  Future<Map<String, dynamic>?> put(String url, bool isBasic,
      {int successCode = 200,
      int duration = 30,
      bool showResult = false}) async {
    //checking if the device is connected to internet
    bool isConnected = await isConnectedToInternet();

    if (isConnected == false) {
      CustomSnackBars.instance.showFailureSnackbar(
          title: "No Internet Connection",
          message: "Please check your internet connection and try again!");
      return null;
    }
    try {
      final response = await http
          .put(
            Uri.parse(url),
            headers: isBasic ? basicHeaderInfo() : await bearerHeaderInfo(),
          )
          .timeout(Duration(seconds: duration));

      if (showResult) {
        log("Put API RESPONSE ($url): ${response.body}");
        log("Put API STATUS CODE ($url): ${response.statusCode}");
      }

      if (response.statusCode == successCode) {
        return jsonDecode(response.body);
      } else {
        log('Put API call failed with status code ($url): ${response.statusCode}');

        // ErrorResponse res = ErrorResponse.fromJson(jsonDecode(response.body));

        // CustomSnackBar.error(res.message!.error!.first.toString());

        return jsonDecode(response.body);
      }
    } on SocketException {
      log('Error Alert on Socket Exception ($url)');

      CustomSnackBars.instance.showFailureSnackbar(
          title: "Failure",
          message: "Check your Internet Connection and try again!");

      return null;
    } on TimeoutException {
      log('Error Alert Timeout Exception ($url)');

      CustomSnackBars.instance.showFailureSnackbar(
          title: "Request Timeout", message: "Something Went Wrong! Try Again");

      return null;
    } on http.ClientException catch (err, stackrace) {
      log('Error Alert Client Exception ($url)');

      log(err.toString());

      log(stackrace.toString());

      CustomSnackBars.instance.showFailureSnackbar(
          title: "Client Exception",
          message: "Something Went Wrong! Try Again");

      return null;
    } catch (e) {
      log("This exception occured while hitting Put API call ($url): $e");

      return null;
    }
  }

  // Delete method
  Future<Map<String, dynamic>?> delete(String url, bool isBasic,
      {int successCode = 200,
      int duration = 15,
      bool showResult = false}) async {
    //checking if the device is connected to internet
    bool isConnected = await isConnectedToInternet();

    if (isConnected == false) {
      CustomSnackBars.instance.showFailureSnackbar(
          title: "No Internet Connection",
          message: "Please check your internet connection and try again!");
      return null;
    }
    try {
      var headers = isBasic ? basicHeaderInfo() : await bearerHeaderInfo();

      final response = await http
          .delete(
            Uri.parse(url),
            headers: headers,
          )
          .timeout(Duration(seconds: duration));

      if (showResult) {
        log("DELETE API RESPONSE ($url): ${response.body}");
        log("DELETE API STATUS CODE ($url): ${response.statusCode}");
      }

      if (response.statusCode == successCode) {
        return jsonDecode(response.body);
      } else {
        log('POST API call failed with status code ($url): ${response.statusCode}');

        // ErrorResponse res = ErrorResponse.fromJson(jsonDecode(response.body));

        // CustomSnackBar.error(res.message!.error!.first.toString());

        return jsonDecode(response.body);
      }
    } on SocketException {
      log('Error Alert on Socket Exception ($url)');

      CustomSnackBars.instance.showFailureSnackbar(
          title: "Failure",
          message: "Check your Internet Connection and try again!");

      return null;
    } on TimeoutException {
      log('Error Alert Timeout Exception ($url)');

      CustomSnackBars.instance.showFailureSnackbar(
          title: "Request Timeout", message: "Something Went Wrong! Try Again");

      return null;
    } on http.ClientException catch (err, stackrace) {
      log('Error Alert Client Exception ($url)');

      log(err.toString());

      log(stackrace.toString());

      CustomSnackBars.instance.showFailureSnackbar(
          title: "Client Exception",
          message: "Something Went Wrong! Try Again");

      return null;
    } catch (e) {
      log("This exception occured while hitting Get API call ($url): $e");

      return null;
    }
  }

  // Future<Map<String, dynamic>?> put(
  //     String url, Map<String, String> body, bool isBasic,
  //     {int successCode = 200,
  //     int duration = 15,
  //     bool showResult = false}) async {
  //   //checking if the device is connected to internet
  //   bool isConnected = await isConnectedToInternet();
  //
  //   if (isConnected == false) {
  //     showFailureSnackbar(
  //         title: "No Internet Connection",
  //         msg: "Please check your internet connection and try again!");
  //     return null;
  //   }
  //   try {
  //     final response = await http
  //         .put(
  //           Uri.parse(url),
  //           body: jsonEncode(body),
  //           headers: isBasic ? basicHeaderInfo() : await bearerHeaderInfo(),
  //         )
  //         .timeout(Duration(seconds: duration));
  //
  //     if (showResult) {
  //       log("PUT API RESPONSE ($url): ${response.body}");
  //       log("PUT API STATUS CODE ($url): ${response.statusCode}");
  //     }
  //
  //     if (response.statusCode == successCode) {
  //       return jsonDecode(response.body);
  //     } else {
  //       log('POST API call failed with status code ($url): ${response.statusCode}');
  //
  //       // ErrorResponse res = ErrorResponse.fromJson(jsonDecode(response.body));
  //
  //       // CustomSnackBar.error(res.message!.error!.first.toString());
  //
  //       return jsonDecode(response.body);
  //     }
  //   } on SocketException {
  //     log('Error Alert on Socket Exception ($url)');
  //
  //     showFailureSnackbar(
  //         title: "Failure",
  //         msg: "Check your Internet Connection and try again!");
  //
  //     return null;
  //   } on TimeoutException {
  //     log('Error Alert Timeout Exception ($url)');
  //
  //     showFailureSnackbar(
  //         title: "Request Timeout", msg: "Something Went Wrong! Try Again");
  //
  //     return null;
  //   } on http.ClientException catch (err, stackrace) {
  //     log('Error Alert Client Exception ($url)');
  //
  //     log(err.toString());
  //
  //     log(stackrace.toString());
  //
  //     showFailureSnackbar(
  //         title: "Client Exception", msg: "Something Went Wrong! Try Again");
  //
  //     return null;
  //   } catch (e) {
  //     log("This exception occured while hitting Get API call ($url): $e");
  //
  //     return null;
  //   }
  // }

  // Param get method
  // Future<Map<String, dynamic>?> paramGet(String url, Map<String, String> body,
  //     {int code = 200, int duration = 15, bool showResult = false}) async {
  //   log.i(
  //       '|Get param📍📍📍|----------------- [[ GET ]] param method Details Start -----------------|📍📍📍|');

  //   log.i("##body given --> ");

  //   if (showResult) {
  //     log.i(body);
  //   }

  //   log.i("##url list --> $url");

  //   log.i(
  //       '|Get param📍📍📍|----------------- [[ GET ]] param method details ended ** ---------------|📍📍📍|');

  //   try {
  //     final response = await http
  //         .get(
  //           Uri.parse(url).replace(queryParameters: body),
  //           headers: isBasic ? basicHeaderInfo() : await bearerHeaderInfo(),
  //         )
  //         .timeout(const Duration(seconds: 15));

  //     log.i(
  //         '|📒📒📒| ----------------[[ Get ]] Peram Response Start---------------|📒📒📒|');

  //     if (showResult) {
  //       log.i(response.body.toString());
  //     }

  //     log.i(
  //         '|📒📒📒| ----------------[[ Get ]] Peram Response End **-----------------|📒📒📒|');

  //     if (response.statusCode == code) {
  //       return jsonDecode(response.body);
  //     } else {
  //       log.e('🐞🐞🐞 Error Alert 🐞🐞🐞');

  //       log.e(
  //           'unknown error hitted in status code  ${jsonDecode(response.body)}');

  //       ErrorResponse res = ErrorResponse.fromJson(jsonDecode(response.body));

  //       CustomSnackBar.error(res.message!.error!.first.toString());

  //       return null;
  //     }
  //   } on SocketException {
  //     log.e('🐞🐞🐞 Error Alert on Socket Exception 🐞🐞🐞');

  //     CustomSnackBar.error('Check your Internet Connection and try again!');

  //     return null;
  //   } on TimeoutException {
  //     log.e('🐞🐞🐞 Error Alert 🐞🐞🐞');

  //     log.e('Time out exception$url');

  //     CustomSnackBar.error('Something Went Wrong! Try again');

  //     return null;
  //   } on http.ClientException catch (err, stackrace) {
  //     log.e('🐞🐞🐞 Error Alert 🐞🐞🐞');

  //     log.e('client exception hitted');

  //     log.e(err.toString());

  //     log.e(stackrace.toString());

  //     return null;
  //   } catch (e) {
  //     log.e('🐞🐞🐞 Error Alert 🐞🐞🐞');

  //     log.e('#url->$url||#body -> $body');

  //     log.e('❌❌❌ unlisted error received');

  //     log.e("❌❌❌ $e");

  //     return null;
  //   }
  // }

  // Post Method
  // Future<Map<String, dynamic>?> multipart(
  //     String url, Map<String, String> body, String filepath, String filedName,
  //     {int code = 200, bool showResult = false}) async {
  //   try {
  //     log.i(
  //         '|📍📍📍|-----------------[[ Multipart ]] method details start -----------------|📍📍📍|');

  //     log.i(url);

  //     log.i(body);
  //     log.i(filepath);

  //     log.i(
  //         '|📍📍📍|-----------------[[ Multipart ]] method details end ------------|📍📍📍|');

  //     final request = http.MultipartRequest(
  //       'POST',
  //       Uri.parse(url),
  //     )
  //       ..fields.addAll(body)
  //       ..headers.addAll({
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //         'Authorization': 'Bearer ${LocalStorage.getToken()!}'
  //       })
  //       ..files.add(await http.MultipartFile.fromPath(filedName, filepath));
  //     var response = await request.send();
  //     var jsonData = await http.Response.fromStream(response);

  //     log.i(
  //         '|📒📒📒|-----------------[[ POST ]] method response start ------------------|📒📒📒|');

  //     log.i(jsonData.body.toString());

  //     log.i(response.statusCode);

  //     log.i(
  //         '|📒📒📒|-----------------[[ POST ]] method response end --------------------|📒📒📒|');

  //     if (response.statusCode == code) {
  //       return jsonDecode(jsonData.body) as Map<String, dynamic>;
  //     } else {
  //       log.e('🐞🐞🐞 Error Alert On Status Code 🐞🐞🐞');

  //       log.e(
  //           'unknown error hitted in status code ${jsonDecode(jsonData.body)}');

  //       ErrorResponse res = ErrorResponse.fromJson(jsonDecode(jsonData.body));

  //       CustomSnackBar.error(res.message!.error!.first.toString());

  //       // CustomSnackBar.error(
  //       //     jsonDecode(response.body)['message']['error'].toString());
  //       return null;
  //     }
  //   } on SocketException {
  //     log.e('🐞🐞🐞 Error Alert on Socket Exception 🐞🐞🐞');

  //     CustomSnackBar.error('Check your Internet Connection and try again!');

  //     return null;
  //   } on TimeoutException {
  //     log.e('🐞🐞🐞 Error Alert Timeout Exception🐞🐞🐞');

  //     log.e('Time out exception$url');

  //     CustomSnackBar.error('Something Went Wrong! Try again');

  //     return null;
  //   } on http.ClientException catch (err, stackrace) {
  //     log.e('🐞🐞🐞 Error Alert Client Exception🐞🐞🐞');

  //     log.e('client exception hitted');

  //     log.e(err.toString());

  //     log.e(stackrace.toString());

  //     return null;
  //   } catch (e) {
  //     log.e('🐞🐞🐞 Other Error Alert 🐞🐞🐞');

  //     log.e('❌❌❌ unlisted error received');

  //     log.e("❌❌❌ $e");

  //     return null;
  //   }
  // }

  // // multipart multi file Method
  // Future<Map<String, dynamic>?> multipartMultiFile(
  //   String url,
  //   Map<String, String> body, {
  //   int code = 200,
  //   bool showResult = false,
  //   required List<String> pathList,
  //   required List<String> fieldList,
  // }) async {
  //   try {
  //     log.i(
  //         '|📍📍📍|-----------------[[ Multipart ]] method details start -----------------|📍📍📍|');

  //     log.i(url);

  //     if (showResult) {
  //       log.i(body);
  //       log.i(pathList);
  //       log.i(fieldList);
  //     }

  //     log.i(
  //         '|📍📍📍|-----------------[[ Multipart ]] method details end ------------|📍📍📍|');
  //     final request = http.MultipartRequest(
  //       'POST',
  //       Uri.parse(url),
  //     )
  //       ..fields.addAll(body)
  //       ..headers.addAll({
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //         'Authorization': 'Bearer ${LocalStorage.getToken()!}'
  //       });

  //     for (int i = 0; i < fieldList.length; i++) {
  //       request.files
  //           .add(await http.MultipartFile.fromPath(fieldList[i], pathList[i]));
  //     }

  //     var response = await request.send();
  //     var jsonData = await http.Response.fromStream(response);

  //     log.i(
  //         '|📒📒📒|-----------------[[ POST ]] method response start ------------------|📒📒📒|');

  //     log.i(jsonData.body.toString());

  //     log.i(response.statusCode);

  //     log.i(
  //         '|📒📒📒|-----------------[[ POST ]] method response end --------------------|📒📒📒|');

  //     if (response.statusCode == code) {
  //       return jsonDecode(jsonData.body) as Map<String, dynamic>;
  //     } else {
  //       log.e('🐞🐞🐞 Error Alert On Status Code 🐞🐞🐞');

  //       log.e(
  //           'unknown error hitted in status code ${jsonDecode(jsonData.body)}');

  //       ErrorResponse res = ErrorResponse.fromJson(jsonDecode(jsonData.body));

  //       CustomSnackBar.error(res.message!.error!.first.toString());

  //       // CustomSnackBar.error(
  //       //     jsonDecode(response.body)['message']['error'].toString());
  //       return null;
  //     }
  //   } on SocketException {
  //     log.e('🐞🐞🐞 Error Alert on Socket Exception 🐞🐞🐞');

  //     CustomSnackBar.error('Check your Internet Connection and try again!');

  //     return null;
  //   } on TimeoutException {
  //     log.e('🐞🐞🐞 Error Alert Timeout Exception🐞🐞🐞');

  //     log.e('Time out exception$url');

  //     CustomSnackBar.error('Something Went Wrong! Try again');

  //     return null;
  //   } on http.ClientException catch (err, stackrace) {
  //     log.e('🐞🐞🐞 Error Alert Client Exception🐞🐞🐞');

  //     log.e('client exception hitted');

  //     log.e(err.toString());

  //     log.e(stackrace.toString());

  //     return null;
  //   } catch (e) {
  //     log.e('🐞🐞🐞 Other Error Alert 🐞🐞🐞');

  //     log.e('❌❌❌ unlisted error received');

  //     log.e("❌❌❌ $e");

  //     return null;
  //   }
  // }
}
