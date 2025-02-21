import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/src/repositories/sample_repository.dart';
import 'package:flutter_boilerplate/src/widgets/loading_indicator.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final SampleRepository sampleRepository;

  HomeBloc({required this.sampleRepository}) : super(HomeInitial()) {
    on<GetSuccessEvent>(getSuccessEvent);
    on<GetErrorEvent>(getErrorEvent);
    on<PostSuccessEvent>(postSuccessEvent);
    on<PostErrorEvent>(postErrorEvent);
  }

  Future<FutureOr<void>> getSuccessEvent(event, emit) async {
    LoadingIndicator.show();
    await sampleRepository.getSuccess();
    LoadingIndicator.close();
  }

  Future<FutureOr<void>> getErrorEvent(event, emit) async {
    LoadingIndicator.show();
    await sampleRepository.getError();
    LoadingIndicator.close();
  }

  Future<FutureOr<void>> postSuccessEvent(event, emit) async {
    LoadingIndicator.show();
    await sampleRepository.postSuccess();
    LoadingIndicator.close();
  }

  Future<FutureOr<void>> postErrorEvent(event, emit) async {
    LoadingIndicator.show();
    await sampleRepository.postError();
    LoadingIndicator.close();
  }
}
