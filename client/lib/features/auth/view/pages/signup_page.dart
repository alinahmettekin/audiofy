import 'package:client/core/utils.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/auth/view/pages/login_page.dart';
import 'package:client/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:client/core/widgets/custom_field.dart';
import 'package:client/features/auth/view/widgets/info_span.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:client/features/home/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authViewModelProvider.select(
      (value) => value?.isLoading == true,
    ));

    ref.listen(
      authViewModelProvider,
      (_, next) {
        next?.when(
          data: (data) {
            showSnackBar(context, 'Account Created Successfully');
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
              (route) => false,
            );
          },
          error: (error, st) {
            showSnackBar(context, error.toString());
          },
          loading: () {},
        );
      },
    );

    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? Loader()
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        'Sign Up',
                        style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 30),
                    CustomField(
                      controller: nameController,
                      hintText: 'Name',
                    ),
                    const SizedBox(height: 10),
                    CustomField(
                      controller: emailController,
                      hintText: 'Email',
                    ),
                    const SizedBox(height: 10),
                    CustomField(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    AuthGradientButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            ref.read(authViewModelProvider.notifier).signUpUser(
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                          } else {
                            showSnackBar(context, 'Please fill in the required fields');
                          }
                        },
                        buttonText: 'Sign Up'),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: InfoSpan(
                        message: 'Already have an account? ',
                        routeName: 'Log In',
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
