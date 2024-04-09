import 'package:chatapp/util/langs/ar.dart';
import 'package:chatapp/util/langs/en.dart';
import 'package:get/get.dart';

class TR extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': en,
        'ar': ar,
      };
}
