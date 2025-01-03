part of 'vehicles_bloc.dart';

sealed class VehiclesEvent {}

class LoadVehicles extends VehiclesEvent {
  final int personId;
  LoadVehicles({required this.personId});
}

class UpdateVehicle extends VehiclesEvent {
  final Vehicle vehicle;
  final int personId;
  UpdateVehicle({required this.vehicle, required this.personId});
}

class CreateVehicle extends VehiclesEvent {
  final Vehicle vehicle;
  final int personId;
  CreateVehicle({required this.vehicle, required this.personId});
}

class DeleteVehicle extends VehiclesEvent {
  final Vehicle vehicle;
  final int personId;
  DeleteVehicle({required this.vehicle, required this.personId});
}
