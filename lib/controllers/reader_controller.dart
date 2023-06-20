import 'package:get/get.dart';

class ReaderController extends GetxController {
  var backgroundColour = "White".obs;

  void updateBackgroundcolour(String selectedValue) {
    backgroundColour.value = selectedValue;
  }

  @override
  void dispose() {
    Get.delete<ReaderController>();
    super.dispose();
  }
}
