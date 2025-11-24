import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loginappv2/src/features/authentication/controllers/login_controller.dart';


class LoginForm extends StatelessWidget {
  LoginForm({super.key});

  final LoginController _controller = Get.put(LoginController());

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxBool _obscurePassword = true.obs;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: "E-Mail",
              prefixIcon: Icon(Icons.person_2_outlined),
            ),
          ),
          const SizedBox(height: 20),
          Obx(() => TextFormField(
            controller: passwordController,
            obscureText: _obscurePassword.value,
            decoration: InputDecoration(
              labelText: "Password",
              prefixIcon: Icon(Icons.password_outlined),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                onPressed: () => _obscurePassword.value = !_obscurePassword.value,
              ),
            ),
          )),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final email = emailController.text.trim();
                final password = passwordController.text.trim();

                if (email.isEmpty || password.isEmpty) {
                  Get.snackbar("Error", "Please enter email and password");
                  return;
                }

                _controller.loginUser(email, password);
              },
              child: const Text("LOGIN"),
            ),
          ),
        ],
      ),
    );
  }
}
