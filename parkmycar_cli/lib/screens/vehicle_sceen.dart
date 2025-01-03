import 'dart:io';
import 'package:parkmycar_client_shared/parkmycar_http_repo.dart';
import 'package:parkmycar_shared/parkmycar_shared.dart';
import '../screens/screen_util.dart';

void screenAddVehicle() async {
  clearScreen();

  String regNr = readValidInputString(
      "Ange registreringsnummer (NNNXXX):", Validators.isValidRegNr);

  int typeIndex = readValidInputInt(
      "Ange type (1 = bil, 2 = motorcykel, 3 = lastbil):",
      Vehicle.isValidVehicleTypeValue);
  VehicleType type = VehicleType.values[typeIndex];

  String availablePersons = '';
  try {
    List<Person> allPersons = await PersonHttpRepository.instance.getAll();
    if (allPersons.isNotEmpty) {
      Iterable<int> ids = allPersons.map((e) => e.id);
      availablePersons = ' (IDn: ${ids.join(',')})';
    }
  } catch (e) {
    stdout.writeln(
        "\nFEL! Det finns inga personer. Du måste först skapa en person.");
    stdout.write("\nTryck ENTER för att gå tillbaka");
    stdin.readLineSync();
    return;
  }

  int personId = readValidInputInt(
      "Ange ID på en person$availablePersons:", Validators.isValidId);

  try {
    await PersonHttpRepository.instance.getById(personId);
  } catch (e) {
    stdout.writeln("\nFEL! Det finns ingen person med angivet ID.");
    stdout.write("\nTryck ENTER för att gå tillbaka");
    stdin.readLineSync();
    return;
  }

  try {
    final repo = VehicleHttpRepository();
    Vehicle? vehicle = await repo.create(Vehicle(regNr, personId, type));
    stdout.writeln("\nFordon skapat med följande uppgifter:\n");
    stdout.writeln(vehicle.toString());
  } catch (e) {
    stdout.writeln("\nGick inte att skapa nytt fordon. Felmeddelande: $e\n");
  }

  stdout.write("\nTryck ENTER för att gå tillbaka");
  stdin.readLineSync();
}

void screenShowAllVehicles() async {
  clearScreen();
  stdout.writeln("Följande fordon finns lagrade:\n");

  final repo = VehicleHttpRepository();
  List<Vehicle> vehicles = await repo.getAll();
  vehicles.forEach(print);

  stdout.write("\nTryck ENTER för att gå tillbaka");
  stdin.readLineSync();
}

void screenUpdateVehicle() async {
  clearScreen();

  String availableVehicles = '';
  try {
    final repo = VehicleHttpRepository();
    List<Vehicle> allVehicles = await repo.getAll();
    if (allVehicles.isNotEmpty) {
      Iterable<int> ids = allVehicles.map((e) => e.id);
      availableVehicles = ' (IDn: ${ids.join(',')})';
    }
  } finally {
    // Do nothing, maybe adding will work anyway
  }

  int id = readValidInputInt(
      "Ange ID på fordon som ska ändras$availableVehicles:",
      Validators.isValidId);

  try {
    final repo = VehicleHttpRepository();
    await repo.getById(id);
  } catch (e) {
    stdout.write("\nFEL! Det finns inget fordon med angivet ID.");
    stdout.write("\nTryck ENTER för att gå tillbaka");
    stdin.readLineSync();
    return;
  }

  String regNr = readValidInputString(
      "Ange registreringsnummer (NNNXXX):", Validators.isValidRegNr);

  int typeIndex = readValidInputInt(
      "Ange type (1 = bil, 2 = motorcykel, 3 = lastbil):",
      Vehicle.isValidVehicleTypeValue);
  VehicleType type = VehicleType.values[typeIndex];

  String availablePersons = '';
  try {
    List<Person> allPersons = await PersonHttpRepository.instance.getAll();
    if (allPersons.isNotEmpty) {
      Iterable<int> ids = allPersons.map((e) => e.id);
      availablePersons = ' (IDn: ${ids.join(',')})';
    }
  } catch (e) {
    stdout.writeln(
        "\nFEL! Det finns inga personer. Du måste först skapa en person.");
    stdout.write("\nTryck ENTER för att gå tillbaka");
    stdin.readLineSync();
    return;
  }

  int personId = readValidInputInt(
      "Ange ID på en person$availablePersons:", Validators.isValidId);

  try {
    await PersonHttpRepository.instance.getById(personId);
  } catch (e) {
    stdout.write("\nFEL! Det finns ingen person med angivet ID.");
    stdout.write("\nTryck ENTER för att gå tillbaka");
    stdin.readLineSync();
    return;
  }

  try {
    final repo = VehicleHttpRepository();
    Vehicle? vehicle = await repo.update(Vehicle(regNr, personId, type, id));
    stdout.writeln("Fordonet updaterat med följande uppgifter:\n");
    stdout.writeln(vehicle.toString());
  } catch (e) {
    stdout.writeln("\nGick inte att uppdatera fordon. Felmeddelande: $e\n");
  }

  stdout.write("\nTryck ENTER för att gå tillbaka");
  stdin.readLineSync();
}

void screenDeleteVehicle() async {
  clearScreen();

  String availableVehicles = '';
  try {
    final repo = VehicleHttpRepository();
    List<Vehicle> allVehicles = await repo.getAll();
    if (allVehicles.isNotEmpty) {
      Iterable<int> ids = allVehicles.map((e) => e.id);
      availableVehicles = ' (IDn: ${ids.join(',')})';
    }
  } finally {
    // Do nothing, maybe adding will work anyway
  }

  int id = readValidInputInt(
      "Ange ID på fordon som ska tas bort$availableVehicles:",
      Validators.isValidId);

  try {
    final repo = VehicleHttpRepository();
    await repo.delete(id);
    stdout.writeln("\nFordon med ID $id har tagits bort!");
  } catch (e) {
    stdout.writeln("\nFEL! Fordon med ID $id kunde inte tas bort! $e");
  }

  stdout.write("\nTryck ENTER för att gå tillbaka");
  stdin.readLineSync();
}
