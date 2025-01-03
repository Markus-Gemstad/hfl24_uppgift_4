part of 'parkings_bloc.dart';

sealed class ParkingsEvent {}

class LoadParkings extends ParkingsEvent {
  final int personId;
  LoadParkings({required this.personId});
}

class ReloadParkings extends ParkingsEvent {
  final int personId;
  ReloadParkings({required this.personId});
}
