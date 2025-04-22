import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shoppi_frontend/features/product/bloc/product_event.dart';
import 'package:shoppi_frontend/features/product/bloc/product_state.dart';
import 'package:shoppi_frontend/features/product/data/product_model.dart';
import 'package:shoppi_frontend/features/product/data/review_model.dart';
import 'package:shoppi_frontend/features/product/domain/product_repo.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductStateInitial()) {
    on<EventProductList>(_onEventProductList);
    on<EventProductDetail>(_onEventProductDetail);
    on<EventAddToCart>(_onEventAddToCart);
    on<EventAddReview>(_onEventAddReview);
  }

  FutureOr<void> _onEventProductList(
      EventProductList event, Emitter<ProductState> emit) async {
    try {
      Response response = await ProductRepository.instant.getAllProducts();
      if (response.statusCode == 200) {
        List<ProductModel> listProduct = List<ProductModel>.from(
            response.data['data'].map((x) => ProductModel.fromJson(x)));
        emit(StateProductList(
            success: true,
            message: response.data['message'],
            data: listProduct));
      } else {
        emit(StateProductList(
            success: false, message: response.data['message']));
      }
    } catch (e) {
      emit(StateProductList(success: false, message: e.toString()));
      rethrow;
    }
  }

  FutureOr<void> _onEventProductDetail(
      EventProductDetail event, Emitter<ProductState> emit) async {
    try {
      Response response =
          await ProductRepository.instant.productDetail(event.id);
      if (response.statusCode == 200) {
        ProductModel product = ProductModel.fromJson(response.data['product']);
        List<ReviewModel> listReview = List<ReviewModel>.from(
            response.data['reviews'].map((x) => ReviewModel.fromJson(x)));
        emit(StateProductDetail(
            success: true,
            message: response.data['message'],
            data: product,
            dataReview: listReview));
      } else {
        emit(StateProductDetail(
            success: false, message: response.data['message']));
      }
    } catch (e) {
      emit(StateProductDetail(success: false, message: e.toString()));
      rethrow;
    }
  }

  FutureOr<void> _onEventAddToCart(
      EventAddToCart event, Emitter<ProductState> emit) async {
    try {
      Response response = await ProductRepository.instant.addToCart(event.id);
      if (response.statusCode == 200) {
        emit(StateAddToCart(success: true, message: response.data['message']));
      } else {
        emit(StateAddToCart(success: false, message: response.data['message']));
      }
    } catch (e) {
      emit(StateAddToCart(success: false, message: e.toString()));
      rethrow;
    }
  }

  FutureOr<void> _onEventAddReview(
      EventAddReview event, Emitter<ProductState> emit) async {
    try {
      Response response = await ProductRepository.instant.addReview(event.id,
          reviewText: event.reviewText, rating: event.rating);
      if (response.statusCode == 200) {
        emit(StateAddReview(success: true, message: response.data['message']));
      } else {
        emit(StateAddReview(success: false, message: response.data['message']));
      }
    } catch (e) {
      emit(StateAddReview(success: false, message: e.toString()));
      rethrow;
    }
  }
}
