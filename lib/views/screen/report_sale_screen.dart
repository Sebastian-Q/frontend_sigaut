import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/sale/sale_bloc.dart';
import 'package:frontend/model/product_model.dart';
import 'package:frontend/model/sale_model.dart';
import 'package:frontend/theme/custom_color_scheme.dart';
import 'package:frontend/theme/custom_text_style.dart';
import 'package:frontend/views/widgets/utils/container_general_widget.dart';
import 'package:frontend/views/widgets/utils/form_input_widget.dart';
import 'package:frontend/views/widgets/utils/functions.dart';
import 'package:frontend/views/widgets/utils/show_custom_dialog_widget.dart';
import 'package:intl/intl.dart';

class ReportSaleScreen extends StatefulWidget {
  static const routeName = "/report/sale";

  const ReportSaleScreen({super.key});

  @override
  State<ReportSaleScreen> createState() => _ReportSaleScreenState();
}

class _ReportSaleScreenState extends State<ReportSaleScreen> {
  SaleBloc saleBloc = SaleBloc();
  List<SaleModel> listSales = [
    SaleModel()
      ..id = 1
      ..total = 250.50
      ..amountSale = 3
      ..dateSale = DateTime.parse("2025-10-15")
      ..employee = "Juan Pérez"
      ..payMethod = "Tarjeta"
      ..productList = [
        ProductModel()
          ..id = 1
          ..name = "Laptop HP 15"
          ..barCode = "1234567890123"
          ..price = 150.50
          ..description = "Laptop HP 15.6'' con procesador Ryzen 5"
          ..stock = 10
          ..quantityMinima = 2
          ..accountSale = 1,
        ProductModel()
          ..id = 2
          ..name = "Mouse Logitech M90"
          ..barCode = "9876543210987"
          ..price = 50.00
          ..description = "Mouse óptico con cable USB"
          ..stock = 30
          ..quantityMinima = 5
          ..accountSale = 2,
      ],

    SaleModel()
      ..id = 2
      ..total = 99.99
      ..amountSale = 1
      ..dateSale = DateTime.parse("2025-10-16")
      ..employee = "María López"
      ..payMethod = "Efectivo"
      ..productList = [
        ProductModel()
          ..id = 3
          ..name = "Teclado Mecánico Redragon"
          ..barCode = "4567891234567"
          ..price = 99.99
          ..description = "Teclado mecánico retroiluminado RGB"
          ..stock = 15
          ..quantityMinima = 3
          ..accountSale = 1,
      ],

    SaleModel()
      ..id = 3
      ..total = 560.75
      ..amountSale = 5
      ..dateSale = DateTime.parse("2025-10-17")
      ..employee = "Carlos Díaz"
      ..payMethod = "Transferencia"
      ..productList = [
        ProductModel()
          ..id = 4
          ..name = "Monitor LG 27'' UHD"
          ..barCode = "3216549870321"
          ..price = 320.75
          ..description = "Monitor 4K UHD con panel IPS"
          ..stock = 8
          ..quantityMinima = 2
          ..accountSale = 1,
        ProductModel()
          ..id = 5
          ..name = "Cable HDMI 2.1"
          ..barCode = "7418529632587"
          ..price = 30.00
          ..description = "Cable HDMI 4K de 2 metros"
          ..stock = 50
          ..quantityMinima = 10
          ..accountSale = 4,
      ],

    SaleModel()
      ..id = 4
      ..total = 45.00
      ..amountSale = 2
      ..dateSale = DateTime.parse("2025-10-18")
      ..employee = "Ana Torres"
      ..payMethod = "Efectivo"
      ..productList = [
        ProductModel()
          ..id = 6
          ..name = "Cuaderno A4 Profesional"
          ..barCode = "1597534862200"
          ..price = 15.00
          ..description = "Cuaderno de 100 hojas rayado"
          ..stock = 60
          ..quantityMinima = 10
          ..accountSale = 2,
        ProductModel()
          ..id = 7
          ..name = "Bolígrafo Azul BIC"
          ..barCode = "9513578524862"
          ..price = 7.50
          ..description = "Paquete de 2 bolígrafos de tinta azul"
          ..stock = 100
          ..quantityMinima = 20
          ..accountSale = 2,
      ],

    SaleModel()
      ..id = 5
      ..total = 1250.00
      ..amountSale = 2
      ..dateSale = DateTime.parse("2025-10-18")
      ..employee = "Luis Ramírez"
      ..payMethod = "Crédito"
      ..productList = [
        ProductModel()
          ..id = 8
          ..name = "iPhone 15 Pro"
          ..barCode = "8524569637891"
          ..price = 1200.00
          ..description = "Smartphone Apple con 256GB"
          ..stock = 5
          ..quantityMinima = 1
          ..accountSale = 1,
        ProductModel()
          ..id = 9
          ..name = "Funda protectora MagSafe"
          ..barCode = "1472583691472"
          ..price = 50.00
          ..description = "Funda de silicona con imán MagSafe"
          ..stock = 20
          ..quantityMinima = 3
          ..accountSale = 1,
      ],
  ];
  bool loading = false;

  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    saleBloc.add(AllSalesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocListener(
        bloc: saleBloc,
        listener: (context, state) {
          if (state is StartLoadingState) {
            loadingWidget(context, info: state.message);
          }
          if (state is EndLoadingState) {
            Navigator.pop(context);
          }

          if (state is AllSalesState) {
            setState(() {
              //listSales = state.listSales;
              loading = true;
            });
          }
        },
        child: ContainerGeneralWidget(
          titleHeader: "Reporte de ventas",
          body: body,
          refreshFunction: () {
            saleBloc.add(AllSalesEvent());
          },
          otherActions: [
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
                        child: ShowCustomDialogWidget(
                            title: "Filtro de ventas",
                            actionCancel: () {
                              startDateController.text = "";
                              endDateController.text = "";
                              Navigator.pop(context);
                              saleBloc.add(AllSalesEvent());
                            },
                            actionOk: () {
                              Navigator.pop(context);
                              saleBloc.add(AllSalesEvent(startDate: startDateController.text, endDate: endDateController.text));
                            },
                            tittleActionOk: 'Aplicar filtros',
                            tittleCloseActionCancel: "Borrar filtros",
                            showActionCancel: true,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: FormInputWidget(
                                          title: "Fecha Inicio",
                                          fieldController: startDateController,
                                        )
                                    ),
                                    Expanded(
                                        flex: 1,
                                        child: FormInputWidget(
                                          title: "Fecha Fin",
                                          fieldController: endDateController,
                                        )
                                    ),
                                  ],
                                ),
                                customSizeHeight
                              ],
                            )
                        )
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.filter_alt_outlined,
                size: 32,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget get body {
    if (listSales.isNotEmpty) {
      return Column(
        children: List.generate(listSales.length, (index) {
          final report = listSales[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.quintoBackground,
                border: Border.all(color: Theme.of(context).colorScheme.primeroBorder, width: 2),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        "Venta de Productos",
                        style: CustomTextStyle.semiBold18.copyWith(color: Theme.of(context).colorScheme.septimoText),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(right: 16, left: 16, bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text.rich(
                              TextSpan(
                                text: "Folio - ",
                                style: CustomTextStyle.medium10.copyWith(color: Theme.of(context).colorScheme.septimoText),
                                children: [
                                  TextSpan(
                                    text: "${report.id}",
                                    style: CustomTextStyle.bold10.copyWith(color: Theme.of(context).colorScheme.septimoText),
                                  ),
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                text: "Fecha - ",
                                style: CustomTextStyle.medium10.copyWith(color: Theme.of(context).colorScheme.septimoText),
                                children: [
                                  TextSpan(
                                    text: DateFormat('dd/MM/yyyy').format(report.dateSale),
                                    style: CustomTextStyle.bold10.copyWith(color: Theme.of(context).colorScheme.septimoText),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text.rich(
                              TextSpan(
                                text: "Vendido por - ",
                                style: CustomTextStyle.medium10.copyWith(color: Theme.of(context).colorScheme.septimoText),
                                children: [
                                  TextSpan(
                                    text: report.employee,
                                    style: CustomTextStyle.bold10.copyWith(color: Theme.of(context).colorScheme.septimoText),
                                  ),
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                text: "Pago - ",
                                style: CustomTextStyle.medium10.copyWith(color: Theme.of(context).colorScheme.septimoText),
                                children: [
                                  TextSpan(
                                    text: report.payMethod,
                                    style: CustomTextStyle.bold10.copyWith(color: Theme.of(context).colorScheme.septimoText),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "Monto",
                              style: CustomTextStyle.medium12.copyWith(color: Theme.of(context).colorScheme.septimoText),
                            ),
                            Text(
                              "\$${report.total}",
                              style: CustomTextStyle.semiBold14.copyWith(color: Theme.of(context).colorScheme.septimoText),
                            )
                          ],
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
        "No hay reportes de ventas registrados",
        textAlign: TextAlign.center,
        style: CustomTextStyle.bold32.copyWith(
          color: Theme.of(context).colorScheme.segundoText,
        ),
      ),
    );
  }
}
