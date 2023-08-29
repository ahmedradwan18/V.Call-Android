import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../routes/app_pages.dart';
import '../helpers/api_helper.dart';
import '../values/app_constants.dart';

/// this class will handle the user authentication process.
class AuthService {
  //*===========================================================================
  //*================================ Constructor ==============================
  //*===========================================================================
  // to have only one(1) Authentication class [Singelton]
  static final AuthService _singleton = AuthService._internal();
  factory AuthService() {
    return _singleton;
  }
  AuthService._internal();

  //*===========================================================================
  //*================================ Parameters ===============================
  //*===========================================================================
  // Authentication Brain

  bool hasLaunchedAppBefore = false;
  //! DONT MAKE THEM [FINAL], to accomidate re-login
  // These 5 are needed to call the [Get User API]
  late String ssoSubject;
  late String _userName;
  late String _userLastName;
  late String _userEmail;
  //
  String? refreshToken;
  String? idToken;
  bool _lastLoginWithRefreshToken = false;
  bool get userHasSavedToken => refreshToken != null;
  final _isAuthenticating = false.obs;

  late bool hasPackageExpired;
  //!=============================== Getters ===================================
  //extract some data from the different code modules to use
  //=====GET USER=====
  // UserModel? get user => _user.value
  String? get userID => 'EDU-STU-2020-00012';
  // // //? User INFORMAITON
  String? get userName => 'mahmoud' ?? _userName;
  // String? get userEmail => (user?.studentEmailId) ?? _userEmail;
  // String? get userPhoneNumber => (user?.studentMobileNumber);
  // String? get userLastName => (user?.lastName) ?? _userLastName;
  // String? get userImage => user?.image;
  // String? get userProfileImageLocalPath => user?.profileImageLocalPath;
  // String? get userCity => user?.city;
  // String? get userBirthDate => user?.dateOfBirth;
  // String? get userGender => user?.gender;
  String get userFullName => '$userName';

  int get userRoomsCount {
    // to remove red error screen that shows just before [Logout] is pushed
    return 3;
  }

  int get userMaxRoomsCount {
    return 5;
  }

  bool get isUserFree => true;
  bool get canViewRecordings => true;

  int get participantCapacity {
    return 500;
  }

  int get meetingDuration {
    return 120;
  }

  int get storageCapacity {
    return 300;
  }

  String get roomText {
    return 'rooms'.tr;
  }

  bool get isAuthenticating => _isAuthenticating.value;
  set isAuthenticating(bool newValue) => _isAuthenticating(newValue);

  //*===========================================================================
  //*================================= Methods =================================
  //*===========================================================================

  void incrementUserRoomsCount([int? roomLength]) {
    if (userRoomsCount < userMaxRoomsCount) {
      // _user.update((val) {
      //   val!.subscriptionUsage!.roomsNumber!.userUsage =
      //       roomLength ?? (val.subscriptionUsage!.roomsNumber!.userUsage! + 1);
      // });
    }
  }

  // //!===========================================================================
  // Future<AuthenticationResult> authenticate() async {
  //   try {
  //     // check the device's connectivity state
  //     // device [IS NOT] online
  //     if (!NetworkingService().hasNetwork) {
  //       LoggingService.information(
  //         'No Network Available, Authentication process was cancelled.',
  //       );
  //       return _handleError(
  //         errorCause: AuthenticationResult.noNetwork,
  //       );
  //     }
  //     isAuthenticating = true;

  //     // device [IS] Online
  //     // can be [TokenResponse] or [Authentication Token Response]
  //     // so it's dynamic
  //     final dynamic authApiResponse;
  //     // check if the user has some token stored already

  //     if (refreshToken != null) {
  //       _lastLoginWithRefreshToken = true;
  //       authApiResponse = await _authenticateWithRefreshToken();
  //     } else {
  //       authApiResponse = await _authenticateWithEmailPassword();
  //     }

  //     // save the user credentials into a variable for later use
  //     await _saveUserCredentialsLocally(
  //       authApiResponse,
  //     );

  //     // Parse and Extract data from the [JWT] and store them
  //     final parsedToken = _onParseJWTToken(authApiResponse.accessToken!);
  //     ssoSubject = parsedToken['sub'];
  //     _userEmail = parsedToken['email'];
  //     _userLastName = parsedToken['family_name'];
  //     _userName = parsedToken['given_name'];

