import 'package:flutter/material.dart';
import 'package:frontend/core/theme/custom_color_scheme.dart';
import 'package:frontend/core/theme/custom_text_style.dart';
import 'package:frontend/features/user/view/widgets/login_form_widget.dart';
import 'package:frontend/features/others/view/widgets/functions.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/auth/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).colorScheme.quinaryBackground,
        body: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryBackground
          ),
          child: Column(
            children: [
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    customSizeHeight,
                    Text("Abarrotes UTEZ", style: CustomTextStyle.bold32.copyWith(color: Theme.of(context).colorScheme.quinaryBackground),),
                    const SizedBox(height: 8,),
                    Expanded(
                      child: Image.asset(
                        "assets/images/logo.png",
                        fit: BoxFit.contain,
                      ),
                    )
                  ],
                ),
              ),

              Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container (
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                      ),
                      child: const LoginFormWidget(),
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
