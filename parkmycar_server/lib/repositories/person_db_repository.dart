import 'package:parkmycar_shared/parkmycar_shared.dart';
import 'db_repository.dart';

class PersonDbRepository extends DbRepository<Person> {
  // Singleton
  static final PersonDbRepository _instance = PersonDbRepository._internal();
  PersonDbRepository._internal(); // Privat konstruktor förhindrar att fler objekt av klassen skapas
  static PersonDbRepository get instance => _instance;
}