  //     return _handleSuccess();
  //   } catch (e) {
  //     LoggingService.error(
  //       'Error at Method:authenticate -- authenticatoin_service.dart',
  //       e,
  //       null,
  //     );
  //     // clear any saved token, to restart the authentication process
  //     // with a clean slate.
  //     await _clearLocallySavedToken();
  //     return _handleError(
  //       errorCause: AuthenticationResult.unexpectedError,
  //     );
  //   }
  // }

  // //!===========================================================================
  // /// check to see if the user has already authenticated once before, which
  // /// means that this is not his first time using the application, so
  // ///? 1) don't show the [BoardingView]
  // ///? 2) Authenticate with [RefreshToken] and not [Email/Password]

  // /// entered his [email/pass] before, don't show him the Authentication
  // /// webView and use the [RefreshToken] instead.
  // Future<bool> onHasLaunchedAppBefore() async {
  //   try {
  //     // read the items stored in local storage
  //     const FlutterSecureStorage localStorageDriver = FlutterSecureStorage();

  //     final languageToken =
  //         await localStorageDriver.read(key: 'hasLaunchedAppBefore');

  //     hasLaunchedAppBefore = (languageToken != null);

  //     // To Save that user has lunched the app before
  //     final launchedAppBefore = json.encode(true);

  //     await localStorageDriver.write(
  //       key: 'hasLaunchedAppBefore',
  //       value: launchedAppBefore,
  //     );

  //     return (hasLaunchedAppBefore);
  //   } catch (e) {
  //     LoggingService.error(
  //       'Error at Method:_isUserAuthenticatedBefore '
  //       '-- authenticatoin_service.dart',
  //       e,
  //       StackTrace.current,
  //     );
  //     return false;
  //   }
  // }

  // //!===========================================================================
  // Future<String?> readRefreshToken() async {
  //   try {
  //     const FlutterSecureStorage localStorageDriver = FlutterSecureStorage();

  //     refreshToken = await localStorageDriver.read(
  //       key: 'refreshToken',
  //     );

  //     return refreshToken;
  //   } catch (e) {
  //     LoggingService.error(
  //       'Error at Method:readRefreshToken -- Authentication_service.dart',
  //       e,
  //       StackTrace.current,
  //     );
  //     rethrow;
  //   }
  // }

  // //!===========================================================================
  // Future<TokenResponse?> _authenticateWithRefreshToken() async {
  //   try {
  //     // LOG
  //     LoggingService.information(
  //       'User started the SSO authenticaiton process via RefreshToken',
  //     );

  //     refreshToken ??= await readRefreshToken();

  //     // Authentication Process
  //     return _appAuthInstance
  //         .token(
  //           TokenRequest(
  //             AppConstants.clientID,
  //             AppConstants.environment.ssoRedirectUrl,
  //             refreshToken: refreshToken,
  //             issuer: AppConstants.environment.ssoIssuer,
  //             scopes: AppConstants.ssoScopeList,
  //             clientSecret: AppConstants.environment.ssoClientSecret,
  //           ),
  //         )
  //         .timeout(APIHelper.ssoTimeOutDuration);
  //   } catch (e) {
  //     LoggingService.error(
  //       'Error at Method:_authenticateWithRefreshToken '
  //       '-- authenticatoin_service.dart',
  //       e,
  //       null,
  //     );
  //     rethrow;
  //   }
  // }

  // //!===========================================================================
  // Future<AuthorizationTokenResponse?> _authenticateWithEmailPassword() async {
  //   try {
  //     // LOG
  //     LoggingService.information(
  //         'User started the SSO authenticaiton process via Email/Password');

  //     // Authentication Process
  //     return _appAuthInstance
  //         .authorizeAndExchangeCode(
  //           AuthorizationTokenRequest(
  //             AppConstants.clientID,
  //             AppConstants.environment.ssoRedirectUrl,
  //             issuer: AppConstants.environment.ssoIssuer,
  //             scopes: AppConstants.ssoScopeList,
  //             clientSecret: AppConstants.environment.ssoClientSecret,
  //             preferEphemeralSession: Platform.isIOS,
  //           ),
  //         )
  //         .timeout(APIHelper.ssoTimeOutDuration);
  //   } catch (e) {
  //     LoggingService.error(
  //       'Error at Method:_authenticateWithEmailPassword '
  //       '-- authenticatoin_service.dart',
  //       e,
  //       StackTrace.current,
  //     );
  //     rethrow;
  //   }
  // }

