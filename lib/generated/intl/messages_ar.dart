// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ar locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ar';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "address": MessageLookupByLibrary.simpleMessage("العنوان"),
    "address_max": MessageLookupByLibrary.simpleMessage(
      "العنوان لا يجب أن يتجاوز 200 حرف",
    ),
    "address_min": MessageLookupByLibrary.simpleMessage(
      "العنوان يجب أن يكون 10 أحرف على الأقل",
    ),
    "address_required": MessageLookupByLibrary.simpleMessage("العنوان مطلوب"),
    "dob": MessageLookupByLibrary.simpleMessage("تاريخ الميلاد"),
    "dob_age": MessageLookupByLibrary.simpleMessage(
      "يجب أن يكون عمرك 18 عامًا على الأقل للتسجيل",
    ),
    "dob_required": MessageLookupByLibrary.simpleMessage("تاريخ الميلاد مطلوب"),
    "gender": MessageLookupByLibrary.simpleMessage("النوع"),
    "gender_required": MessageLookupByLibrary.simpleMessage("النوع مطلوب"),
    "governorate": MessageLookupByLibrary.simpleMessage("المحافظة"),
    "governorate_required": MessageLookupByLibrary.simpleMessage(
      "المحافظة مطلوبة",
    ),
    "national_id": MessageLookupByLibrary.simpleMessage("الرقم القومي"),
    "national_id_exists": MessageLookupByLibrary.simpleMessage(
      "هذا الرقم القومي مسجل بالفعل",
    ),
    "national_id_invalid": MessageLookupByLibrary.simpleMessage(
      "الرقم القومي غير صحيح",
    ),
    "national_id_length": MessageLookupByLibrary.simpleMessage(
      "الرقم القومي يجب أن يتكون من 14 رقمًا",
    ),
    "national_id_required": MessageLookupByLibrary.simpleMessage(
      "الرقم القومي مطلوب",
    ),
    "nationality": MessageLookupByLibrary.simpleMessage("الجنسية"),
    "nationality_required": MessageLookupByLibrary.simpleMessage(
      "الجنسية مطلوبة",
    ),
    "place_of_birth": MessageLookupByLibrary.simpleMessage("مكان الميلاد"),
  };
}
