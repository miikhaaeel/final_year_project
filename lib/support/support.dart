import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';

class Support {
  static spinkit({Color? color}) {
    return SpinKitWaveSpinner(
      color: color ?? Colors.white,
      size: 30.0,
      trackColor: Colors.blueGrey,
    );
  }

  static showLoader(BuildContext context) {
    //show loading overlay
    OverlayLoadingProgress.start(
      context,
      widget: Support.spinkit(),
      barrierDismissible: false,
      barrierColor: Colors.blueGrey.withOpacity(0.2),
    );
  }

  static stopLoader() {
    //stop loading overlay
    OverlayLoadingProgress.stop();
  }

  static showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blueGrey,
      textColor: Colors.white,
      fontSize: 14,
    );
  }

  static showSuccessSnackbarAuth(String title, String message) {
    Get.snackbar(
      title,
      message,
      // colorText: Colors.white,
      backgroundColor: Colors.white,
      snackPosition: SnackPosition.TOP,
      snackStyle: SnackStyle.FLOATING,
      duration: const Duration(seconds: 5),
      titleText: Text(
        title,
        style: TextStyle(
          color: Colors.blueGrey,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      messageText: Text(
        message,
        style: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  static showfailureSnackbar(String title, String message) {
    Get.snackbar(
      title, message,
      snackPosition: SnackPosition.TOP,
      snackStyle: SnackStyle.FLOATING,
      duration: const Duration(seconds: 5),
      titleText: Text(
        title,
        style: TextStyle(
          color: Colors.red,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      messageText: Text(
        message,
        style: TextStyle(
          color: Colors.black45,
          //  Color(0xFF818181),
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
      ),
      // colorText: ColorUtil.redColor,
      backgroundColor: Colors.white,
    );
  }
}
