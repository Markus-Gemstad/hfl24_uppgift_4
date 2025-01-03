import 'dart:io';
import 'package:parkmycar_client_shared/parkmycar_http_repo.dart';
import 'package:parkmycar_shared/parkmycar_shared.dart';
import '../screens/screen_util.dart';

void screenAddPerson() async {
  clearScreen();

  String name =
      readValidInputString("Ange namn (1-255 tecken):", Validators.isValidName);

  String personnr =
      readValidInputString("Ange e-postadress:", Validators.isValidEmail);

  try {
    Person? person =
        await PersonHttpRepository.instance.create(Person(name, personnr));
    stdout.writeln("\nPerson skapad med följande uppgifter:\n");
    stdout.writeln(person.toString());
  } catch (e) {
    stdout.writeln("\nGick inte att skapa ny person. Felmeddelande: $e\n");
  }

  stdout.write("\nTryck ENTER för att gå tillbaka");
  stdin.readLineSync();
}

void screenShowAllPersons() async {
  clearScreen();
  stdout.writeln("Följande personer finns lagrade:\n");

  try {
    List<Person> persons = await PersonHttpRepository.instance.getAll();
    persons.forEach(print);
  } catch (e) {
    stdout.writeln("\nGick inte att hämta personer. Felmeddelande: $e\n");
  }

  stdout.write("\nTryck ENTER för att gå tillbaka");
  stdin.readLineSync();
}

void screenUpdatePerson() async {
  clearScreen();

  String availablePersons = '';
  try {
    List<Person> allPersons = await PersonHttpRepository.instance.getAll();
    if (allPersons.isNotEmpty) {
      Iterable<int> ids = allPersons.map((e) => e.id);
      availablePersons = ' (IDn: ${ids.join(',')})';
    }
  } finally {
    // Do nothing, maybe adding will work anyway
  }

  int id = readValidInputInt(
      "Ange ID på person som ska ändras$availablePersons:",
      Validators.isValidId);

  try {
    await PersonHttpRepository.instance.getById(id);
  } catch (e) {
    stdout.writeln("\nFEL! Det finns ingen person med angivet ID.");
    stdout.write("\nTryck ENTER för att gå tillbaka");
    stdin.readLineSync();
    return;
  }

  String name = readValidInputString(
      "Ange ett nytt namn (1-255 tecken):", Validators.isValidName);

  String personnr = readValidInputString(
      "Ange en  ny e-postadress:", Validators.isValidEmail);

  try {
    Person? person =
        await PersonHttpRepository.instance.update(Person(name, personnr, id));
    stdout.writeln("\nPerson updaterad med följande uppgifter:\n");
    stdout.writeln(person.toString());
  } catch (e) {
    stdout.writeln("\nGick inte att uppdatera person. Felmeddelande: $e\n");
  }

  stdout.write("\nTryck ENTER för att gå tillbaka");
  stdin.readLineSync();
}

void screenDeletePerson() async {
  clearScreen();

  String availablePersons = '';
  try {
    List<Person> allPersons = await PersonHttpRepository.instance.getAll();
    if (allPersons.isNotEmpty) {
      Iterable<int> ids = allPersons.map((e) => e.id);
      availablePersons = ' (IDn: ${ids.join(',')})';
    }
  } finally {
    // Do nothing, maybe adding will work anyway
  }

  int id = readValidInputInt(
      "Ange ID på person som ska tas bort$availablePersons:",
      Validators.isValidId);

  try {
    await PersonHttpRepository.instance.delete(id);
    stdout.writeln("\nPerson med ID $id har tagits bort!");
  } catch (e) {
    stdout.writeln("\nFEL! Person med ID $id kunde inte tas bort! $e");
  }

  stdout.write("\nTryck ENTER för att gå tillbaka");
  stdin.readLineSync();
}
