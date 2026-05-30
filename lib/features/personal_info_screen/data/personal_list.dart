import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PersonalList {
  static final List<String> nationalities = [
    "Egyptian",
    "Saudi",
    "Emirati",
    "Kuwaiti",
    "Jordanian",
    "Palestinian",
    "Syrian",
    "Lebanese",
    "Iraqi",
    "Sudanese",
    "Libyan",
    "Tunisian",
    "Algerian",
    "Moroccan",
    "Omani",
    "Qatari",
    "Bahraini",
    "Yemeni",
    "Mauritanian",
    "Somali",
    "Djiboutian",
    "Comorian",
    "American",
    "British",
    "Canadian",
    "French",
    "German",
    "Italian",
    "Spanish",
    "Portuguese",
    "Russian",
    "Chinese",
    "Japanese",
    "Korean",
    "Indian",
    "Pakistani",
    "Turkish",
    "Greek",
    "Dutch",
    "Swedish",
    "Norwegian",
    "Danish",
    "Finnish",
    "Swiss",
    "Austrian",
    "Brazilian",
    "Argentinian",
    "Mexican",
    "Australian",
    "South African",
    "Nigerian",
    "Kenyan",
    "Ethiopian",
  ];
  static final List<String> egyptGovernorates = [
    "القاهرة",
    "الجيزة",
    "الإسكندرية",
    "الدقهلية",
    "البحيرة",
    "الشرقية",
    "الغربية",
    "المنوفية",
    "القليوبية",
    "كفر الشيخ",
    "الفيوم",
    "بني سويف",
    "المنيا",
    "أسيوط",
    "سوهاج",
    "قنا",
    "الأقصر",
    "أسوان",
    "الإسماعيلية",
    "السويس",
    "بورسعيد",
    "دمياط",
    "مطروح",
    "شمال سيناء",
    "جنوب سيناء",
    "البحر الأحمر",
    "الوادي الجديد",
  ];

  static final List<DropdownMenuItem<String>> genderItems = [
    DropdownMenuItem<String>(
      value: "Male",

      child: Row(
        children: [
          Icon(Icons.male, color: Color(0xff6B7280), size: 18),

          SizedBox(width: 8),

          Text("Male".tr(), style: TextStyle(color: Color(0xff6B7280))),
        ],
      ),
    ),

    DropdownMenuItem<String>(
      value: "Female",

      child: Row(
        children: [
          Icon(Icons.female, color: Color(0xff6B7280), size: 18),

          SizedBox(width: 8),

          Text("Female".tr(), style: TextStyle(color: Color(0xff6B7280))),
        ],
      ),
    ),
  ];
}