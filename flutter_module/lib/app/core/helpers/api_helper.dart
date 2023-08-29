import 'package:flutter/services.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../../data/models/api_response.dart';
import '../../data/enums/snack_bar_type.dart';
import '../values/app_constants.dart';
import 'snackbar_helper.dart';

/// Common methods/parameters/checks in dealing with apis
class APIHelper {
  //!=============================== Constructor ===============================
  static final APIHelper _singleton = APIHelper._internal();
  factory APIHelper() {
    return _singleton;
  }
  APIHelper._internal();
  //!================================ Properties ===============================
  static const int timeoutExceptionCode = 1002;
  static const int backendUnknownExceptionCode = 0000;
  // Something wrong in my dart code,
  // i.e. I have array [1,2,3] and I try to delete element at index 8;
  static const int dartExceptionCode = 9999;
  static const Duration apiTimeOutDuration = Duration(seconds: 15);
  static const Duration ssoTimeOutDuration = Duration(minutes: 2);

  static const Map<String, String> apiHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };

  //!================================= Methods =================================
  /// check the API's response, to avoid using garbage data
  /// and to redirect the flow to the error handlation part.
  static APIResponseModel handleFailure({
    required dynamic error,
    required String methodName,

    /// Without [.dart]
    required String fileName,
  }) {
    // TODO() Log Error
    // LoggingService.error(
    //   'Error at Method:$methodName-- $fileName.dart',
    //   error,
    //   StackTrace.current,
    // );

    final errorMessage = _getErrorMessage(error);
    final errorCode = _getErrorCode(error);

    // return response with errorMessage
    return APIResponseModel(
      succeeded: false,
      data: errorMessage,
      statusCode: errorCode,
    );
  }

  //!==================================================
  static String? _getErrorCode(dynamic error) {
    if (error is PlatformException) {
      if (error.code != 'null') {
        return error.code;
      } else {
        return '$timeoutExceptionCode';
      }
    }

    return null;
  }

  //!==================================================
  static String _getErrorMessage(dynamic error) {
    if (error is PlatformException) {
      if (error.message != null) {
        return (error.message)!.tr;
      } else {
        return (AppConstants.somethingWentWrongText).tr;
      }
    }

    return (AppConstants.somethingWentWrongText).tr;
  }

  //!===========================================================================
  /// check the API's response to see if the [API] was called successfully or
  /// not to avoid using garbage data  and to redirect the flow to the
  /// error handlation part.
  static void checkResponseForErrors(dynamic response) {
    // Default Message
    const fallbackMessage = AppConstants.somethingWentWrongText;

    if (response.body is List) {
      if (!(response.statusCode.toString().startsWith('2'))) {
        throw PlatformException(
          code: '${response.statusCode}',
          message: fallbackMessage,
        );
      }
    }
    // the [throw] will be handled at the calling methods
    else if (response.status.hasError ||
        (response.body['status'] == 'error') ||
        response.body.isEmpty ||
        (response.body['message'] is Map &&
            response.body['message']['status'] == false)) {
      // is body emtpy, maybe network error
      final isBodyEmpty = response.body == null;
      // Extract any specific message based on its type
      final innerMessage = (response.body['message'] is Map
          ? response.body['message']['error_description']
          : response.body['message']);
      // Extract any special errorDescription
      final errorDescription =
          response.body['error_description'] ?? response.body['error'];
      // final message
      late final String message;
      if (isBodyEmpty) {
        message = fallbackMessage;
      } else {
        message = innerMessage ?? errorDescription ?? fallbackMessage;
      }

      throw PlatformException(
        code: '${response.statusCode}',
        message: message,
      );
    }
  }

  //!==================================================
  /// Show appropriate snackbar if the api calling was a success, BUT it's data
  /// had an error, or there was a restriction, e.g. [Max Room Limit Reached]
  static void showAPIResponseSnackbar(APIResponseModel apiResponse) {
    // if the message is empty, then I do not want to show a snackbar
    // e.g. [getContacts] API, if it was a success, I could tell from UI
    if (apiResponse.data.isEmpty) return;

    SnackBarHelper.showSnackBar(
      message: apiResponse.data,
      type: apiResponse.succeeded ? SnackBarType.action : SnackBarType.error,
    );
  }
  //!===========================================================================
}
