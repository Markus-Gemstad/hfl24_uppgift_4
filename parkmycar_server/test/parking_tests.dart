import 'dart:convert';
import 'package:http/http.dart';
import 'package:parkmycar_shared/parkmycar_shared.dart';
import 'package:test/test.dart';
import 'parking_space_tests.dart';
import 'person_tests.dart';
import 'server_test.dart';
import 'vehicle_tests.dart';

int newParkingId = -1;

parkingCreateTest() async {
  int personId = newPersonId;
  int vehicleId = newVehicleId;
  int parkingSpaceId = newParkingSpaceId;
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now().add(const Duration(hours: 1));
  Parking item =
      Parking(personId, vehicleId, parkingSpaceId, startTime, endTime, 99);
  expect(item.isValid(), true);

  final response = await post(Uri.parse('$host/parkings'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(ParkingSerializer().toJson(item)));

  expect(response.statusCode, 200);
  expect(response.body.isNotEmpty, true);

  final json = jsonDecode(response.body);
  expect(json != null, true);

  item = ParkingSerializer().fromJson(json);
  expect(item.id > 0, true);
  expect(item.personId, personId);
  expect(item.vehicleId, vehicleId);
  expect(item.parkingSpaceId, parkingSpaceId);
  expect(item.startTime, startTime);
  expect(item.endTime, endTime);

  newParkingId = item.id;
}

parkingGetAllTest() async {
  final response = await get(Uri.parse('$host/parkings'));
  expect(response.statusCode, 200);
  expect(response.body.isNotEmpty, true);

  final json = jsonDecode(response.body);
  expect(json != null, true);

  var list =
      (json as List).map((item) => ParkingSerializer().fromJson(item)).toList();
  expect(list.isEmpty || list.isNotEmpty, true);
}

parkingGetByIdTest() async {
  final response = await get(
    Uri.parse('$host/parkings/$newParkingId'),
    headers: {'Content-Type': 'application/json'},
  );

  expect(response.statusCode, 200);
  expect(response.body.isNotEmpty, true);

  final json = jsonDecode(response.body);
  expect(json != null, true);

  Parking item = ParkingSerializer().fromJson(json);
  expect(item.isValid(), true);
  expect(item.id, newParkingId);
}

parkingUpdateTest() async {
  int personId = newPersonId;
  int vehicleId = newVehicleId;
  int parkingSpaceId = newParkingSpaceId;
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now().add(const Duration(hours: 2));
  Parking item = Parking(
      personId, vehicleId, parkingSpaceId, startTime, endTime, newParkingId);
  expect(item.isValid(), true);

  final response = await put(Uri.parse('$host/parkings'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(ParkingSerializer().toJson(item)));

  expect(response.statusCode, 200);
  expect(response.body.isNotEmpty, true);

  final json = jsonDecode(response.body);
  expect(json != null, true);

  item = ParkingSerializer().fromJson(json);
  expect(item.isValid(), true);
  expect(item.id, newParkingId);
  expect(item.personId, personId);
  expect(item.vehicleId, vehicleId);
  expect(item.parkingSpaceId, parkingSpaceId);
  expect(item.startTime, startTime);
  expect(item.endTime, endTime);
}

parkingDeleteTest() async {
  final response = await delete(
    Uri.parse('$host/parkings/$newParkingId'),
    headers: {'Content-Type': 'application/json'},
  );

  expect(response.statusCode, 200);
}
