import 'package:easy_localization/easy_localization.dart';
import 'package:eg_passport_app/customs/custom_dropdown.dart';
import 'package:eg_passport_app/customs/custom_textformfield.dart';
import 'package:eg_passport_app/personal_info_screen/app_validator.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nationalIdController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController governorateController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  String? selectedGender;
  String? selectedGovernorate;
  final List<String> egyptGovernorates = [
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
  String? selectedNationality;
  List<String> nationalities = [
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
  final List<DropdownMenuItem<String>> genderItems = [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 150.h,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/background.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),

            Expanded(
              child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.w),
                        height: double.infinity,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.r),
                            topRight: Radius.circular(30.r),
                          ),
                          border: Border.all(
                            color: Color(0xffE5E7EB),
                            width: 1.w,
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Form(
                            key: formKey,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "personal_info".tr(),
                                        style: TextStyle(
                                          color: Color(0xff111827),
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(width: 10.w),

                                      Container(
                                        height: 25.h,
                                        width: 25.w,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Color(0xffE5E7EB),
                                            width: 1.w,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            20.r,
                                          ),
                                        ),

                                        child: Icon(
                                          Icons.person_2_outlined,
                                          size: 15.sp,
                                          color: Color(0xff6B7280),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "personal_info_desc".tr(),
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Color(0xff6B7280),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  CustomTextFormField(
                                    title: "national_id".tr(),
                                    hint: "national_id_hint".tr(),
                                    isRequired: true,
                                    controller: nationalIdController,
                                    keyboardType: TextInputType.number,
                                    hinticon: Icons.credit_card,
                                    maxLength: 14,
                                    validator: (value) {
                                      return AppValidators.validateNationalId(
                                        value,
                                        context,
                                      );
                                    },
                                  ),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "gender".tr(),
                                                  style: const TextStyle(
                                                    color: Color(0xff374151),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Icon(
                                                  Icons.star,
                                                  color: Colors.red,
                                                  size: 10,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),

                                            CustomDropDown(
                                              value: selectedGender,
                                              validator: (value) {
                                                return AppValidators.validateGender(
                                                  value,
                                                  context,
                                                );
                                              },
                                              items: genderItems,
                                              hint: "gender".tr(),
                                              onChanged: (String? value) {
                                                setState(() {
                                                  selectedGender = value;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(width: 10.w),
                                      Expanded(
                                        child: CustomTextFormField(
                                          title: "dob".tr(),
                                          hint: "dob_hint".tr(),
                                          isRequired: true,
                                          controller: birthDateController,
                                          keyboardType: TextInputType.datetime,
                                          hinticon: Icons.calendar_today,
                                          onTap: () async {
                                            DateTime? pickedDate =
                                                await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(1900),
                                                  lastDate: DateTime.now(),
                                                );

                                            if (pickedDate != null) {
                                              String formattedDate =
                                                  "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                                              setState(() {
                                                birthDateController.text =
                                                    formattedDate;
                                              });
                                            }
                                          },
                                          validator: (value) {
                                            return AppValidators.validateDob(
                                              value,
                                              context,
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text(
                                        "gender".tr(),
                                        style: const TextStyle(
                                          color: Color(0xff374151),
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Icon(
                                        Icons.star,
                                        color: Colors.red,
                                        size: 10,
                                      ),
                                    ],
                                  ),

                                  CustomDropDown(
                                    items: [
                                      for (String governorate
                                          in egyptGovernorates)
                                        DropdownMenuItem<String>(
                                          value: governorate,

                                          child: Text(
                                            governorate,

                                            style: TextStyle(
                                              color: Color(0xff6B7280),
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                        ),
                                    ],
                                    hint: "governorate".tr(),
                                    hinticon: Icons.location_on,
                                    value: selectedGovernorate,
                                    validator: (value) {
                                      return AppValidators.validateGovernorate(
                                        value,
                                        context,
                                      );
                                    },
                                    onChanged: (String? value) {
                                      setState(() {
                                        selectedGovernorate = value;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                  CustomTextFormField(
                                    title: "address".tr(),
                                    hint: "address_hint".tr(),
                                    isRequired: true,
                                    maxLength: 200,
                                    controller: addressController,
                                    keyboardType: TextInputType.text,
                                    hinticon: Icons.home,
                                    validator: (value) {
                                      return AppValidators.validateAddress(
                                        value,
                                        context,
                                      );
                                    },
                                  ),
                                  SizedBox(height: 8.h),
                                  Row(
                                    children: [
                                      CustomDropDown(
                                        items: [
                                          for (String nationality
                                              in nationalities)
                                            DropdownMenuItem<String>(
                                              value: nationality,

                                              child: Text(
                                                nationality.tr(),

                                                style: TextStyle(
                                                  color: Color(0xff6B7280),
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                            ),
                                        ],

                                        hint: "nationality".tr(),

                                        hinticon: Icons.flag,

                                        value: selectedNationality,

                                        validator: (value) {
                                          return AppValidators.validateNationality(
                                            value,
                                            context,
                                          );
                                        },

                                        onChanged: (String? value) {
                                          setState(() {
                                            selectedNationality = value;
                                          });
                                        },
                                      ),

                                      SizedBox(width: 10.w),
                                      Expanded(
                                        child: CustomDropDown(
                                          items: [
                                            for (String governorate
                                                in egyptGovernorates)
                                              DropdownMenuItem<String>(
                                                value: governorate,

                                                child: Text(
                                                  governorate,

                                                  style: TextStyle(
                                                    color: Color(0xff6B7280),
                                                    fontSize: 14.sp,
                                                  ),
                                                ),
                                              ),
                                          ],
                                          hint: "place_of_birth".tr(),
                                          hinticon: Icons.location_on,
                                          value: selectedGovernorate,
                                          validator: (value) {
                                            return AppValidators.validateGovernorate(
                                              value,
                                              context,
                                            );
                                          },
                                          onChanged: (String? value) {
                                            setState(() {
                                              selectedGovernorate = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
