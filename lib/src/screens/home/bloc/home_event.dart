part of 'home_bloc.dart';

sealed class HomeEvent {}

final class GetSuccessEvent extends HomeEvent {}

final class GetErrorEvent extends HomeEvent {}

final class PostSuccessEvent extends HomeEvent {}

final class PostErrorEvent extends HomeEvent {}
