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
  List<ProductModel> listProducts = [];

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
              listProducts = state.listProducts;
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
    debugPrint("listProducts.isNotEmpty: ${listProducts.isNotEmpty}");

    if (listProducts.isNotEmpty) {
      return ListView.builder(
        itemCount: listProducts.length,
        itemBuilder: (context, item) {
          return Padding(
            padding: const EdgeInsets.only(left: 16, top: 16, right: 16),

          );
        },
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
