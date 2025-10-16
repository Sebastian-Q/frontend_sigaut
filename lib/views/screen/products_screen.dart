import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/product/product_bloc.dart';
import 'package:frontend/model/product_model.dart';
import 'package:frontend/theme/custom_color_scheme.dart';
import 'package:frontend/theme/custom_text_style.dart';
import 'package:frontend/views/widgets/product_form_widget.dart';
import 'package:frontend/views/widgets/utils/alert_confirm_widget.dart';
import 'package:frontend/views/widgets/utils/container_general_widget.dart';
import 'package:frontend/views/widgets/utils/functions.dart';

class ProductsScreen extends StatefulWidget {
  static const routeName = "/productos";
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  ProductBloc productBloc = ProductBloc();
  List<ProductModel> listProducts = [
    ProductModel()
      ..id = 1
      ..name = "Aceite para motor 5W-30"
      ..price = 250.50
      ..barCode = "7501234567890"
      ..description = "Aceite sintético para motores de gasolina. Mejora el rendimiento."
      ..stock = 35
      ..quantityMinima = 5
      ..accountSale = 10,
    ProductModel()
      ..id = 2
      ..name = "Filtro de aire"
      ..price = 120.00
      ..barCode = "7502345678901"
      ..description = "Filtro de aire estándar para autos compactos."
      ..stock = 50
      ..quantityMinima = 8
      ..accountSale = 15,
    ProductModel()
      ..id = 3
      ..name = "Bujía NGK"
      ..price = 85.00
      ..barCode = "7503456789012"
      ..description = "Bujía de encendido de alto rendimiento NGK."
      ..stock = 100
      ..quantityMinima = 10
      ..accountSale = 25,
    ProductModel()
      ..id = 4
      ..name = "Anticongelante 1L"
      ..price = 90.00
      ..barCode = "7504567890123"
      ..description = "Anticongelante y refrigerante de larga duración."
      ..stock = 60
      ..quantityMinima = 5
      ..accountSale = 18,
    ProductModel()
      ..id = 5
      ..name = "Líquido de frenos DOT-4"
      ..price = 110.00
      ..barCode = "7505678901234"
      ..description = "Líquido de frenos de alto punto de ebullición DOT-4."
      ..stock = 40
      ..quantityMinima = 6
      ..accountSale = 12,
    ProductModel()
      ..id = 6
      ..name = "Limpiaparabrisas universal"
      ..price = 75.50
      ..barCode = "7506789012345"
      ..description = "Par de limpiaparabrisas de 21 pulgadas, modelo universal."
      ..stock = 25
      ..quantityMinima = 4
      ..accountSale = 8,
    ProductModel()
      ..id = 7
      ..name = "Batería 12V 600A"
      ..price = 1450.00
      ..barCode = "7507890123456"
      ..description = "Batería automotriz de alto desempeño, libre de mantenimiento."
      ..stock = 10
      ..quantityMinima = 2
      ..accountSale = 3,
    ProductModel()
      ..id = 8
      ..name = "Juego de pastillas de freno"
      ..price = 320.00
      ..barCode = "7508901234567"
      ..description = "Pastillas de freno cerámicas, compatibles con sedanes compactos."
      ..stock = 20
      ..quantityMinima = 5
      ..accountSale = 7,
  ];


  @override
  void initState() {
    super.initState();
    productBloc.add(AllProductsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocListener(
        bloc: productBloc,
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
            productBloc.add(AllProductsEvent());
            showSnackBar(context, state.message.toString(), type: AlertTypeMessage.success);
          }

          if (state is MessageState) {
            Navigator.pop(context);
            showSnackBar(context, state.message.toString(), type: state.typeMessage);
          }

          if (state is ErrorState) {
            confirmAlert(context, title: "Error", textContent: state.message, showCancel: false);
          }

          if (state is AllProductsState) {
            setState(() {
              //listProducts = state.listProducts;
            });
          }
        },
        child: ContainerGeneralWidget(
          titleHeader: "Productos",
          titleSearch: "Codigo barras / Nombre",
          body: body,
          refreshFunction: () {
            productBloc.add(AllProductsEvent());
          },
          addFunction: addProduct,
          backFunction: () {
            ///TODO PENDIENTE
            debugPrint("OPRIMIO backFunction");
          },
        ),
      ),
    );
  }

  Widget get body {
    if (listProducts.isNotEmpty) {
      return Column(
        children: List.generate(listProducts.length, (index) {
          final product = listProducts[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: colorBorder(product.stock, product.quantityMinima), width: 2),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              product.name,
                              style: CustomTextStyle.semiBold18.copyWith(color: Theme.of(context).colorScheme.terceroText),
                            ),
                            Text("\$${product.price}", style: CustomTextStyle.semiBold18.copyWith(color: Theme.of(context).colorScheme.terceroText),),
                          ],
                        ),
                        customMediumSizeHeight,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "CB: ${product.barCode}",
                              style: CustomTextStyle.semiBold16.copyWith(color: Theme.of(context).colorScheme.sextoText),
                            ),
                            Text(
                              "Stock: ${product.stock}",
                              textAlign: TextAlign.end,
                              style: CustomTextStyle.semiBold16.copyWith(color: Theme.of(context).colorScheme.sextoText),
                            ),
                          ],
                        ),
                        customMediumSizeHeight,
                        if(product.description != "")...{
                          Align(
                            alignment: AlignmentGeometry.centerLeft,
                            child: Text(
                              product.description,
                              style: CustomTextStyle.medium14.copyWith(color: Theme.of(context).colorScheme.sextoText),
                            ),
                          )
                        },
                      ],
                    ),
                  ),

                  Container(
                    height: 2,
                    color: colorBorder(product.stock, product.quantityMinima),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
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
                                      value: productBloc,
                                      child: ProductFormWidget(title: "Editar Producto", productModel: product,),
                                    )
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
                                title: "Eliminar Producto",
                                textContent: '¿Deseas eliminar al producto: "${product.name}?"').then((value) {
                              if(value) {
                                productBloc.add(DeleteProductEvent(id: product.id));
                              }
                            });
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).colorScheme.sextoIcon,
                          ),
                        )
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
        "No hay productos registrados",
        textAlign: TextAlign.center,
        style: CustomTextStyle.bold32.copyWith(
          color: Theme.of(context).colorScheme.segundoText,
        ),
      ),
    );
  }

  Color colorBorder(double stock, double amountMin) {
    if (stock > amountMin) {
      return Theme.of(context).colorScheme.primeroBorder;
    }
    if (stock == amountMin) {
      return Theme.of(context).colorScheme.segundoBorder;
    }
    return Theme.of(context).colorScheme.terceroBorder;
  }

  void addProduct() {
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
              value: productBloc,
              child: const ProductFormWidget(title: "Registrar Producto",),
            )
        );
      },
    );
  }
}
