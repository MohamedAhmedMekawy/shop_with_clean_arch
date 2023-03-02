import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_with_clean_arch/config/global/localize/locale/app_localizations.dart';
import 'package:shop_with_clean_arch/config/global/localize/localization/presentation/controller/locale_cubit.dart';
import 'package:shop_with_clean_arch/config/global/theme/cubit/cubit.dart';
import 'package:shop_with_clean_arch/core/services/service_locator.dart';
import 'package:shop_with_clean_arch/core/utils/cache_helper.dart';
import 'package:shop_with_clean_arch/shop_app/auth/presentation/controller/login_bloc.dart';
import 'package:shop_with_clean_arch/shop_app/auth/presentation/controller/login_state.dart';
import 'package:shop_with_clean_arch/shop_app/auth/presentation/screens/auth_screen/register.dart';
import 'package:shop_with_clean_arch/shop_app/auth/presentation/widgets/navigate.dart';
import 'package:shop_with_clean_arch/shop_app/auth/presentation/widgets/text_button.dart';
import 'package:shop_with_clean_arch/shop_app/auth/presentation/widgets/text_form_field.dart';
import 'package:shop_with_clean_arch/shop_app/layout.dart';

class LoginScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => sl<LoginCubit>(),
        child: BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) {
          if (state is LoginSuccessState) {
            if (state.login.status) {
              PreferenceUtils.setString(
                   'token',
                  state.login.data!.token).then((value) {
                customSnakeBar(context: context,
                    widget: Text(state.login.message),
                    backgroundColor: Colors.green);
                navigateAndFinish(context, const Screen());
              });

            } else {
              customSnakeBar(context: context,
                  widget: Text(state.login.message),
                  backgroundColor: Colors.red);
            }
          }
        }, builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                backgroundColor:Theme.of(context).appBarTheme.backgroundColor ,
                actions: [
                  IconButton(
                    onPressed: () {
                      ThemeCubit.get(context).changeAppTheme();
                    },
                    icon: const Icon(Icons.dark_mode),
                  ),
                ],
                title: Text(AppLocalizations.of(context)!.translate('home')!),
                leading: IconButton(
                  onPressed: () {
                    if (AppLocalizations.of(context)!.isEnLocale) {
                      BlocProvider.of<LocaleCubit>(context).toArabic();
                    } else {
                      BlocProvider.of<LocaleCubit>(context).toEnglish();
                    }
                  },
                  icon: const Icon(Icons.translate_outlined),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome',
                          ),
                          const Text(
                            'Back !',
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Hey! Good to see you again',
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const Text(
                            'SIGN IN',
                          ),
                          DefaultFormField(
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            validate: (String value) {
                              if (value.isEmpty) {
                                return 'Please Enter Your Email';
                              }
                              return null;
                            },
                            prefix: Icons.email_outlined,
                            text: 'Email',
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          DefaultFormField(
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            validate: (String value) {
                              if (value.isEmpty) {
                                return 'Please Enter Your Password';
                              }
                              return null;
                            },
                            prefix: Icons.lock,
                            text: 'Password',
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Container(
                            height: 40,
                            width: double.infinity,
                            color: Colors.grey[200],
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.blue,
                              child: MaterialButton(
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      LoginCubit.get(context).signIn(
                                          email: emailController.text,
                                          password: passwordController.text);
                                    }
                                  },
                                  child: const Icon(Icons.arrow_forward_outlined)),
                            ),
                          ),
                          Row(
                            children: [
                              const Text(
                                'Don\'t have an account ?',
                              ),
                              Expanded(
                                child: DefaultTextButton(
                                  function: () {
                                    navigateTo(context, RegisterScreen());
                                  },
                                  text: 'Register Now',
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ));
        }));
  }
}
void customSnakeBar({
  required  context,
  required widget,
  Color? backgroundColor,
}) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: widget,
      backgroundColor: backgroundColor,
    ));