import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:eg_passport_app/core/data/app_data.dart';
import 'package:eg_passport_app/core/models/user_model.dart';
import 'package:eg_passport_app/features/profile/widgets/personal_info.dart';
import 'package:eg_passport_app/features/profile/widgets/setting_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/models/passport_model.dart';
import 'widgets/custom_container.dart';
import '../../core/theme/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = "profileScreen";

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserModel user;
  late PassportModel passport;
  String? userName;
  String? birthDate;
  String? nationality;
  String? passportNumber;
  bool isVerified = false;

  bool isLoading = true;
  String? errorMessage;

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      user = AppData.user;
      passport = AppData.passport;

      setState(() {
        userName = user.name;

        birthDate = user.dateOfBirth ?? "غير مسجل";
        nationality = user.nationality ?? "غير محدد";
        var message = AppData.isArabic ?passport.messageAr: passport.messageEn;
        passportNumber = passport.passportNumber ?? message;

        if (user.state == "PendingReview") {
          isVerified = false;
        } else if (user.state == "Approved") {
          isVerified = true;
        } else {
          isVerified = false;
        }

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "فشل في تحميل البيانات، يرجى المحاولة لاحقاً.";
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("حدث خطأ أثناء اختيار الصورة")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(color: AppColors.darkBlueColor),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              errorMessage!,
              style: TextStyle(color: AppColors.darkGreyColor, fontSize: 16),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: fetchProfileData,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkBlueColor,
              ),
              child: const Text(
                "إعادة المحاولة",
                style: TextStyle(color: AppColors.whiteColor),
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),

          Center(
            child: Text(
              'profile'.tr(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),

          const SizedBox(height: 5),

          Center(
            child: Text(
              'profile_desc'.tr(),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppColors.darkGreyColor),
            ),
          ),

          const SizedBox(height: 15),

          ////////////////////// كارت معلومات المستخدم //////////////////////
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.darkBlueColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 2,
                                color: AppColors.greyColor,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 40,
                              backgroundImage: _imageFile != null
                                  ? FileImage(_imageFile!) as ImageProvider
                                  : const NetworkImage(
                                      "https://cdn.pixabay.com/photo/2023/02/18/11/00/icon-7797704_640.png",
                                    ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: _pickImageFromGallery,
                              child: const CircleAvatar(
                                radius: 13,
                                backgroundColor: AppColors.whiteColor,
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 16,
                                  color: AppColors.darkGreyColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        userName ?? "",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                Container(
                  height: 140,
                  width: 0.5,
                  color: AppColors.greyColor.withOpacity(0.5),
                ),

                const SizedBox(width: 12),

                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      _buildProfileInfoItem(
                        context,
                        label: 'dob'.tr(),
                        value: birthDate ?? "",
                      ),
                      const SizedBox(height: 12),
                      _buildProfileInfoItem(
                        context,
                        label: 'nationality'.tr(),
                        value: nationality ?? "",
                      ),
                      const SizedBox(height: 12),
                      _buildProfileInfoItem(
                        context,
                        label: 'passport_number'.tr(),
                        value: passportNumber ?? "",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          ////////////////////// كارت مستوى التحقق //////////////////////
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.lightGreyColor,
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'verification_level'.tr(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.darkBlueColor,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isVerified ? Icons.check_circle : Icons.error_outline,
                      color: isVerified ? AppColors.greenColor : Colors.orange,
                      size: 30,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      isVerified ? 'verified'.tr() : 'not_verified'.tr(),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: isVerified
                            ? AppColors.greenColor
                            : Colors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  isVerified
                      ? 'verified_message'.tr()
                      : 'not_verified_message'.tr(),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.darkBlueColor,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  isVerified
                      ? 'verified_message_2'.tr(): 'not_verified_message_2'.tr(),
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppColors.greyColor),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          CustomContainer(
            title: 'personal_info'.tr(),
            icon: Icons.lock,
            child: PersonalInfo(),
          ),
          CustomContainer(
            title: 'setting'.tr(),
            icon: Icons.settings_rounded,
            child: SettingWidget(),
          ),
          CustomContainer(title: 'more_info'.tr(), icon: Icons.verified_user),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildProfileInfoItem(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.greyColor,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: AppColors.whiteColor),
        ),
      ],
    );
  }
}
