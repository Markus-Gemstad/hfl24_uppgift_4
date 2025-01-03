import 'package:objectbox/objectbox.dart';
import '../util/validators.dart';
import 'identifiable.dart';
import 'serializer.dart';

enum VehicleType { unknown, car, motorcycle, truck }

@Entity()
class Vehicle extends Identifiable {
  @override
  @Id()
  // ignore: overridden_fields
  int id; // Gör en override för att det ska funka med ObjectBox

  String regNr;
  int personId;

  // Lite magi för att enum ska funka med ObjecktBox
  @Transient()
  VehicleType type;

  int? get dbType {
    _ensureStableEnumValues();
    return type.index;
  }

  set dbType(int? value) {
    _ensureStableEnumValues();
    if (value == null) {
      type = VehicleType.unknown;
    } else {
      //type = VehicleType.values[value]; // throws a RangeError if not found
      //or if you want to handle unknown values gracefully:
      type = value >= 0 && value < VehicleType.values.length
          ? VehicleType.values[value]
          : VehicleType.unknown;
    }
  }

  Vehicle(this.regNr, this.personId,
      [this.type = VehicleType.unknown, this.id = -1]);

  static bool isValidVehicleTypeValue(String? value) {
    // Valid value = 1, 2, 3
    if (value != null && RegExp(r'^[1-3]{1}$').hasMatch(value)) {
      return true;
    }
    return false;
  }

  void _ensureStableEnumValues() {
    assert(VehicleType.car.index == 0);
    assert(VehicleType.motorcycle.index == 1);
    assert(VehicleType.truck.index == 2);
  }

  @override
  bool isValid() {
    return Validators.isValidRegNr(regNr) &&
        Validators.isValidId(personId.toString());
  }

  @override
  String toString() {
    return "Id: $id, RegNr: $regNr, Fordonstyp: $type, Ägare (ID): $personId";
  }
}

class VehicleSerializer extends Serializer<Vehicle> {
  @override
  Map<String, dynamic> toJson(Vehicle item) {
    return {
      'id': item.id,
      'regNr': item.regNr,
      'type': item.type.index,
      'personId': item.personId,
    };
  }

  @override
  Vehicle fromJson(Map<String, dynamic> json) {
    return Vehicle(
      json['regNr'] as String,
      json['personId'] as int,
      VehicleType.values[json['type']],
      json['id'] as int,
    );
  }
}
