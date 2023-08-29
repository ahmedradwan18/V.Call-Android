/// API LINKS FOR DIFFERENT ENVIRONMENTS
class Environment {
  //!================================ Properties ===============================
  final String apiLayerUrl;
  final String apiLayerBaseUrl;
  final String vlcLayerUrl;
  final String contactUsModuleUrl;
  final String fawryPaymentUrl;
  final String fawryMerchantCode;
  final String fawrySecretCode;
  //SSO
  final String ssoAPIUrl;
  final String ssoClientSecret;
  final String ssoIssuer;
  final String ssoRedirectUrl;
  final String paymentURL;

  /// When I Exit the Meeting from the webView, it redirects to a url containg
  /// this String, that's what I check on to exit the meeting myself.
  final String exitMeetingRedirectUrl;
  //!================================ Constructor ==============================
  const Environment({
    required this.apiLayerUrl,
    required this.apiLayerBaseUrl,
    required this.vlcLayerUrl,
    required this.fawryPaymentUrl,
    required this.fawryMerchantCode,
    required this.fawrySecretCode,
    required this.exitMeetingRedirectUrl,
    required this.ssoAPIUrl,
    required this.contactUsModuleUrl,
    required this.ssoClientSecret,
    required this.ssoIssuer,
    required this.ssoRedirectUrl,
    required this.paymentURL,
  });
  //!===========================================================================
  //!===========================================================================
}

/// the enveloping class that holds the different [Environment] instances
class Environments {
  //!=============================== Properties ===============================
  //!
  //! ----- DEVELOPMENT -----
  static const Environment development = Environment(
    exitMeetingRedirectUrl: 'https://dashboard.vdev.variiance.com/vlcHome',
    //APIs
    apiLayerUrl: 'https://api.vdev.variiance.com/callapi',
    apiLayerBaseUrl: 'https://api.vdev.variiance.com',
    vlcLayerUrl: 'https://vlcapi.vdev.variiance.com/v1',
    contactUsModuleUrl: 'api/resource/Contact Us/VariianceContacts-2022-10230',
    //Fawry
    fawryMerchantCode: '1tSa6uxz2nSp5mXgybaxIg==',
    fawrySecretCode: '9e10c34796724899924c4c03f644c31a',
    fawryPaymentUrl:
        'https://atfawry.fawrystaging.com/fawrypay-api/api/payments/charge',
    //SSO
    ssoAPIUrl: 'https://ssodev.variiance.com/auth/realms/Variiance',
    ssoClientSecret: 'XJXJA5hTpoeLu1XK2vAq4nrAJX0WQEIp',
    ssoIssuer: 'https://ssodev.variiance.com/auth/realms/Variiance',
    ssoRedirectUrl: 'com.variiance.vlc:/oauthredirect',
    paymentURL: 'https://payment-service.vdev.variiance.com',
  );

  //! ------ FEATURE -----
  static const Environment feature = Environment(
    exitMeetingRedirectUrl: 'https://dashboardfeat.vdev.variiance.com/vlcHome',
    //APIs
    apiLayerUrl: 'https://api-feature.vdev.variiance.com/callapi',
    apiLayerBaseUrl: 'https://api.vdev.variiance.com',
    vlcLayerUrl: 'https://vlcapifeat.vdev.variiance.com/v1',
    contactUsModuleUrl: 'api/resource/Contact Us/VariianceContacts-2022-10230',
    //Fawry
    fawryMerchantCode: '1tSa6uxz2nSp5mXgybaxIg==',
    fawrySecretCode: '9e10c34796724899924c4c03f644c31a',
    fawryPaymentUrl:
        'https://atfawry.fawrystaging.com/fawrypay-api/api/payments/charge',
    //SSO
    ssoAPIUrl: 'https://ssodev.variiance.com/auth/realms/Variiance',
    ssoClientSecret: 'XJXJA5hTpoeLu1XK2vAq4nrAJX0WQEIp',
    ssoIssuer: 'https://ssodev.variiance.com/auth/realms/Variiance',
    ssoRedirectUrl: 'com.variiance.vlc:/oauthredirect',

    //TODO()
    paymentURL: 'https://payment-service.vdev.variiance.com',
  );

  //!
  //! ----- PRODUCTION -----
  static const Environment production = Environment(
    exitMeetingRedirectUrl: 'https://dashboard.vconnct.me/vlcMeetings',
    //APIs
    apiLayerUrl: 'https://restapi.variiance.com/callapi',
    apiLayerBaseUrl: 'https://restapi.variiance.com',
    contactUsModuleUrl: 'api/resource/Contact Us/VariianceContacts-2022-140973',

    vlcLayerUrl: 'https://vapi.variiance.com/v1',
    //Fawry
    fawryMerchantCode: 'sYl4M6+mG25hOUCE+P9zug==',
    fawrySecretCode: '48eafdf1d4f646cca7739c4614b19f02',
    fawryPaymentUrl: 'https://atfawry.com/fawrypay-api/api/payments/charge',
    //SSO
    ssoAPIUrl: 'https://sso.variiance.com/auth/realms/Variiance',
    ssoClientSecret: '306f73a2-8082-49d0-94fd-dd4931c31e3d',
    ssoIssuer: 'https://sso.variiance.com/auth/realms/Variiance',
    ssoRedirectUrl: 'com.variiance.vlc:/oauthredirect',

    //TODO()
    paymentURL: 'https://payment-service.vdev.variiance.com',
  );

  //!
  //! ----- TEST -----
  static const Environment testing = Environment(
    exitMeetingRedirectUrl: 'https://dashboard.test.variiance.com/vlcHome',
    //APIs
    apiLayerUrl: 'https://api.test.variiance.com/callapi',
    apiLayerBaseUrl: 'https://api.test.variiance.com',
    vlcLayerUrl: 'https://vapi.test.variiance.com/v1',
    contactUsModuleUrl: 'api/resource/Contact Us/VariianceContacts-2022-10230',
    //Fawry
    fawryMerchantCode: 'sYl4M6+mG25hOUCE+P9zug==',
    fawrySecretCode: '48eafdf1d4f646cca7739c4614b19f02',
    fawryPaymentUrl:
        'https://atfawry.fawrystaging.com/fawrypay-api/api/payments/charge',
    //SSO
    ssoAPIUrl: 'https://sso.test.variiance.com/auth/realms/Variiance',
    ssoClientSecret: 'fe56abe3-4489-4ada-b0c6-7aa36ccd2e6d',
    ssoIssuer: 'https://sso.test.variiance.com/auth/realms/Variiance',
    ssoRedirectUrl: 'com.variiance.vlc:/oauthredirect',

    //TODO()
    paymentURL: 'https://payment-service.vdev.variiance.com',
  );
  //!============================= Constructor =================================
  static final Environments _singleton = Environments._internal();
  factory Environments() {
    return _singleton;
  }
  Environments._internal();
  //!===========================================================================
  //!===========================================================================
}
