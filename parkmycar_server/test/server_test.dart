import 'dart:io';
import 'package:http/http.dart';
import 'package:test/test.dart';

import 'parking_space_tests.dart';
import 'parking_tests.dart';
import 'person_tests.dart';
import 'vehicle_tests.dart';

// /persons	            GET	    Hämta alla personer	getAll()
// /persons	            POST	  Skapa ny person	create()
// /persons/<id>	      GET	    Hämta specifik person	getById()
// /persons/<id>	      PUT	    Uppdatera specifik person	update()
// /persons/<id>	      DELETE	Ta bort specifik person	delete()
// /vehicles	          GET	    Hämta alla fordon	getAll()
// /vehicles	          POST	  Skapa nytt fordon	create()
// /vehicles/<id>	      GET	    Hämta specifikt fordon	getById()
// /vehicles/<id>	      PUT	    Uppdatera specifikt fordon	update()
// /vehicles/<id>	      DELETE	Ta bort specifikt fordon	delete()
// /parkingspaces	      GET	    Hämta alla parkeringsplatser	getAll()
// /parkingspaces	      POST	  Skapa ny parkeringsplats	create()
// /parkingspaces/<id>	GET	    Hämta specifik parkeringsplats	getById()
// /parkingspaces/<id>	PUT	    Uppdatera parkeringsplats	update()
// /parkingspaces/<id>	DELETE	Ta bort parkeringsplats	delete()
// /parkings	          GET	    Hämta alla parkeringar	getAll()
// /parkings	          POST	  Skapa ny parkering	create()
// /parkings/<id>	      GET	    Hämta specifik parkering	getById()
// /parkings/<id>	      PUT	    Uppdatera specifik parkering	update()
// /parkings/<id>	      DELETE	Ta bort specifik parkering	delete()

final port = '8080';
final host = 'http://localhost:$port';

void main() {
  late Process p;

  setUp(() async {
    p = await Process.start(
      'dart',
      ['run', 'bin/server.dart'],
      environment: {'PORT': port},
    );
    // Wait for server to start and print to stdout.
    await p.stdout.first;
  });

  tearDown(() => p.kill());

  test('Person create test', personCreateTest);
  test('Person get by id', personGetByIdTest);
  test('Person get all test', personGetAllTest);
  test('Person update', personUpdateTest);

  test('Vehicle create test', vehicleCreateTest);
  test('Vehicle get by id', vehicleGetByIdTest);
  test('Vehicle get all test', vehicleGetAllTest);
  test('Vehicle update', vehicleUpdateTest);

  test('ParkingSpace create test', parkingSpaceCreateTest);
  test('ParkingSpace get by id', parkingSpaceGetByIdTest);
  test('ParkingSpace get all test', parkingSpaceGetAllTest);
  test('ParkingSpace update', parkingSpaceUpdateTest);

  test('Parking create test', parkingCreateTest);
  test('Parking get by id', parkingGetByIdTest);
  test('Parking get all test', parkingGetAllTest);
  test('Parking update', parkingUpdateTest);

  // Don't delete before all other tests are done since the use id's from
  // previous tests
  test('Parking delete', parkingDeleteTest);
  test('ParkingSpace delete', parkingSpaceDeleteTest);
  test('Vehicle delete', vehicleDeleteTest);
  test('Person delete', personDeleteTest);

  test('404', () async {
    final response = await get(Uri.parse('$host/foobar'));
    expect(response.statusCode, 404);
  });
}
