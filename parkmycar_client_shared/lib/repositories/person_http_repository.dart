import 'package:parkmycar_shared/parkmycar_shared.dart';
import 'http_repository.dart';

class PersonHttpRepository extends HttpRepository<Person> {
  // Singleton
  static final PersonHttpRepository _instance =
      PersonHttpRepository._internal();
  static PersonHttpRepository get instance => _instance;
  PersonHttpRepository._internal()
      : super(serializer: PersonSerializer(), resource: "persons");
}
