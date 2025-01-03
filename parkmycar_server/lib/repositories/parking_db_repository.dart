import 'package:parkmycar_shared/parkmycar_shared.dart';

import 'db_repository.dart';

class ParkingDbRepository extends DbRepository<Parking> {
  // Singleton
  static final ParkingDbRepository _instance = ParkingDbRepository._internal();
  ParkingDbRepository._internal(); // Privat konstruktor förhindrar att fler objekt av klassen skapas
  static ParkingDbRepository get instance => _instance;
}
