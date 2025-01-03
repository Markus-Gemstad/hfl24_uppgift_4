import 'dart:convert';
import 'package:http/http.dart';
import 'package:parkmycar_shared/parkmycar_shared.dart';
import 'package:test/test.dart';
import 'server_test.dart';

int newParkingSpaceId = -1;

parkingSpaceCreateTest() async {
  String streetAddress = 'Gatan 10';
  String postalCode = '534 55';
  String city = 'Orten';
  int pricePerHour = 30;
  ParkingSpace item =
      ParkingSpace(streetAddress, postalCode, city, pricePerHour);
  expect(item.isValid(), true);

  final response = await post(Uri.parse('$host/parkingspaces'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(ParkingSpaceSerializer().toJson(item)));

  expect(response.statusCode, 200);
  expect(response.body.isNotEmpty, true);

  final json = jsonDecode(response.body);
  expect(json != null, true);

  item = ParkingSpaceSerializer().fromJson(json);
  expect(item.id > 0, true);
  expect(item.streetAddress, streetAddress);
  expect(item.postalCode, postalCode);
  expect(item.city, city);
  expect(item.pricePerHour, pricePerHour);

  newParkingSpaceId = item.id;
}

parkingSpaceGetAllTest() async {
  final response = await get(Uri.parse('$host/parkingspaces'));
  expect(response.statusCode, 200);
  expect(response.body.isNotEmpty, true);

  final json = jsonDecode(response.body);
  expect(json != null, true);

  var list = (json as List)
      .map((item) => ParkingSpaceSerializer().fromJson(item))
      .toList();
  expect(list.isEmpty || list.isNotEmpty, true);
}

parkingSpaceGetByIdTest() async {
  final response = await get(
    Uri.parse('$host/parkingspaces/$newParkingSpaceId'),
    headers: {'Content-Type': 'application/json'},
  );

  expect(response.statusCode, 200);
  expect(response.body.isNotEmpty, true);

  final json = jsonDecode(response.body);
  expect(json != null, true);

  ParkingSpace item = ParkingSpaceSerializer().fromJson(json);
  expect(item.isValid(), true);
  expect(item.id, newParkingSpaceId);
}

parkingSpaceUpdateTest() async {
  String streetAddress = 'Nygatan 20';
  String postalCode = '666 66';
  String city = 'Nystan';
  int pricePerHour = 40;
  ParkingSpace item = ParkingSpace(
      streetAddress, postalCode, city, pricePerHour, newParkingSpaceId);
  expect(item.isValid(), true);

  final response = await put(Uri.parse('$host/parkingspaces'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(ParkingSpaceSerializer().toJson(item)));

  expect(response.statusCode, 200);
  expect(response.body.isNotEmpty, true);

  final json = jsonDecode(response.body);
  expect(json != null, true);

  item = ParkingSpaceSerializer().fromJson(json);
  expect(item.isValid(), true);
  expect(item.id, newParkingSpaceId);
  expect(item.streetAddress, streetAddress);
  expect(item.postalCode, postalCode);
  expect(item.city, city);
  expect(item.pricePerHour, pricePerHour);
}

parkingSpaceDeleteTest() async {
  final response = await delete(
    Uri.parse('$host/parkingspaces/$newParkingSpaceId'),
    headers: {'Content-Type': 'application/json'},
  );

  expect(response.statusCode, 200);
}
