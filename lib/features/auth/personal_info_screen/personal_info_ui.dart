import 'package:easy_localization/easy_localization.dart';
import 'package:eg_passport_app/core/customs/custom_button.dart';
import 'package:eg_passport_app/core/theme/app_colors.dart';
import 'package:eg_passport_app/features/auth/personal_info_screen/personal_info_cubit/personal_info_cubit.dart';
import 'package:eg_passport_app/features/auth/personal_info_screen/personal_info_cubit/personal_info_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../document_upload/document_upload.dart';
import '../widgets/background.dart';
import 'data/personal_list.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/customs/custom_dropdown.dart';
import '../../../core/customs/custom_textformfield.dart';
import 'app_validator.dart';

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
  String? selectedPlaceOfBirth;
  String? selectedNationality;

  Future<void> _showApiDialog({
    required String title,
    required String message,
  }) async {
    if (!mounted) return;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CustomButton(
            textName: "OK",
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nationalIdController.dispose();
    birthDateController.dispose();
    genderController.dispose();
    governorateController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => PersonalInfoCubit(),
        child: BlocBuilder<PersonalInfoCubit, PersonalInfoState>(
          builder: (context, state) {
            if (state is PersonalInfoLoading) {
              showDialog(
                context: context,
                builder: (context) => Center(child: CircularProgressIndicator()),
              );
            }
            if (state is PersonalInfoFailure) {
              _showApiDialog(title: 'error'.tr(), message: state.error);
            }
            if (state is PersonalInfoSuccess) {
              Navigator.of(context, rootNavigator: true).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DocumentUploadScreen()),
              );
            }
            return Background(
              currentIndex: 1,
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        /// TITLE
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "personal_info".tr(),
                              style: TextStyle(
                                color: const Color(0xff111827),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(width: 10.w),

                            Container(
                              height: 25.h,
                              width: 25.w,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xffE5E7EB),
                                  width: 1.w,
                                ),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Icon(
                                Icons.person_2_outlined,
                                size: 15.sp,
                                color: const Color(0xff6B7280),
                              ),
                            ),
                          ],
                        ),

                        Text(
                          "personal_info_desc".tr(),
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xff6B7280),
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 15.h),

                        /// NATIONAL ID
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

                        SizedBox(height: 12.h),

                        /// GENDER + DOB
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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

                                      const Icon(
                                        Icons.star,
                                        color: Colors.red,
                                        size: 10,
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 8),

                                  SizedBox(
                                    width: double.infinity,
                                    child: CustomDropDown(
                                      value: selectedGender,
                                      items: PersonalList.genderItems,
                                      hint: "gender".tr(),

                                      validator: (value) {
                                        return AppValidators.validateGender(
                                          value,
                                          context,
                                        );
                                      },

                                      onChanged: (String? value) {
                                        setState(() {
                                          selectedGender = value;
                                        });
                                      },
                                    ),
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
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now(),
                                  );

                                  if (pickedDate != null) {
                                    String formattedDate =
                                        "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";

                                    birthDateController.text = formattedDate;

                                    setState(() {});
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

                        SizedBox(height: 12.h),

                        /// GOVERNORATE
                        Row(
                          children: [
                            Text(
                              "governorate".tr(),
                              style: const TextStyle(
                                color: Color(0xff374151),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(width: 8),

                            const Icon(Icons.star, color: Colors.red, size: 10),
                          ],
                        ),

                        const SizedBox(height: 8),

                        SizedBox(
                          width: double.infinity,
                          child: CustomDropDown(
                            items: [
                              for (String governorate
                                  in PersonalList.egyptGovernorates)
                                DropdownMenuItem<String>(
                                  value: governorate,
                                  child: Text(governorate),
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
                        ),

                        SizedBox(height: 12.h),

                        /// ADDRESS
                        CustomTextFormField(
                          title: "address".tr(),
                          hint: "address_hint".tr(),
                          isRequired: true,
                          maxLength: 200,
                          controller: addressController,
                          keyboardType: TextInputType.text,
                          hinticon: Icons.home,

                          validator: (value) {
                            return AppValidators.validateAddress(value, context);
                          },
                        ),

                        SizedBox(height: 12.h),

                        /// NATIONALITY + PLACE OF BIRTH
                        Row(
                          children: [
                            Expanded(
                              child: CustomDropDown(
                                items: [
                                  for (String nationality
                                      in PersonalList.nationalities)
                                    DropdownMenuItem<String>(
                                      value: nationality,
                                      child: Text(nationality.tr()),
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
                            ),

                            SizedBox(width: 10.w),

                            Expanded(
                              child: CustomDropDown(
                                items: [
                                  for (String governorate
                                      in PersonalList.egyptGovernorates)
                                    DropdownMenuItem<String>(
                                      value: governorate,
                                      child: Text(governorate),
                                    ),
                                ],

                                hint: "place_of_birth".tr(),
                                hinticon: Icons.location_on,
                                value: selectedPlaceOfBirth,

                                validator: (value) {
                                  return AppValidators.validateGovernorate(
                                    value,
                                    context,
                                  );
                                },

                                onChanged: (String? value) {
                                  setState(() {
                                    selectedPlaceOfBirth = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 20.h),

                        /// BUTTONS
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: CustomButton(
                                textName: 'next'.tr(),
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    context
                                        .read<PersonalInfoCubit>()
                                        .personalInfo(
                                          nationalIdController.text,
                                          selectedGender!,
                                          birthDateController.text,
                                          selectedGovernorate!,
                                          addressController.text,
                                          selectedPlaceOfBirth!,
                                          selectedNationality!,
                                        );
                                  }
                                },
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: CustomButton(
                                textName: 'back'.tr(),
                                textColor: AppColors.primaryRedColor,
                                backgroundColor: Colors.white,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
