import 'package:flutter/material.dart';
import 'package:loginappv2/src/constants/colors.dart';
import 'package:loginappv2/src/constants/image_strings.dart';
import 'package:loginappv2/src/constants/text_strings.dart';
import 'package:loginappv2/src/features/authentication/controllers/signup_controller.dart';
import 'package:loginappv2/src/features/authentication/screens/login/login_footer_widget.dart';
import 'package:loginappv2/src/features/authentication/screens/login/login_form_widget.dart';
import 'package:loginappv2/src/commom_widgets/forms/form_header_widget.dart';
import 'package:get/get.dart';
import 'package:loginappv2/src/features/authentication/screens/login/login_screen.dart';


class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // Call Controller
    final controller = Get.put(SignUpController());
    final _formkey = GlobalKey<FormState>();

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormHeaderWidget(
                  image: OnBoardingImage1,
                  title: SignUpTitle,
                  subtitle: SignUpSubTitle,
                ),
                Container(
                  padding: EdgeInsets.all(30.0),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: controller.fullName,
                          decoration: InputDecoration(
                            label: Text("Full Name"),
                            prefixIcon: Icon(Icons.person_outline_rounded),
                          ),
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          controller: controller.email,
                          decoration: InputDecoration(
                            label: Text("Email"),
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          controller: controller.phoneNo,
                          decoration: InputDecoration(
                            label: Text("Phone No"),
                            prefixIcon: Icon(Icons.numbers),
                          ),
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          controller: controller.password,
                          decoration: InputDecoration(
                            label: Text("Password"),
                            prefixIcon: Icon(Icons.password_rounded),
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if(_formkey.currentState!.validate()){
                                SignUpController.instance.registerUser(controller.email.text.trim(), controller.password.text.trim());
                              }
                            },
                            child: Text("Sign Up"),
                          ),
                        ),
                        Column(
                          children: [
                            const Text("OR"),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(onPressed:(){},icon:const Image(image: AssetImage(GoogleLogoImage),width: 20,height: 20,),
                              label:const Text("Sign Up with Google"),
                              ),
                            ),
                            TextButton(onPressed: ()=>Get.to(()=>LoginScreen()), child: const Text("Already have an account? Login"))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
