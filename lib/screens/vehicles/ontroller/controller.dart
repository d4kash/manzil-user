import 'package:Manzil/helper/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Controller extends GetxController {
  RxString selectedValue = "Select time Slot".obs;
  RxString selectedDistance = "Select Distance".obs;
  RxBool isClicked = false.obs;
  // RxBool get isLoading => isClicked;
  void showPicker(BuildContext ctx) {
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => CupertinoActionSheet(
            actions: [Picker()],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(ctx),
              child: Text("Save"),
            )));
  }

  Widget Picker() {
    return Container(
      height: 350,
      child: CupertinoPicker(
        backgroundColor: Colors.white,
        itemExtent: 64,
        // scrollController: FixedExtentScrollController(initialItem: 1),
        children: TIME_SLOT
            .map(
              (item) => Text(
                item,
                style: TextStyle(fontSize: 35, color: Colors.red),
              ),
            )
            .toList(),
        onSelectedItemChanged: (value) {
          selectedValue.value = TIME_SLOT[value];
          update();
        },
      ),
    );
  }

  void showDistancePicker(BuildContext ctx) {
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => CupertinoActionSheet(
            actions: [DistancePicker()],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(ctx),
              child: Text("Save"),
            )));
  }

  Widget DistancePicker() {
    return Container(
      height: 350,
      child: CupertinoPicker(
        backgroundColor: Colors.white,
        itemExtent: 64,
        // scrollController: FixedExtentScrollController(initialItem: 1),
        children: Distance_Slot.map(
          (item) => Text(
            item,
            style: TextStyle(fontSize: 35, color: Colors.red),
          ),
        ).toList(),
        onSelectedItemChanged: (value) {
          selectedDistance.value = Distance_Slot[value];
          update();
        },
      ),
    );
  }

  //! circularbar

}
