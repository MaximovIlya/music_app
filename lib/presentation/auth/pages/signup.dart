import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:music_app/common/widgets/appbar/app_bar.dart';
import 'package:music_app/common/widgets/button/basic_app_button.dart';
import 'package:music_app/core/configs/assets/app_vectors.dart';
import 'package:music_app/data/models/auth/create_user_req.dart';
import 'package:music_app/domain/usecases/auth/signup.dart';
import 'package:music_app/presentation/auth/pages/signin.dart';
import 'package:music_app/presentation/home/pages/home.dart';
import 'package:music_app/service_locator.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          false, 
      bottomNavigationBar: _signinText(context),
      appBar: BasicAppBar(
        title: SvgPicture.asset(
          AppVectors.logo,
          height: 40,
          width: 40,
        ),
      ),
      body: SingleChildScrollView(
        // Добавьте это для прокрутки
        padding: const EdgeInsets.symmetric(
          vertical: 50,
          horizontal: 30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _registerText(),
            const SizedBox(
              height: 50,
            ),
            _fullNameField(context),
            const SizedBox(
              height: 20,
            ),
            _emailField(context),
            const SizedBox(
              height: 20,
            ),
            _passwordField(context),
            const SizedBox(
              height: 20,
            ),
            BasicAppButton(
              onPressed: () async {
                var result = await sl<SignupUseCase>().call(
                  params: CreateUserReq(
                    fullname: _fullName.text.toString(),
                    email: _email.text.toString(),
                    password: _password.text.toString(),
                  ),
                );
                result.fold(
                  (l) {
                    var snackbar = SnackBar(content: Text(l));
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  },
                  (r) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext content) => const HomePage(),
                      ),
                      (route) => false,
                    );
                  },
                );
              },
              title: 'Create Account',
            ),
          ],
        ),
      ),
    );
  }

  Widget _registerText() {
    return const Text(
      'Register',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 25,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _fullNameField(BuildContext context) {
    return TextField(
      controller: _fullName,
      decoration: const InputDecoration(
        hintText: 'Full Name',
      ).applyDefaults(
        Theme.of(context).inputDecorationTheme,
      ),
    );
  }

  Widget _emailField(BuildContext context) {
    return TextField(
      controller: _email,
      decoration: const InputDecoration(
        hintText: 'Enter Email',
      ).applyDefaults(
        Theme.of(context).inputDecorationTheme,
      ),
    );
  }

  Widget _passwordField(BuildContext context) {
    return TextField(
      controller: _password,
      decoration: const InputDecoration(
        hintText: 'Password',
      ).applyDefaults(
        Theme.of(context).inputDecorationTheme,
      ),
    );
  }

  Widget _signinText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 30,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Do you have an account?',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => SigninPage(),
                ),
              );
            },
            child: const Text(
              'Sign in',
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
