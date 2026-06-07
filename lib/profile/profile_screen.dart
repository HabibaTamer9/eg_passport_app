import 'dart:io';
import 'package:eg_passport_app/customs/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:eg_passport_app/theme/app_colors.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = "profileScreen";

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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

      await Future.delayed(const Duration(seconds: 2));

      Map<String, dynamic> apiResponse = {
        "name": "سهيله امام فوزي",
        "birth_date": "15 مارس 1996",
        "nationality": "مصري",
        "passport_num": "A12345678",
        "is_verified": true,
      };

      setState(() {
        userName = (apiResponse["name"] != null && apiResponse["name"].toString().trim().isNotEmpty)
            ? apiResponse["name"]
            : "مستخدم غير معروف";

        birthDate = apiResponse["birth_date"] ?? "غير مسجل";
        nationality = apiResponse["nationality"] ?? "غير محدد";

        String rawPassport = apiResponse["passport_num"] ?? "";
        if (_isValidPassport(rawPassport)) {
          passportNumber = rawPassport;
        } else {
          passportNumber = "رقم غير صالح";
        }

        isVerified = apiResponse["is_verified"] ?? false;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "فشل في تحميل البيانات، يرجى المحاولة لاحقاً.";
      });
    }
  }

  bool _isValidPassport(String passport) {
    if (passport.isEmpty) return false;
    final RegExp passportRegex = RegExp(r'^[a-zA-Z]\d{7,9}$');
    return passportRegex.hasMatch(passport);
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

  void _showEditNameDialog() {
    final TextEditingController nameController = TextEditingController(text: userName);
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text("تعديل الاسم الشخصي"),
            content: Form(
              key: formKey,
              child: TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "الاسم بالكامل",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "من فضلك أدخل اسماً صالحاً";
                  }
                  return null;
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("إلغاء", style: TextStyle(color: Colors.red)),
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    setState(() {
                      userName = nameController.text.trim();
                    });
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.darkBlueColor),
                child: const Text("حفظ", style: TextStyle(color: AppColors.whiteColor)),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: AppColors.darkBlueColor,
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(errorMessage!, style: TextStyle(color: AppColors.darkGreyColor, fontSize: 16)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: fetchProfileData,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.darkBlueColor),
              child: const Text("إعادة المحاولة", style: TextStyle(color: AppColors.whiteColor)),
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
              "الملف الشخصي",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),

          const SizedBox(height: 5),

          Center(
            child: Text(
              "اداره البيانات الشخصيه ومعلومات الحساب",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.darkGreyColor,
              ),
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
              textDirection: TextDirection.rtl,
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
                                  : const AssetImage("assets/images/main_img.png"),
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
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: _showEditNameDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.darkBlueColor,
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: const BorderSide(
                            color: AppColors.greyColor,
                            width: 0.5,
                          ),
                        ),
                        icon: const Icon(Icons.edit, color: AppColors.whiteColor, size: 14),
                        label: Text(
                          "تعديل",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.whiteColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
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
                        label: "تاريخ الميلاد:",
                        value: birthDate ?? "",
                      ),
                      const SizedBox(height: 12),
                      _buildProfileInfoItem(
                        context,
                        label: "الجنسية:",
                        value: nationality ?? "",
                      ),
                      const SizedBox(height: 12),
                      _buildProfileInfoItem(
                        context,
                        label: "رقم جواز السفر:",
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
                  "مستوي التحقق",
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
                      isVerified ? "موثق" : "غير موثق",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: isVerified ? AppColors.greenColor : Colors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  isVerified ? "تم التحقق من هويتك بنجاح" : "يرجى استكمال التحقق من الهوية",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.darkBlueColor,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  isVerified
                      ? "جميع بياناتك موثقه ويمكن الاستفاده من جميع الخدمات الرقميه"
                      : "بعض الخدمات قد تكون محجوبة حتى يتم رفع وتأكيد المستندات الرسمية",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.greyColor,
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isVerified ? AppColors.lightGreenColor : Colors.orange.withOpacity(0.2),
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isVerified ? "عرض تفاصيل التحقق" : "ابدأ التحقق الآن",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: isVerified ? AppColors.greenColor : Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          CustomContainer(title: "المعلومات الشخصية", icon: Icons.lock),
          CustomContainer(title: "اعدادات الحساب", icon: Icons.settings_rounded),
          CustomContainer(title: "معلومات اضافيه", icon: Icons.verified_user),
          CustomContainer(title: "الاجهزة الموثوقة", icon: Icons.phonelink_lock),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildProfileInfoItem(BuildContext context, {required String label, required String value}) {
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
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.whiteColor,
          ),
        ),
      ],
    );
  }
}
