import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/model/category_model.dart';
import 'package:frontend/repository/category_repository.dart';
import 'package:frontend/views/widgets/utils/functions.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository categoryRepository = CategoryRepository();

  CategoryBloc() : super(StartCategory()) {

    ///LISTO
    on<AllCategoriesEvent>((event, emit) async {
      emit(StartLoadingState());
      //List<CategoryModel> listProducts = await productRepository.allProducts();
      emit(AllCategoriesState(listCategories: []));
      emit(EndLoadingState());
    });

    ///LISTO
    on<SaveCategoryEvent>((event, emit) async {
      emit(StartLoadingState(message: "Guardando Categoria"));
      try {
        bool response = true;//await productRepository.createProduct(productModel: event.productModel);
        if(response) {
          emit(SuccessfulState(message: "Categoria guardado exitosamente"));
        } else {
          emit(MessageState(message: "Guardado Fallido", typeMessage: AlertTypeMessage.error));
        }
      } catch (error) {
        emit(MessageState(message: error.toString(), typeMessage: AlertTypeMessage.error));
      }
      emit(EndLoadingState());
    });

    ///LISTO
    on<EditCategoryEvent>((event, emit) async {
      emit(StartLoadingState(message: "Actualizando categoria"));
      try {
        bool response = true; //await productRepository.updateProduct(productModel: event.productModel);
        if(response) {
          emit(SuccessfulState(message: event.messageSuccess ?? "Categoria editada exitosamente"));
        } else {
          emit(MessageState(message: "Modificación Fallida", typeMessage: AlertTypeMessage.error,));
        }
      } catch (error) {
        emit(MessageState(message: error.toString(), typeMessage: AlertTypeMessage.error,));
      }
      emit(EndLoadingState());
    });

    ///LISTO
    on<DeleteCategoryEvent>((event, emit) async {
      emit(StartLoadingState(message: "Eliminando categoria"));
      try {
        bool response = true;//await productRepository.deleteProduct(event.id);
        if(response) {
          emit(SuccessfulState(message: "Categoria eliminado exitosamente", exitWidget: false));
        } else {
          emit(MessageState(message: "Eliminación Fallida", typeMessage: AlertTypeMessage.error));
        }
      } catch (error) {
        emit(MessageState(message: error.toString(), typeMessage: AlertTypeMessage.error));
      }
      emit(EndLoadingState());
    });
  }
}