import 'package:parkmycar_shared/parkmycar_shared.dart';

import 'db_repository.dart';

class ParkingSpaceDbRepository extends DbRepository<ParkingSpace> {
  // Singleton
  static final ParkingSpaceDbRepository _instance =
      ParkingSpaceDbRepository._internal();
  ParkingSpaceDbRepository._internal(); // Privat konstruktor förhindrar att fler objekt av klassen skapas
  static ParkingSpaceDbRepository get instance => _instance;
}
