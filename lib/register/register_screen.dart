import 'package:eg_passport_app/LoginScreen.dart';
import 'package:eg_passport_app/customs/custom_button.dart';
import 'package:eg_passport_app/customs/custom_textformfield.dart';
import 'package:eg_passport_app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = "registerScreen";

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey=GlobalKey<FormState>();

  final nameController=TextEditingController();
  final nationalIdController=TextEditingController();
  final emailController=TextEditingController();
  final phoneController=TextEditingController();
  final passwordController=TextEditingController();
  final confirmPasswordController=TextEditingController();

  bool isChecked=false;

  @override
  void dispose() {
    nameController.dispose();
    nationalIdController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      resizeToAvoidBottomInset: true,

      body: Stack(
        children: [

          Positioned.fill(
            child: Column(
              children: [
                Expanded(
                  flex: 4,
                  child: Image.asset(
                    'assets/images/main_img.png',
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                const Expanded(
                  flex: 6,
                  child: SizedBox(),
                ),
              ],
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,

            child: Container(
              height: MediaQuery.of(context).size.height * 0.72,
              width: double.infinity,

              decoration: const BoxDecoration(
                color: AppColors.whiteColor,

                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),

              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20),

                child: Column(
                  children: [
                    const SizedBox(height: 15),

                    // title
                    Text(
                      "انشاء حساب جديد",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge,
                    ),

                    const SizedBox(height: 5),

                    // subtitle
                    Text(
                      "انضم الي منصة الهوية الرقمية الذكية",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium,
                    ),

                    const SizedBox(height: 12),


                    Expanded(
                      child: SingleChildScrollView(
                        keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior
                            .onDrag,

                        child: Form(
                          key: _formKey,
                        child: Column(
                          children: [

                            CustomTextFormField(
                              title: 'الاسم الكامل',
                              hint: 'ادخل اسمك رباعي',
                              isRequired: true,
                              controller:
                              TextEditingController(),
                              hinticon:
                              Icons.person_2_outlined,
                              keyboardType:
                              TextInputType.name,
                              validator: (value){
                                if(value==null || value.isEmpty)
                                  {
                                    return " من فضلك ادخل الاسم";
                                  }
                                return null;

                              },
                            ),

                            const SizedBox(height: 2),

                            CustomTextFormField(
                              title: 'الرقم القومي',
                              hint: 'ادخل الرقم القومي',
                              isRequired: true,
                              controller:
                              TextEditingController(),
                              hinticon: Icons.badge,
                              keyboardType:
                              TextInputType.number,
                              validator: (value){
                                if(value==null || value.isEmpty)
                                {
                                  return "   من فضلك ادخل الرقم القومي";
                                }
                                if(value.length!=14)
                                  {
                                    return "لرقم القومي يجب أن يكون 14 رقم";
                                  }
                                return null;},
                            ),

                            const SizedBox(height: 2),

                            CustomTextFormField(
                              title:
                              'البريد الإلكتروني',
                              hint:
                              'ادخل البريد الإلكتروني',
                              isRequired: true,
                              controller:
                              TextEditingController(),
                              hinticon: Icons.email,
                              keyboardType:
                              TextInputType.emailAddress,
                              validator:(value){
                                if(value==null || value.isEmpty)
                                  {
                                    return "ادخل البريد الإلكتروني";
                                  }
                                if(!value.contains("@"))
                                  {
                                    return "البريد الإلكتروني غير صحيح";
                                  }
                                return null;
                              },

                            ),

                            const SizedBox(height: 2),

                            CustomTextFormField(
                              title:
                              'رقم الهاتف المحمول',
                              hint:
                              'ادخل رقم الهاتف المحمول',
                              isRequired: true,
                              controller:
                              TextEditingController(),
                              hinticon: Icons.phone,
                              keyboardType:
                              TextInputType.phone,
                              validator: (value){
                                if(value==null || value.isEmpty)
                                  {
                                    return " من فضلك ادخل رقم الهاتف";
                                  }
                                if(value.length!=11)
                                  {
                                    return "لرقم الهاتف يجب أن يكون 11 رقم";
                                  }
                                return null;
                              }
                            ),

                            const SizedBox(height: 2),

                            CustomTextFormField(
                              title: 'كلمة المرور',
                              hint: 'ادخل كلمة المرور',
                              controller:
                              TextEditingController(),
                              hinticon: Icons.lock,
                              isRequired: true,
                              obscureText: true,
                              keyboardType:
                              TextInputType.visiblePassword,
                              validator: (value)
                              {
                                if(value==null || value.isEmpty)
                                {
                                  return " من فضلك ادخل كلمة المرور";
                                }
                                if(value.length<6)
                                  {
                                    return "لكلمة المرور يجب أن تكون 6 أحرف على الأقل";
                                  }
                                return null;
                              },
                            ),

                            const SizedBox(height: 2),

                            CustomTextFormField(
                              title:
                              'تاكيد كلمة المرور',
                              hint:
                              'اعد ادخال كلمة المرور',
                              controller:
                              TextEditingController(),
                              hinticon: Icons.lock,
                              isRequired: true,
                              obscureText: true,
                              keyboardType:
                              TextInputType.visiblePassword,
                              validator: (value){
                                if(value==null || value.isEmpty)
                                {
                                  return " من فضلك ادخل كلمة المرور";
                                }
                                if(value!=passwordController.text)
                                  {
                                    return "كلمة المرور غير متطابقة";
                                  }
                                return null;

                              },
                            ),

                            const SizedBox(height: 3),

                            // checkbox
                            Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Checkbox(
                                  value: isChecked,
                                  onChanged: (value) {
                                    setState(() {
                                      isChecked = value!;
                                    });
                                  },
                                  activeColor:
                                  AppColors.greyColor,

                                ),

                                Expanded(
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.only(
                                      top: 12,
                                    ),

                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                            'أوافق على ',
                                            style: Theme.of(
                                                context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                              color:
                                              AppColors
                                                  .blackColor,
                                            ),
                                          ),

                                          TextSpan(
                                            text:
                                            "الشروط والاحكام وسياسه الخصوصية",
                                            style: Theme.of(
                                                context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                              color:
                                              AppColors
                                                  .primaryRedColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 15),
                          ],
                        ),
                      ),
                      ),
                    ),

                    const SizedBox(height: 5),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: CustomButton(textName: "انشاء حساب",
                      onPressed: ()
                          {
                            if(_formKey.currentState!.validate())
                              {
                                if(! isChecked)
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("يجب الموافقة على الشروط والأحكام")));
                                    return;
                                  }
                                Navigator.pushReplacementNamed(
                                  context,
                                  Loginscreen.routeName,
                                );
                              }
                          },
                      backgroundColor:AppColors.primaryRedColor),

                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(child:
                        Divider(
                          color: AppColors.lightGreyColor,
                          thickness: 1,
                        )),
                        Text(" لديك حساب بالفعل ؟  ",
                            style: Theme.of(context).textTheme.bodyMedium),
                        Expanded(child:
                        Divider(
                          color: AppColors.lightGreyColor,
                          thickness: 1,
                        )),

                      ],
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: CustomButton(textName: "تسجيل دخول",
                        onPressed: (){
                          Navigator.pushReplacementNamed(
                            context,
                            Loginscreen.routeName,
                          );
                        },
                        backgroundColor:AppColors.whiteColor,),

                    ),

                    const SizedBox(height: 10),
                  ],

                ),

              ),
            ),
          ),
        ],
      ),
    );
  }
}










































/*import 'package:eg_passport_app/customs/custom_textformfield.dart';
import 'package:eg_passport_app/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  static const String routeName = "registerScreen";

  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // image
          Container(
            padding: const EdgeInsets.only(top: 25),
            child: Image.asset(
              'assets/images/main_img.png',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),


          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.69,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),

              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [

                    const SizedBox(height: 10),

                    const Text(
                      "انشاء حساب جديد",
                      style: TextStyle(
                        color:AppColors.blackColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Sign up to get started",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 5),
                    CustomTextFormField(title: 'الاسم الكامل'
                      , hint: 'ادخل اسمك رباعي ا',
                      controller: TextEditingController(),
                      hinticon: Icons.person,
                      keyboardType: TextInputType.name,

                    )

                  ],
                ),
              ),
            ),
          ),

          // circle
          Positioned(
            top: 0.29 * 800,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.lightGreyColor,
                      blurRadius: 10,
                    )
                  ],
                ),
                child: const Icon(
                  Icons.person_add_alt_1_outlined,
                  size: 30,
                  color: Colors.red,
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
*/
















