import 'package:get/get.dart';

class ReaderController extends GetxController {
  @override
  void dispose() {
    Get.delete<ReaderController>();
    super.dispose();
  }
}
