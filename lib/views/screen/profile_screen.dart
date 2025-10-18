import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/user/user_bloc.dart';
import 'package:frontend/model/user_model.dart';
import 'package:frontend/repository/user_repository.dart';
import 'package:frontend/theme/custom_color_scheme.dart';
import 'package:frontend/theme/custom_text_style.dart';
import 'package:frontend/utils/validate_config.dart';
import 'package:frontend/views/widgets/utils/alert_confirm_widget.dart';
import 'package:frontend/views/widgets/utils/button_general_widget.dart';
import 'package:frontend/views/widgets/utils/form_input_widget.dart';
import 'package:frontend/views/widgets/utils/functions.dart';
import 'package:frontend/views/widgets/utils/top_widget.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = "/profile";
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserBloc userBloc = UserBloc();
  UserModel userModel = UserModel();
  UserRepository userRepository = UserRepository();

  final _formProfileKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController apellidoPController = TextEditingController();
  final TextEditingController apellidoMController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    userBloc.add(GetUserEvent(id: userModel.id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
        bloc: userBloc,
        listener: (context, state) {
          if (state is StartLoadingState) {
            loadingWidget(context, info: state.message);
          }
          if (state is EndLoadingState) {
            Navigator.pop(context);
          }

          if (state is ProfileUserState) {
            setState(() {
              userModel = state.userModel;
              nameController.text = userModel.name;
              apellidoPController.text = userModel.paternalName;
              apellidoMController.text = userModel.maternalName;
              emailController.text = userModel.email;
              usernameController.text = userModel.username;
              passwordController.text = userModel.password;
            });
          }

          if (state is SuccessfulState) {
            showSnackBar(context, state.message.toString(), type: AlertTypeMessage.success);
          }
          if (state is MessageState) {
            showSnackBar(context, "Error al actualizar información", type: state.typeMessage);
          }
          if (state is ErrorState) {
            confirmAlert(context, title: "Error", textContent: state.message, showCancel: false);
          }

        },
        child: profileWidget()
    );
  }

  Widget profileWidget() {
    return SafeArea(
      child: Scaffold(
        body: Column (
          children: [
            SizedBox(
              height: 60,
              child: TopWidget(
                titleHeader: "Perfil",
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formProfileKey,
                  child: Column(
                    children: [
                      /*Padding(
                      padding: const EdgeInsets.all(16),
                      child: ImageWidget(
                        title: "Imagen de perfil",
                        urlImage: urlImageController.text,
                      ),
                    ),*/
                      FormInputWidget(
                        title: "Nombre",
                        required: true,
                        fieldController: nameController,
                        onSave: (value) {
                          userModel.name = nameController.text;
                        },
                        textAlign: TextAlign.center,
                        exceptions: [
                          ValidateConfig.required()
                        ],
                      ),
                      FormInputWidget(
                        title: "Apellido Paterno",
                        required: true,
                        fieldController: apellidoPController,
                        onSave: (value) {
                          userModel.paternalName = apellidoPController.text;
                        },
                        textAlign: TextAlign.center,
                        exceptions: [
                          ValidateConfig.required()
                        ],
                      ),
                      FormInputWidget(
                        title: "Apellido Materno",
                        required: true,
                        fieldController: apellidoMController,
                        onSave: (value) {
                          userModel.maternalName = apellidoMController.text;
                        },
                        textAlign: TextAlign.center,
                        exceptions: [
                          ValidateConfig.required()
                        ],
                      ),
                      FormInputWidget(
                        title: "Correo Electronico",
                        required: true,
                        fieldController: emailController,
                        onSave: (value) {
                          userModel.email = emailController.text;
                        },
                        textAlign: TextAlign.center,
                        exceptions: [
                          ValidateConfig.required()
                        ],
                      ),
                      FormInputWidget(
                        title: "Username",
                        required: true,
                        fieldController: usernameController,
                        onSave: (value) {
                          userModel.username = usernameController.text;
                        },
                        textAlign: TextAlign.center,
                        exceptions: [
                          ValidateConfig.required()
                        ],
                      ),
                      FormInputWidget(
                        title: "Password",
                        bottomPadding: 16,
                        required: true,
                        fieldController: passwordController,
                        obscureText: !_isPasswordVisible,
                        onSave: (value) {
                          userModel.password = passwordController.text;
                        },
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
                        exceptions: [
                          ValidateConfig.required()
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
        bottomNavigationBar: Container(
          width: double.infinity,
          height: 80,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryBackground20,
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: ButtonGeneralWidget(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      backgroundColor: Theme.of(context).colorScheme.secondaryBgButton,
                      height: 48,
                      child: Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "Cancelar",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: CustomTextStyle.semiBold16.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryBtnText),
                        ),
                      )),
                ),
                Flexible(
                  child: ButtonGeneralWidget(
                      onPressed: () {
                        _submitForm();
                      },
                      backgroundColor:
                      Theme.of(context).colorScheme.senaryBgButton,
                      height: 48,
                      child: Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "Actualizar",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: CustomTextStyle.semiBold16.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryBtnText),
                        ),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formProfileKey.currentState!.validate()) {
      _formProfileKey.currentState!.save();
      setState(() {
        userBloc.add(EditUserEvent(userModel: userModel, messageSuccess: "Información actualizada", updateLocal: true));
      });
    }
  }
}
