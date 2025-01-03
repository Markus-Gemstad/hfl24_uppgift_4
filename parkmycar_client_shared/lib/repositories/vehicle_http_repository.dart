import 'package:parkmycar_shared/parkmycar_shared.dart';
import 'http_repository.dart';

class VehicleHttpRepository extends HttpRepository<Vehicle> {
  VehicleHttpRepository()
      : super(serializer: VehicleSerializer(), resource: "vehicles");
}
