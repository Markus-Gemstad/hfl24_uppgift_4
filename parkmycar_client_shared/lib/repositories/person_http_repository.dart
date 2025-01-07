import 'package:parkmycar_shared/parkmycar_shared.dart';
import 'http_repository.dart';

class PersonHttpRepository extends HttpRepository<Person> {
  PersonHttpRepository()
      : super(serializer: PersonSerializer(), resource: "persons");
}