  // //!===========================================================================
  // /// Made into a function for possible future actions before returning.
  // AuthenticationResult _handleError({
  //   AuthenticationResult errorCause = AuthenticationResult.unexpectedError,
  // }) {
  //   isAuthenticating = false;
  //   return errorCause;
  // }

  // //!===========================================================================
  // /// Made into a function for possible future actions before returning.
  // Future<AuthenticationResult> _handleSuccess() async {
  //   final loginMethod = _lastLoginWithRefreshToken ? 'Refresh_Token' : 'Normal';
  //   //Logg
  //   AppsFlyerService.appsFlyer.logEvent(
  //     'loginMethod',
  //     {
  //       'loginMethod': loginMethod,
  //     },
  //   );

  //   await AnalyticsService.instance.logLogin(
  //     loginMethod: loginMethod,
  //   );
  //   isAuthenticating = false;
  //   return AuthenticationResult.success;
  // }

  // //!===========================================================================
  // Future<void> getUser() async {
  //   try {
  //     await UserProvider().getUser();
  //   } catch (e) {
  //     LoggingService.error(
  //       'Error at Method:getUser -- Authentication_service.dart',
  //       e,
  //       StackTrace.current,
  //     );
  //   }
  // }
  // //!===========================================================================

  // Future<bool?> hasPakcage() async {
  //   try {
  //     return UserProvider().hasPakcage().whenComplete(_handlePackageExpiry);
  //   } catch (e) {
  //     LoggingService.error(
  //       'Error at Method:getUser -- Authentication_service.dart',
  //       e,
  //       StackTrace.current,
  //     );
  //   }
  //   return null;
  // }

  // //!===========================================================================
  // /// saves the [Access Token] locally for later use.
  // Future<void> _saveUserCredentialsLocally(dynamic authTokenResponse) async {
  //   try {
  //     //save the data for use across the app/file
  //     refreshToken = authTokenResponse.refreshToken;
  //     idToken = authTokenResponse.idToken;

  //     const FlutterSecureStorage localStorageDriver = FlutterSecureStorage();

  //     await localStorageDriver.write(
  //       key: 'refreshToken',
  //       value: refreshToken,
  //     );
  //     await localStorageDriver.write(
  //       key: 'idToken',
  //       value: idToken,
  //     );
  //   } catch (e) {
  //     LoggingService.error(
  //       'Error at Method:saveTokenLocally -- Authentication_service.dart',
  //       e,
  //       StackTrace.current,
  //     );
  //     rethrow;
  //   }
  // }

  // //!===========================================================================
  // Future<void> logout({bool redirectToLogin = true}) async {
  //   try {
  //     // Must not be empty
  //     if (refreshToken?.isEmpty ?? true) return;

  //     // Logout
  //     final logoutRequest = EndSessionRequest(
  //       idTokenHint: idToken,
  //       postLogoutRedirectUrl: AppConstants.environment.ssoRedirectUrl,
  //       issuer: AppConstants.environment.ssoIssuer,
  //     );

  //     await _appAuthInstance.endSession(logoutRequest);

  //     // clear all Locally-saved data on this user
  //     await _clearLocallySavedToken();

  //     //Clear Data
  //     UserProvider.user.value = null;

  //     if (redirectToLogin) {
  //       await Get.deleteAll();
  //       // move to Guesthome, must be the last line, as it disposes of everything
  //       // and the lines after it won't trigger.
  //       await Get.offAllNamed(Routes.guestHome);
  //     }

  //     // catch any errors
  //   } catch (e) {
  //     LoggingService.error(
  //       'Error at Method:logout -- authenticatoin_service.dart',
  //       e,
  //       null,
  //     );
  //     // push the error screen if logout is unsuccessful
  //     await Get.offAllNamed(
  //       Routes.error,
  //     );
  //   }
  // }

  // //!===========================================================================
  // Future<void> _clearLocallySavedToken() async {
  //   try {
  //     const FlutterSecureStorage localStorageDriver = FlutterSecureStorage();

