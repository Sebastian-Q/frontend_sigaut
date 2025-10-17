import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/model/product_model.dart';
import 'package:frontend/model/sale_model.dart';
import 'package:frontend/repository/sale_repository.dart';
import 'package:frontend/views/widgets/utils/functions.dart';

part 'sale_event.dart';
part 'sale_state.dart';

class SaleBloc extends Bloc<SaleEvent, SaleState> {
  SaleRepository saleRepository = SaleRepository();

  SaleBloc() : super(StartSale()) {
    on<AllSalesEvent>((event, emit) async {
      emit(StartLoadingState());
      List<SaleModel> listSales = await saleRepository.getSales(startDate: event.startDate, endDate: event.endDate);
      debugPrint("listSales: $listSales");
      emit(AllSalesState(listSales: listSales));
      emit(EndLoadingState());
    });

    on<SaveSaleEvent>((event, emit) async {
      emit(StartLoadingState(message: "Realizando Venta"));
      try {
        bool response = await saleRepository.createSale(saleModel: event.saleModel);
        if(response) {
          emit(SuccessfulState(message: "Venta realizada exitosamente"));
        } else {
          emit(MessageState(message: "Venta Fallida", typeMessage: AlertTypeMessage.error));
        }
      } catch (error) {
        emit(ErrorState(message: error.toString()));
      }
      emit(EndLoadingState());
    });

    on<AddProductSaleEvent>((event, emit) async {
      emit(StartLoadingState(message: "Agregando Producto"));
      try {
        ProductModel product = await saleRepository.addProduct(codeBar: event.codeBar);
        if(product.barCode != "") {
          product.accountSale = 1;
          emit(AddProductSaleState(productModel: product));
        } else {
          emit(MessageState(message: "Producto no encontrado", typeMessage: AlertTypeMessage.error));
        }
      } catch (error) {
        emit(MessageState(message: error.toString(), typeMessage: AlertTypeMessage.error));
      }
      emit(EndLoadingState());
    });

  }
}