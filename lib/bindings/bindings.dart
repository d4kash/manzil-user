import 'package:Manzil/screens/vehicles/ontroller/controller.dart';
import 'package:Manzil/screens/vehicles/ontroller/home_controller.dart';
import 'package:get/get.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => LocationController());
    Get.lazyPut(() => Controller());
  }
}