  //     await localStorageDriver.delete(
  //       key: 'refreshToken',
  //     );

  //     await localStorageDriver.delete(
  //       key: 'idToken',
  //     );

  //     refreshToken = null;
  //   } catch (e) {
  //     LoggingService.error(
  //       'Error at Method:_clearLocallySavedToken -- authenticatoin_service.dart',
  //       e,
  //       StackTrace.current,
  //     );
  //   }
  // }

  // //!===========================================================================
  // Map<String, dynamic> _onParseJWTToken(String token) {
  //   try {
  //     // Header.Payload.Signature
  //     // split on the '.' to only target the Payload[Claims] which has
  //     // the data that I want
  //     final splittedToken = token.split('.');
  //     // if it's not 3 parts then something is wrong with the token
  //     if (splittedToken.length != 3) {
  //       throw Exception('invalid token');
  //     }
  //     // Decode the [Payload] part of the token
  //     final payload = _decodeBase64(splittedToken[1]);
  //     // convert it from [Json] to [Map], for easy access
  //     final payloadMap = json.decode(payload);
  //     // another sanity check
  //     if (payloadMap is! Map<String, dynamic>) {
  //       throw Exception('invalid payload');
  //     }

  //     return payloadMap;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // //!===========================================================================
  // String _decodeBase64(String str) {
  //   String output = str.replaceAll('-', '+').replaceAll('_', '/');
  //   // append different characters at the end of the token,
  //   // to convert it to a [base64URL] string instead of [base64]
  //   switch (output.length % 4) {
  //     case 0:
  //       break;
  //     case 2:
  //       output += '==';
  //       break;
  //     case 3:
  //       output += '=';
  //       break;
  //     default:
  //       throw Exception('Illegal base64url string!"');
  //   }

  //   return utf8.decode(base64Url.decode(output));
  // }

  // //*==================================================
  // Future<bool> restoreMyAccount() async {
  //   try {
  //     await UserProvider().restoreDeletedAccount();
  //     // If I reach this point, this means that,
  //     // the response code is 2xx, and there aren't any thrown exceptions
  //     return true;
  //   } catch (e) {
  //     LoggingService.error(
  //       'Error at Method:restoreMyAccount -- authenticatoin_service.dart',
  //       e,
  //       StackTrace.current,
  //     );

  //     final message = (e is PlatformException && e.message != null)
  //         ? (e.message!).tr
  //         : (AppConstants.somethingWentWrongText).tr;

  //     SnackBarHelper.showSnackBar(
  //       message: message,
  //       type: SnackBarType.error,
  //     );
  //     return false;
  //   }
  // }

  // //*==================================================
  // void updateUserInfoLocally({
  //   String? birthDate,
  //   String? city,
  //   String? gender,
  //   CountryModel? country,
  //   String? firstName,
  //   String? lastName,
  //   String? phoneNumber,
  //   String? userProfileImagePath,
  //   bool isAccountActive = true,
  // }) {
  //   _user.update((userModel) {
  //     userModel?.dateOfBirth = birthDate ?? userModel.dateOfBirth;
  //     userModel?.city = city ?? userModel.city;
  //     userModel?.gender = gender ?? userModel.gender;
  //     userModel?.country = country ?? userModel.country;
  //     userModel?.firstName = firstName ?? userModel.firstName;
  //     userModel?.lastName = lastName ?? userModel.lastName;
  //     userModel?.studentMobileNumber =
  //         phoneNumber ?? userModel.studentMobileNumber;
  //     userModel?.profileImageLocalPath =
  //         userProfileImagePath ?? userModel.profileImageLocalPath;
  //     userModel?.deleteStatus = isAccountActive ? null : userModel.deleteStatus;
  //   });
  // }

  // //*==================================================
  // void _handlePackageExpiry() {
  //   final packageExpiryDate = user?.packageExpriyDate;

  //   // Free package
  //   if (packageExpiryDate == null) {
  //     hasPackageExpired = false;
  //     return;
  //   }

  //   final packageExpiryDateTime =
  //       DateTimeUtils.getDateFromString(packageExpiryDate);

  //   hasPackageExpired = DateTime.now()
  //       .subtract(const Duration(days: 1))
  //       .isAfter(packageExpiryDateTime);
  // }
  //!===========================================================================
  //!===========================================================================
}
