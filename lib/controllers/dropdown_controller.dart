import 'package:get/get.dart';

class DropdownController extends GetxController {
  var searchQuery = ''.obs;
  var selectedItem = ''.obs;

  void updateQuery(String query) {
    searchQuery.value = query;
  }

  void selectItem(String item) {
    selectedItem.value = item;
  }
}