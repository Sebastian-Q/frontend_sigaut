import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/category/category_bloc.dart';
import 'package:frontend/model/category_model.dart';
import 'package:frontend/theme/custom_color_scheme.dart';
import 'package:frontend/theme/custom_text_style.dart';
import 'package:frontend/views/widgets/category_form_widget.dart';
import 'package:frontend/views/widgets/utils/alert_confirm_widget.dart';
import 'package:frontend/views/widgets/utils/container_general_widget.dart';
import 'package:frontend/views/widgets/utils/functions.dart';

class CategoriesScreen extends StatefulWidget {
  static const routeName = "/categorias";

  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  CategoryBloc categoryBloc = CategoryBloc();
  List<CategoryModel> listCategories = [
    CategoryModel()
      ..id = 1
      ..name = "Lubricantes"
      ..clave = "LUB"
      ..description = "Aceites, grasas y aditivos para motores y transmisiones.",

    CategoryModel()
      ..id = 2
      ..name = "Filtros"
      ..clave = "FIL"
      ..description = "Filtros de aceite, aire, combustible y cabina para distintos vehículos.",

    CategoryModel()
      ..id = 3
      ..name = "Frenos"
      ..clave = "FRE"
      ..description = "Pastillas, discos, tambores y líquido de frenos para autos y camiones.",

    CategoryModel()
      ..id = 4
      ..name = "Suspensión"
      ..clave = "SUS"
      ..description = "Amortiguadores, resortes y componentes de suspensión automotriz.",

    CategoryModel()
      ..id = 5
      ..name = "Eléctrico"
      ..clave = "ELE"
      ..description = "Baterías, bujías, alternadores, luces y componentes eléctricos.",

    CategoryModel()
      ..id = 6
      ..name = "Refrigerantes"
      ..clave = "REF"
      ..description = "Anticongelantes, líquidos refrigerantes y aditivos de enfriamiento.",

    CategoryModel()
      ..id = 7
      ..name = "Accesorios"
      ..clave = "ACC"
      ..description = "Limpiaparabrisas, alfombrillas, cubreasientos y otros accesorios.",

    CategoryModel()
      ..id = 8
      ..name = "Herramientas"
      ..clave = "HER"
      ..description = "Llaves, gatos hidráulicos y herramientas para mantenimiento automotriz.",
  ];

  @override
  void initState() {
    super.initState();
    categoryBloc.add(AllCategoriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocListener(
        bloc: categoryBloc,
        listener: (context, state) {
          if (state is StartLoadingState) {
            loadingWidget(context, info: state.message);
          }
          if (state is EndLoadingState) {
            Navigator.pop(context);
          }

          if (state is SuccessfulState) {
            if(state.exitWidget) {
              Navigator.pop(context);
            }
            categoryBloc.add(AllCategoriesEvent());
            showSnackBar(context, state.message.toString(), type: AlertTypeMessage.success);
          }

          if (state is MessageState) {
            Navigator.pop(context);
            showSnackBar(context, state.message.toString(), type: state.typeMessage);
          }

          if (state is ErrorState) {
            confirmAlert(context, title: "Error", textContent: state.message, showCancel: false);
          }

          if (state is AllCategoriesEvent) {
            setState(() {
              //listProducts = state.listProducts;
            });
          }
        },
        child: ContainerGeneralWidget(
          titleHeader: "Categorias",
          titleSearch: "Clave / Nombre",
          body: body,
          refreshFunction: () {
            categoryBloc.add(AllCategoriesEvent());
          },
          addFunction: addCategory,
          backFunction: () {
            ///TODO PENDIENTE
            debugPrint("OPRIMIO backFunction");
          },
        ),
      ),
    );
  }

  Widget get body {
    if (listCategories.isNotEmpty) {
      return Column(
        children: List.generate(listCategories.length, (index) {
          final category = listCategories[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).colorScheme.segundoBorder),
                color: Theme.of(context).colorScheme.quinaryBackground,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsetsGeometry.all(16),
                    child: Column(
                      children: [
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            category.name,
                            style: CustomTextStyle.semiBold20.copyWith(
                              color: Theme.of(context).colorScheme.terceroText,
                            ),
                          ),
                        ),
                        customMediumSizeHeight,
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16, right: 8),
                              child: Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(width: 2, color: Theme.of(context).colorScheme.quintoBorder)
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Image.network(
                                  //category.urlImage ??
                                      "https://thumbs.dreamstime.com/b/l%C3%ADnea-icono-del-negro-avatar-perfil-de-usuario-121102131.jpg",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      text: "Clave: ",
                                      style: CustomTextStyle.semiBold16.copyWith(color: Theme.of(context).colorScheme.sextoText),
                                      children: [
                                        TextSpan(
                                          text: category.clave,
                                          style: CustomTextStyle.semiBold16.copyWith(color: Theme.of(context).colorScheme.terceroText),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      text: "Descripción: ",
                                      style: CustomTextStyle.semiBold14.copyWith(color: Theme.of(context).colorScheme.sextoText),
                                      children: [
                                        TextSpan(
                                          text: category.description,
                                          style: CustomTextStyle.medium14.copyWith(color: Theme.of(context).colorScheme.terceroText),
                                        ),
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            )
                          ],
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (context) {
                                      return Dialog(
                                        elevation: 0,
                                        insetPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.0),
                                            side: BorderSide(width: 1, color: Theme.of(context).colorScheme.primary)),
                                        child: BlocProvider.value(
                                          value: categoryBloc,
                                          child: CategoryFormWidget(
                                            title: "Editar categoria",
                                            categoryModel: category,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: Theme.of(context).colorScheme.sextoIcon,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  confirmAlert(context,
                                      title: "Eliminar categoria",
                                      textContent: '¿Deseas eliminar la categoria: "${category.name}?"').then((value) {
                                    debugPrint("value: $value");
                                    if(value) {
                                      categoryBloc.add(DeleteCategoryEvent(id: category.id));
                                    }
                                  });
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .sextoIcon,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      );
    }

    return Center(
      child: Text(
        "No hay categorias registrados",
        textAlign: TextAlign.center,
        style: CustomTextStyle.bold32.copyWith(
          color: Theme.of(context).colorScheme.segundoText,
        ),
      ),
    );
  }

  void addCategory() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
            elevation: 0,
            insetPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(width: 1, color: Theme.of(context).colorScheme.primary)),
            child: BlocProvider.value(
              value: categoryBloc,
              child: const CategoryFormWidget(title: "Registrar Categoria",),
            )
        );
      },
    );
  }
}
