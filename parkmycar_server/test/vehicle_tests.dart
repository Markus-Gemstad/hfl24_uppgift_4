import 'dart:convert';
import 'package:http/http.dart';
import 'package:parkmycar_shared/parkmycar_shared.dart';
import 'package:test/test.dart';
import 'person_tests.dart';
import 'server_test.dart';

int newVehicleId = -1;

vehicleCreateTest() async {
  String regNr = 'ABC123';
  int personId = newPersonId;
  Vehicle item = Vehicle(regNr, personId, VehicleType.car);
  expect(item.isValid(), true);

  final response = await post(Uri.parse('$host/vehicles'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(VehicleSerializer().toJson(item)));

  expect(response.statusCode, 200);
  expect(response.body.isNotEmpty, true);

  final json = jsonDecode(response.body);
  expect(json != null, true);

  item = VehicleSerializer().fromJson(json);
  expect(item.id > 0, true);
  expect(item.regNr, regNr);
  expect(item.personId, personId);
  expect(item.type, VehicleType.car);

  newVehicleId = item.id;
}

vehicleGetAllTest() async {
  final response = await get(Uri.parse('$host/vehicles'));
  expect(response.statusCode, 200);
  expect(response.body.isNotEmpty, true);

  final json = jsonDecode(response.body);
  expect(json != null, true);

  var list =
      (json as List).map((item) => VehicleSerializer().fromJson(item)).toList();
  expect(list.isEmpty || list.isNotEmpty, true);
}

vehicleGetByIdTest() async {
  final response = await get(
    Uri.parse('$host/vehicles/$newVehicleId'),
    headers: {'Content-Type': 'application/json'},
  );

  expect(response.statusCode, 200);
  expect(response.body.isNotEmpty, true);

  final json = jsonDecode(response.body);
  expect(json != null, true);

  Vehicle item = VehicleSerializer().fromJson(json);
  expect(item.isValid(), true);
  expect(item.id, newVehicleId);
}

vehicleUpdateTest() async {
  String regNr = 'ABC123';
  int personId = newPersonId;
  Vehicle item = Vehicle(regNr, personId, VehicleType.car, newVehicleId);
  expect(item.isValid(), true);

  final response = await put(Uri.parse('$host/vehicles'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(VehicleSerializer().toJson(item)));

  expect(response.statusCode, 200);
  expect(response.body.isNotEmpty, true);

  final json = jsonDecode(response.body);
  expect(json != null, true);

  item = VehicleSerializer().fromJson(json);
  expect(item.isValid(), true);
  expect(item.id, newVehicleId);
  expect(item.regNr, regNr);
  expect(item.personId, personId);
  expect(item.type, VehicleType.car);
}

vehicleDeleteTest() async {
  final response = await delete(
    Uri.parse('$host/vehicles/$newVehicleId'),
    headers: {'Content-Type': 'application/json'},
  );

  expect(response.statusCode, 200);
}
