import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_module/app/core/utils/extensions.dart';
import 'package:get/get.dart';
import '../../../core/utils/design_utils.dart';
import '../../../widgets/custom_inapp_webview.dart';
import '../../../widgets/text/custom_text.dart';

class DialogWebView extends StatelessWidget {
  //*================================ Properties ===============================
  final Uri uri;
  //*================================ Constructor ==============================
  const DialogWebView({
    required this.uri,
    super.key,
  });
  //*================================= Methods =================================
  @override
  Widget build(BuildContext context) {
    //*================================ Properties =============================
    final closeText = 'close'.tr;
    final dialogPadding = (0.01).wf;
    final dialogHeight = (0.95).hf;
    //*=========================================================================
    return Material(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            DesignUtils.defaultBorderRadiusValue,
          ),
        ),
      ),
      child: Container(
        height: dialogHeight,
        padding: EdgeInsets.all(dialogPadding),
        child: Column(
          children: [
            Align(
              alignment: AlignmentDirectional.topStart,
              child: CupertinoButton(
                onPressed: () => Navigator.of(context).pop(),
                child: CustomText(closeText),
              ),
            ),
            Expanded(
              child: CustomInAppWebView(
                url: uri.toString(),
                onWebViewCreated: (p0) {},
              ),
            ),
          ],
        ),
      ),
    );
  }
  //*===========================================================================
}
