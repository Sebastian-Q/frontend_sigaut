import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/product/product_bloc.dart';
import 'package:frontend/model/product_model.dart';
import 'package:frontend/theme/custom_color_scheme.dart';
import 'package:frontend/theme/custom_text_style.dart';
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
          addFunction: () {
            debugPrint("OPRIMIO addFunction");
          },
          backFunction: () {
            debugPrint("OPRIMIO backFunction");
          },
        ),
      ),
    );
  }

  Widget get body {
    debugPrint("listProducts.isNotEmpty: ${listProducts.toList()}");
    debugPrint("listProducts.isNotEmpty: ${listProducts.length}");
    debugPrint("listProducts.isNotEmpty: ${listProducts.isNotEmpty}");

    if (listProducts.isNotEmpty) {
      return Container(
        padding: EdgeInsets.only(bottom: 16),
        color: Theme.of(context).colorScheme.segundoBackground,
        child: ListView.builder(
          itemCount: listProducts.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, item) {
            ProductModel product = listProducts[item];

            return Padding(
              padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.quinaryBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: Theme.of(context).colorScheme.primeroBorder,
                      width: 2.5
                  ),
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(product.name),

                        Text("\$ ${product.price}")
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("CB: ${product.barCode}"),

                        Text("Stock: ${product.stock}")
                      ],
                    ),
                    Text(
                        product.description
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
    return Center(
      child: Text(
        "No hay productos registrados",
        textAlign: TextAlign.center,
        style: CustomTextStyle.bold32.copyWith(color: Theme.of(context).colorScheme.segundoText),
      ),
    );
  }
}
