import 'package:flutter/material.dart';
// import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class CustomInAppWebView extends StatelessWidget {
  //*================================ Parameters ===============================
  final String url;
  final bool useShouldOverrideUrlLoading;
  final Function(Uri)? injectedNavigationFunction;
  final Function(InAppWebViewController)? onWebViewCreated;
  final Function(InAppWebViewController, DownloadStartRequest)?
      onDownloadStartRequest;
  final Function(InAppWebViewController, Uri?, BuildContext?)? onLoadStop;
  final Function(InAppWebViewController, Uri?, int, String)? onLoadError;
  //*================================ Constructor ==============================
  const CustomInAppWebView({
    Key? key,
    required this.url,
    this.useShouldOverrideUrlLoading = false,
    this.injectedNavigationFunction,
    required this.onWebViewCreated,
    this.onDownloadStartRequest,
    this.onLoadStop,
    this.onLoadError,
  }) : super(key: key);

  //*================================= Methods =================================

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: Uri.parse(url)),
      initialOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
          useOnDownloadStart: true,
          useShouldOverrideUrlLoading: useShouldOverrideUrlLoading,
          mediaPlaybackRequiresUserGesture: false,
        ),
        android: AndroidInAppWebViewOptions(
          useHybridComposition: true,
        ),
        ios: IOSInAppWebViewOptions(
          allowsInlineMediaPlayback: true,
        ),
      ),
      onDownloadStartRequest: onDownloadStartRequest,
      onWebViewCreated: onWebViewCreated,
      androidOnPermissionRequest: (controller, origin, resources) async {
        return PermissionRequestResponse(
          resources: resources,
          action: PermissionRequestResponseAction.GRANT,
        );
      },
      onLoadError: onLoadError,
      onLoadStop: (onLoadStop == null)
          ? null
          : (controller, url) => onLoadStop!(
                controller,
                url,
                context,
              ),
      shouldOverrideUrlLoading: !(useShouldOverrideUrlLoading)
          ? null
          : (controller, navigationAction) async {
              final uri = navigationAction.request.url!;
              // This decides whether or not to terminate the [inAppWebView]
              // and whether or not to do some logic on it.
              // i.e. use [AnimatedSwitcher]
              if (injectedNavigationFunction != null) {
                injectedNavigationFunction!(uri);
              }

              if (![
                'http',
                'https',
                'file',
                'chrome',
                'data',
                'javascript',
                'about'
              ].contains(uri.scheme)) {
                // Launch the App
                // await launch(
                //   url,
                // );
                // and cancel the request
                return NavigationActionPolicy.CANCEL;
              }

              return NavigationActionPolicy.ALLOW;
            },
    );
  }
  //*===========================================================================
  //*===========================================================================
}
