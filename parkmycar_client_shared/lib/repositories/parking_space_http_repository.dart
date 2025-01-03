import 'package:parkmycar_shared/parkmycar_shared.dart';
import 'http_repository.dart';

class ParkingSpaceHttpRepository extends HttpRepository<ParkingSpace> {
  ParkingSpaceHttpRepository()
      : super(serializer: ParkingSpaceSerializer(), resource: "parkingspaces");
}
