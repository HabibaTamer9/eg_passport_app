// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "address": MessageLookupByLibrary.simpleMessage("Address"),
    "address_max": MessageLookupByLibrary.simpleMessage(
      "Address must not exceed 200 characters",
    ),
    "address_min": MessageLookupByLibrary.simpleMessage(
      "Address must be at least 10 characters",
    ),
    "address_required": MessageLookupByLibrary.simpleMessage(
      "Address is required",
    ),
    "dob": MessageLookupByLibrary.simpleMessage("Date of Birth"),
    "dob_age": MessageLookupByLibrary.simpleMessage(
      "You must be at least 18 years old to register",
    ),
    "dob_required": MessageLookupByLibrary.simpleMessage(
      "Date of birth is required",
    ),
    "gender": MessageLookupByLibrary.simpleMessage("Gender"),
    "gender_required": MessageLookupByLibrary.simpleMessage(
      "Gender is required",
    ),
    "governorate": MessageLookupByLibrary.simpleMessage("Governorate"),
    "governorate_required": MessageLookupByLibrary.simpleMessage(
      "Governorate is required",
    ),
    "national_id": MessageLookupByLibrary.simpleMessage("National ID"),
    "national_id_exists": MessageLookupByLibrary.simpleMessage(
      "This National ID is already registered",
    ),
    "national_id_invalid": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid Egyptian National ID",
    ),
    "national_id_length": MessageLookupByLibrary.simpleMessage(
      "National ID must be exactly 14 digits",
    ),
    "national_id_required": MessageLookupByLibrary.simpleMessage(
      "National ID is required",
    ),
    "nationality": MessageLookupByLibrary.simpleMessage("Nationality"),
    "nationality_required": MessageLookupByLibrary.simpleMessage(
      "Nationality is required",
    ),
    "place_of_birth": MessageLookupByLibrary.simpleMessage("Place of Birth"),
  };
}
