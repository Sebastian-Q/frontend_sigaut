import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/user/user_bloc.dart';
import 'package:frontend/model/user_model.dart';
import 'package:frontend/theme/custom_color_scheme.dart';
import 'package:frontend/theme/custom_text_style.dart';
import 'package:frontend/utils/validate_config.dart';
import 'package:frontend/views/widgets/utils/button_general_widget.dart';
import 'package:frontend/views/widgets/utils/form_input_widget.dart';
import 'package:frontend/views/widgets/utils/functions.dart';

class RegisterFormWidget extends StatefulWidget {
  const RegisterFormWidget({super.key});

  @override
  State<RegisterFormWidget> createState() => _RegisterFormWidgetState();
}

class _RegisterFormWidgetState extends State<RegisterFormWidget> {
  late UserBloc userBloc;
  UserModel userModel = UserModel();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController = TextEditingController();
  late TextEditingController paternalNameController = TextEditingController();
  late TextEditingController maternalNameController = TextEditingController();
  late TextEditingController emailController = TextEditingController();
  late TextEditingController directionController = TextEditingController();
  late TextEditingController usernameController = TextEditingController();
  late TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    userBloc = BlocProvider.of<UserBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          FormInputWidget(
            title: "Nombre",
            required: true,
            fieldController: nameController,
            textAlign: TextAlign.center,
            iconSuffix: const Icon(Icons.perm_identity_outlined),
            onChange: (value) {
              userModel.name = value;
            },
            exceptions: [ValidateConfig.required(), ValidateConfig.onlyLetters()],
          ),
          FormInputWidget(
            title: "Apellido Paterno",
            required: true,
            fieldController: paternalNameController,
            textAlign: TextAlign.center,
            iconSuffix: const Icon(Icons.perm_identity_outlined),
            onChange: (value) {
              userModel.paternalName = value;
            },
            exceptions: [ValidateConfig.required(), ValidateConfig.onlyLetters()],
          ),
          FormInputWidget(
            title: "Apellido Materno",
            required: true,
            fieldController: maternalNameController,
            textAlign: TextAlign.center,
            iconSuffix: const Icon(Icons.perm_identity_outlined),
            onChange: (value) {
              userModel.maternalName = value;
            },
            exceptions: [ValidateConfig.required(), ValidateConfig.onlyLetters()],
          ),
          FormInputWidget(
            title: "Correo Electronico",
            required: true,
            fieldController: emailController,
            textAlign: TextAlign.center,
            iconSuffix: const Icon(Icons.email_outlined),
            onChange: (value) {
              userModel.email = value;
            },
            exceptions: [ValidateConfig.required(), ValidateConfig.email(), ValidateConfig.whiteSpaces()],
          ),
          FormInputWidget(
            title: "Dirección",
            required: true,
            fieldController: directionController,
            textAlign: TextAlign.center,
            iconSuffix: const Icon(Icons.map_outlined),
            onChange: (value) {
              userModel.direction = value;
            },
            exceptions: [ValidateConfig.required()],
          ),
          FormInputWidget(
            title: "Username",
            required: true,
            fieldController: usernameController,
            textAlign: TextAlign.center,
            iconSuffix: const Icon(Icons.perm_identity_outlined),
            onChange: (value) {
              userModel.username = value;
            },
            exceptions: [ValidateConfig.required(), ValidateConfig.whiteSpaces()],
          ),
          FormInputWidget(
            title: "Password",
            required: true,
            obscureText: !_isPasswordVisible,
            fieldController: passwordController,
            textAlign: TextAlign.center,
            iconSuffix: IconButton(
              icon: _isPasswordVisible
                  ? const Icon(Icons.visibility)
                  : const Icon(Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
            onChange: (value) {
              userModel.password = value;
            },
            exceptions: [ValidateConfig.required()],
          ),
          customSizeHeight,
          ButtonGeneralWidget(
            width: MediaQuery.of(context).size.width,
            height: 50,
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                userBloc.add(SaveUserEvent(userModel: userModel));
              }
            },
            backgroundColor: Theme.of(context).colorScheme.primaryBgButton,
            child: Text(
              "Registrarse",
              style: CustomTextStyle.semiBold16.copyWith(
                color: Theme.of(context).colorScheme.primaryBtnText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
