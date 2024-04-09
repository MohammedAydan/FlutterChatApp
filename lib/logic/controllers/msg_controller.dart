import 'package:get/get.dart';

class MsgController extends GetxController {
  bool selectedMode = false;
  List<int> msgSelected = [];

  bool isSelected(int msg) {
    return msgSelected.where((m) => m == msg).isNotEmpty;
  }

  void selectOrUnSelectMsg(int msg) {
    selectedMode = true;
    if (!isSelected(msg)) {
      msgSelected.add(msg);
    } else {
      msgSelected.remove(msg);
      if (msgSelected.isEmpty) {
        selectedMode = false;
        update();
      }
    }
    update();

    print(msg);
    print(msgSelected);
  }

  void unSelectAll() {
    selectedMode = false;
    msgSelected.clear();
    update();
  }
}
