import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/product/product_bloc.dart';
import 'package:frontend/model/product_model.dart';
import 'package:frontend/utils/validate_config.dart';
import 'package:frontend/views/widgets/utils/form_input_widget.dart';
import 'package:frontend/views/widgets/utils/show_custom_dialog_widget.dart';

class ProductFormWidget extends StatefulWidget {
  final String title;
  final ProductModel? productModel;

  const ProductFormWidget({super.key, required this.title, this.productModel});

  @override
  State<ProductFormWidget> createState() => _ProductFormWidgetState();
}

class _ProductFormWidgetState extends State<ProductFormWidget> {
  late ProductBloc productBloc;
  ProductModel productModel = ProductModel();

  final _formProductKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController codeBarController;
  late TextEditingController stockController;
  late TextEditingController countMinController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;

  late TextEditingController categoryController;

  @override
  void initState() {
    super.initState();
    productBloc = context.read<ProductBloc>();
    if (widget.productModel != null) {
      productModel = widget.productModel!;
    }
    nameController = TextEditingController(text: productModel.name);
    codeBarController = TextEditingController(text: productModel.barCode);
    stockController = TextEditingController(text: "${productModel.stock}");
    countMinController = TextEditingController(text: "${productModel.quantityMinima}");
    priceController = TextEditingController(text: "${productModel.price}");
    descriptionController = TextEditingController(text: productModel.description);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShowCustomDialogWidget(
      title: widget.title,
      actionOk: () {
        _submitForm();
      },
      child: Form(
        key: _formProductKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                FormInputWidget(
                  topPadding: 8,
                  title: "Nombre",
                  required: true,
                  fieldController: nameController,
                  textAlign: TextAlign.center,
                  onSave: (value) {
                    productModel.name = nameController.text;
                  },
                  exceptions: [
                    ValidateConfig.required()
                  ],
                ),
                FormInputWidget(
                  title: "Codigo de Barras",
                  required: true,
                  fieldController: codeBarController,
                  textAlign: TextAlign.center,
                  onSave: (value) {
                    productModel.barCode = codeBarController.text;
                  },
                  exceptions: [
                    ValidateConfig.required(),
                    ValidateConfig.whiteSpaces()
                  ],
                ),
                FormInputWidget(
                  title: "Stock",
                  required: true,
                  fieldController: stockController,
                  textAlign: TextAlign.center,
                  onSave: (value) {
                    productModel.stock = double.parse(stockController.text);
                  },
                  inputType: TextInputType.number,
                  exceptions: [
                    ValidateConfig.required(),
                    ValidateConfig.numbers(),
                    ValidateConfig.decimalPrecision(),
                    ValidateConfig.whiteSpaces()
                  ],
                ),
                FormInputWidget(
                  title: "Cantidad Minima",
                  required: true,
                  fieldController: countMinController,
                  textAlign: TextAlign.center,
                  onSave: (value) {
                    productModel.quantityMinima = double.parse(countMinController.text);
                  },
                  inputType: TextInputType.number,
                  exceptions: [
                    ValidateConfig.required(),
                    ValidateConfig.numbers(),
                    ValidateConfig.decimalPrecision(),
                    ValidateConfig.whiteSpaces()
                  ],
                ),
                FormInputWidget(
                  title: "Precio",
                  required: true,
                  fieldController: priceController,
                  textAlign: TextAlign.center,
                  onSave: (value) {
                    productModel.price = double.parse(priceController.text);
                  },
                  inputType: TextInputType.number,
                  exceptions: [
                    ValidateConfig.required(),
                    ValidateConfig.numbers(),
                    ValidateConfig.decimalPrecision(),
                    ValidateConfig.whiteSpaces()
                  ],
                ),
                FormInputWidget(
                  bottomPadding: 8,
                  title: "Descripción",
                  fieldController: descriptionController,
                  textAlign: TextAlign.center,
                  onSave: (value) {
                    productModel.description = descriptionController.text;
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formProductKey.currentState!.validate()) {
      _formProductKey.currentState!.save();
      if (productModel.id == 0) {
        productBloc.add(SaveProductEvent(productModel: productModel));
      } else {
        productBloc.add(EditProductEvent(productModel: productModel));
      }
    }
  }
}
