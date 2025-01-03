import 'package:parkmycar_shared/parkmycar_shared.dart';
import 'db_repository.dart';

class VehicleDbRepository extends DbRepository<Vehicle> {
  // Singleton
  static final VehicleDbRepository _instance = VehicleDbRepository._internal();
  VehicleDbRepository._internal(); // Privat konstruktor förhindrar att fler objekt av klassen skapas
  static VehicleDbRepository get instance => _instance;
}
