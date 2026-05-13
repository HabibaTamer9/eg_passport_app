// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `National ID`
  String get national_id {
    return Intl.message('National ID', name: 'national_id', desc: '', args: []);
  }

  /// `National ID is required`
  String get national_id_required {
    return Intl.message(
      'National ID is required',
      name: 'national_id_required',
      desc: '',
      args: [],
    );
  }

  /// `National ID must be exactly 14 digits`
  String get national_id_length {
    return Intl.message(
      'National ID must be exactly 14 digits',
      name: 'national_id_length',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid Egyptian National ID`
  String get national_id_invalid {
    return Intl.message(
      'Please enter a valid Egyptian National ID',
      name: 'national_id_invalid',
      desc: '',
      args: [],
    );
  }

  /// `This National ID is already registered`
  String get national_id_exists {
    return Intl.message(
      'This National ID is already registered',
      name: 'national_id_exists',
      desc: '',
      args: [],
    );
  }

  /// `Date of Birth`
  String get dob {
    return Intl.message('Date of Birth', name: 'dob', desc: '', args: []);
  }

  /// `Date of birth is required`
  String get dob_required {
    return Intl.message(
      'Date of birth is required',
      name: 'dob_required',
      desc: '',
      args: [],
    );
  }

  /// `You must be at least 18 years old to register`
  String get dob_age {
    return Intl.message(
      'You must be at least 18 years old to register',
      name: 'dob_age',
      desc: '',
      args: [],
    );
  }

  /// `Gender`
  String get gender {
    return Intl.message('Gender', name: 'gender', desc: '', args: []);
  }

  /// `Gender is required`
  String get gender_required {
    return Intl.message(
      'Gender is required',
      name: 'gender_required',
      desc: '',
      args: [],
    );
  }

  /// `Governorate`
  String get governorate {
    return Intl.message('Governorate', name: 'governorate', desc: '', args: []);
  }

  /// `Governorate is required`
  String get governorate_required {
    return Intl.message(
      'Governorate is required',
      name: 'governorate_required',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message('Address', name: 'address', desc: '', args: []);
  }

  /// `Address is required`
  String get address_required {
    return Intl.message(
      'Address is required',
      name: 'address_required',
      desc: '',
      args: [],
    );
  }

  /// `Address must be at least 10 characters`
  String get address_min {
    return Intl.message(
      'Address must be at least 10 characters',
      name: 'address_min',
      desc: '',
      args: [],
    );
  }

  /// `Address must not exceed 200 characters`
  String get address_max {
    return Intl.message(
      'Address must not exceed 200 characters',
      name: 'address_max',
      desc: '',
      args: [],
    );
  }

  /// `Nationality`
  String get nationality {
    return Intl.message('Nationality', name: 'nationality', desc: '', args: []);
  }

  /// `Nationality is required`
  String get nationality_required {
    return Intl.message(
      'Nationality is required',
      name: 'nationality_required',
      desc: '',
      args: [],
    );
  }

  /// `Place of Birth`
  String get place_of_birth {
    return Intl.message(
      'Place of Birth',
      name: 'place_of_birth',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
