import 'package:parkmycar_server/repositories/parking_db_repository.dart';
import 'package:parkmycar_server/repositories/parking_space_db_repository.dart';
import 'package:parkmycar_server/repositories/person_db_repository.dart';
import 'package:parkmycar_server/repositories/vehicle_db_repository.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:parkmycar_shared/parkmycar_shared.dart';
import 'package:parkmycar_shared/only_import_on_storage_device.dart';
import 'handlers/item_handler.dart';

class ServerConfig {
  // singleton constructor
  ServerConfig._privateConstructor() {
    initialize();
  }

  static final ServerConfig _instance = ServerConfig._privateConstructor();
  static ServerConfig get instance => _instance;

  late Store store;
  late Router router;

  initialize() {
    store = openStore();

    // Configure routes.
    router = Router();

    // Route	              Metod  	Beskrivning	Repository-metod
    // ---------------------------------------------------------
    // /persons	            GET	    Hämta alla personer	getAll()
    // /persons	            POST	  Skapa ny person	create()
    // /persons/<id>	      GET	    Hämta specifik person	getById()
    // /persons/<email>     GET     Hämta specifik person getByEmail()
    // /persons     	      PUT	    Uppdatera specifik person	update()
    // /persons/<id>	      DELETE	Ta bort specifik person	delete()
    // /vehicles	          GET	    Hämta alla fordon	getAll()
    // /vehicles	          POST	  Skapa nytt fordon	create()
    // /vehicles/<id>	      GET	    Hämta specifikt fordon	getById()
    // /vehicles            PUT	    Uppdatera specifikt fordon	update()
    // /vehicles/<id>	      DELETE	Ta bort specifikt fordon	delete()
    // /parkingspaces	      GET	    Hämta alla parkeringsplatser	getAll()
    // /parkingspaces	      POST	  Skapa ny parkeringsplats	create()
    // /parkingspaces/<id>	GET	    Hämta specifik parkeringsplats	getById()
    // /parkingspaces       PUT	    Uppdatera parkeringsplats	update()
    // /parkingspaces/<id>	DELETE	Ta bort parkeringsplats	delete()
    // /parkings	          GET	    Hämta alla parkeringar	getAll()
    // /parkings	          POST	  Skapa ny parkering	create()
    // /parkings/<id>	      GET	    Hämta specifik parkering	getById()
    // /parkings            PUT	    Uppdatera specifik parkering	update()
    // /parkings/<id>	      DELETE	Ta bort specifik parkering	delete()

    router.get(
        '/persons',
        (Request r) => getAllItemsHandler(
            r, PersonDbRepository.instance, PersonSerializer()));
    router.post(
        '/persons',
        (Request r) => createItemHandler(
            r, PersonDbRepository.instance, PersonSerializer()));
    router.get(
        '/persons/<id|[0-9]+>',
        (Request r, String id) => getItemHandler(
            r, id, PersonDbRepository.instance, PersonSerializer()));
    router.put(
        '/persons',
        (Request r) => updateItemHandler(
            r, PersonDbRepository.instance, PersonSerializer()));
    router.delete(
        '/persons/<id|[0-9]+>',
        (Request r, String id) => deleteItemHandler(
            r, id, PersonDbRepository.instance, PersonSerializer()));

    router.get(
        '/vehicles',
        (Request r) => getAllItemsHandler(
            r, VehicleDbRepository.instance, VehicleSerializer()));
    router.post(
        '/vehicles',
        (Request r) => createItemHandler(
            r, VehicleDbRepository.instance, VehicleSerializer()));
    router.get(
        '/vehicles/<id|[0-9]+>',
        (Request r, String id) => getItemHandler(
            r, id, VehicleDbRepository.instance, VehicleSerializer()));
    router.put(
        '/vehicles',
        (Request r) => updateItemHandler(
            r, VehicleDbRepository.instance, VehicleSerializer()));
    router.delete(
        '/vehicles/<id|[0-9]+>',
        (Request r, String id) => deleteItemHandler(
            r, id, VehicleDbRepository.instance, VehicleSerializer()));

    router.get(
        '/parkings',
        (Request r) => getAllItemsHandler(
            r, ParkingDbRepository.instance, ParkingSerializer()));
    router.post(
        '/parkings',
        (Request r) => createItemHandler(
            r, ParkingDbRepository.instance, ParkingSerializer()));
    router.get(
        '/parkings/<id|[0-9]+>',
        (Request r, String id) => getItemHandler(
            r, id, ParkingDbRepository.instance, ParkingSerializer()));
    router.put(
        '/parkings',
        (Request r) => updateItemHandler(
            r, ParkingDbRepository.instance, ParkingSerializer()));
    router.delete(
        '/parkings/<id|[0-9]+>',
        (Request r, String id) => deleteItemHandler(
            r, id, ParkingDbRepository.instance, ParkingSerializer()));

    router.get(
        '/parkingspaces',
        (Request r) => getAllItemsHandler(
            r, ParkingSpaceDbRepository.instance, ParkingSpaceSerializer()));
    router.post(
        '/parkingspaces',
        (Request r) => createItemHandler(
            r, ParkingSpaceDbRepository.instance, ParkingSpaceSerializer()));
    router.get(
        '/parkingspaces/<id|[0-9]+>',
        (Request r, String id) => getItemHandler(r, id,
            ParkingSpaceDbRepository.instance, ParkingSpaceSerializer()));
    router.put(
        '/parkingspaces',
        (Request r) => updateItemHandler(
            r, ParkingSpaceDbRepository.instance, ParkingSpaceSerializer()));
    router.delete(
        '/parkingspaces/<id|[0-9]+>',
        (Request r, String id) => deleteItemHandler(r, id,
            ParkingSpaceDbRepository.instance, ParkingSpaceSerializer()));
  }
}
