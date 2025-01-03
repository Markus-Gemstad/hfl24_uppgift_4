import 'http_repository.dart';
import 'package:parkmycar_shared/parkmycar_shared.dart';

class ParkingHttpRepository extends HttpRepository<Parking> {
  ParkingHttpRepository()
      : super(serializer: ParkingSerializer(), resource: "parkings");
}
