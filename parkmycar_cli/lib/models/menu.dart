import '../screens/parking_screen.dart';
import '../screens/parking_space_screen.dart';
import '../screens/person_sceen.dart';
import '../screens/vehicle_sceen.dart';

List<MenuItem> menu = [
  MenuItem('Personer', subMenu: [
    MenuItem('Skapa ny person', screenFunction: screenAddPerson),
    MenuItem('Visa alla personer', screenFunction: screenShowAllPersons),
    MenuItem('Uppdatera person', screenFunction: screenUpdatePerson),
    MenuItem('Ta bort person', screenFunction: screenDeletePerson),
    MenuItem('Gå tillbaka till huvudmenyn', doBack: true),
    MenuItem('Avsluta programmet', doExit: true),
  ]),
  MenuItem('Fordon', subMenu: [
    MenuItem('Skapa nytt fordon', screenFunction: screenAddVehicle),
    MenuItem('Visa alla fordon', screenFunction: screenShowAllVehicles),
    MenuItem('Uppdatera fordon', screenFunction: screenUpdateVehicle),
    MenuItem('Ta bort fordon', screenFunction: screenDeleteVehicle),
    MenuItem('Gå tillbaka till huvudmenyn', doBack: true),
    MenuItem('Avsluta programmet', doExit: true),
  ]),
  MenuItem('Parkeringsplatser', subMenu: [
    MenuItem('Skapa ny parkeringsplats', screenFunction: screenAddParkingSpace),
    MenuItem('Visa alla parkeringsplatser',
        screenFunction: screenShowAllParkingSpaces),
    MenuItem('Uppdatera parkeringsplats',
        screenFunction: screenUpdateParkingSpace),
    MenuItem('Ta bort parkeringsplats',
        screenFunction: screenDeleteParkingSpace),
    MenuItem('Gå tillbaka till huvudmenyn', doBack: true),
    MenuItem('Avsluta programmet', doExit: true),
  ]),
  MenuItem('Parkeringar', subMenu: [
    MenuItem('Skapa ny parkering', screenFunction: screenAddParking),
    MenuItem('Visa alla parkeringar', screenFunction: screenShowAllParkings),
    MenuItem('Uppdatera parkering', screenFunction: screenUpdateParking),
    MenuItem('Ta bort parkering', screenFunction: screenDeleteParking),
    MenuItem('Gå tillbaka till huvudmenyn', doBack: true),
    MenuItem('Avsluta programmet', doExit: true),
  ]),
  MenuItem('Avsluta', doExit: true),
];

class MenuItem {
  String name;
  Function? screenFunction;
  List<MenuItem>? subMenu;
  bool doExit;
  bool doBack;

  MenuItem(this.name,
      {this.screenFunction,
      this.subMenu,
      this.doExit = false,
      this.doBack = false});
}
