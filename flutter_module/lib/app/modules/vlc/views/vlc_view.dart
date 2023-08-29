import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/custom_inapp_webview.dart';
import '../controllers/vlc_controller.dart';
import '../widgets/meeting_internal_loader.dart';
import '../widgets/meeting_load_error.dart';

class VlcView extends GetView<VlcController> {
  //*================================ Properties ===============================

  //*================================ Constructor ==============================
  const VlcView({
    Key? key,
  }) : super(key: key);
  //*================================= Methods =================================

  @override
  Widget build(BuildContext context) {
    final url = controller.arguments.url;
    return WillPopScope(
      onWillPop: () async => await controller.exitVlcView(),
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: FutureBuilder(
            future: controller.enableAllFeatures(),
            builder: (_, __) => Stack(
              children: [
                CustomInAppWebView(
                  url: url,
                  onWebViewCreated: (inAppWebViewController) =>
                      controller.onWebViewCreated(
                    controller: inAppWebViewController,
                    url: url,
                  ),
                  useShouldOverrideUrlLoading: true,
                  injectedNavigationFunction: (uri) async =>
                      await controller.injectedNavigationFunction(
                    uri: uri,
                    context: context,
                  ),
                  onLoadStop: controller.onLoadStopped,
                  onLoadError: controller.onLoadError,
                ),
                Positioned.fill(
                  child: Obx(
                    () => MeetingInternalLoader(
                      isLoading: controller.isLoadingInternally,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Obx(
                    () => MeetingLoadError(
                      hasError: controller.hasLoadingError,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  //*===========================================================================
  //*===========================================================================
}
