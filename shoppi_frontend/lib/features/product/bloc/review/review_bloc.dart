import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppi_frontend/features/product/bloc/review/review_event.dart';
import 'package:shoppi_frontend/features/product/bloc/review/review_state.dart';
import 'package:shoppi_frontend/features/product/domain/review_repo.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  ReviewBloc() : super(ReviewStateInitial()) {
    on<EventCheckReviewable>(_onEventCheckReviewable);
    on<EventAddReview>(_onEventAddReview);
  }

  FutureOr<void> _onEventCheckReviewable(
      EventCheckReviewable event, Emitter<ReviewState> emit) async {
    try {
      Response response = await ReviewRepository.instant.checkReviewable(
        id: event.id,
      );
      if (response.statusCode == 201) {
        emit(
            StateCheckReviewable(success: true, result: response.data['data']));
      } else {
        emit(StateCheckReviewable(
            success: false, message: response.data['message']));
      }
    } catch (e) {
      emit(StateCheckReviewable(success: false, message: e.toString()));
      rethrow;
    }
  }

  FutureOr<void> _onEventAddReview(
      EventAddReview event, Emitter<ReviewState> emit) async {
    try {
      Response response = await ReviewRepository.instant
          .addReview(inputReviewModel: event.review);

      if (response.statusCode == 200 || response.statusCode == 201) {
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
