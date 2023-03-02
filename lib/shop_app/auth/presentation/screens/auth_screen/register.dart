import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_with_clean_arch/core/services/service_locator.dart';
import 'package:shop_with_clean_arch/shop_app/auth/presentation/controller/register_cubit.dart';
import 'package:shop_with_clean_arch/shop_app/auth/presentation/controller/register_state.dart';
import 'package:shop_with_clean_arch/shop_app/auth/presentation/widgets/navigate.dart';
import 'package:shop_with_clean_arch/shop_app/auth/presentation/widgets/text_form_field.dart';
import 'package:shop_with_clean_arch/shop_app/layout.dart';

class RegisterScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => sl<RegisterCubit>(),
        child: BlocConsumer<RegisterCubit, RegisterState>(
            listener: (context, state) {
          if (state is RegisterSuccessState) {
            if (state.register.status) {
              customSnakeBar(
                  context: context,
                  widget: Text(state.register.message),
                  backgroundColor: Colors.green);
              navigateTo(context, const Screen());
            } else {
              customSnakeBar(
                  context: context,
                  widget: Text(state.register.message),
                  backgroundColor: Colors.red);
            }
          }
        }, builder: (context, state) {
          return Scaffold(
              appBar: AppBar(),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Register',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          DefaultFormField(
                              controller: nameController,
                              type: TextInputType.name,
                              validate: (value) {
                                if (value.isEmpty) {
                                  return 'Please Enter Your Name';
                                }
                              },
                              prefix: Icons.person,
                              text: 'Name'),
                          const SizedBox(
                            height: 20,
                          ),
                          DefaultFormField(
                              controller: emailController,
                              type: TextInputType.emailAddress,
                              validate: (value) {
                                if (value.isEmpty) {
                                  return 'Please Enter Your Email';
                                }
                              },
                              prefix: Icons.email_outlined,
                              text: 'Email'),
                          const SizedBox(
                            height: 20,
                          ),
                          DefaultFormField(
                              controller: passwordController,
                              type: TextInputType.visiblePassword,
                              validate: (value) {
                                if (value.isEmpty) {
                                  return 'Please Enter Your Password';
                                }
                              },
                              prefix: Icons.lock,
                              text: 'Password'),
                          const SizedBox(
                            height: 20,
                          ),
                          DefaultFormField(
                              controller: phoneController,
                              type: TextInputType.phone,
                              validate: (value) {
                                if (value.isEmpty) {
                                  return 'Please Enter Your Phone';
                                }
                              },
                              prefix: Icons.phone,
                              text: 'Phone'),
                          const SizedBox(
                            height: 28,
                          ),
                          Container(
                            height: 60,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10))),
                            child: MaterialButton(
                              child: const Text(
                                'Register',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  RegisterCubit.get(context).signUp(
                                      email: emailController.text,
                                      password: passwordController.text,
                                      name: nameController.text,
                                      phone: phoneController.text);
                                }
                              },
                            ),
                          ),
                        ],
                      )),
                ),
              ));
        }));
  }
}

void customSnakeBar({
  required context,
  required widget,
  Color? backgroundColor,
}) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: widget,
      backgroundColor: backgroundColor,
    ));
