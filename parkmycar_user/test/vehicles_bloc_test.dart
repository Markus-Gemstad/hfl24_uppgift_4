import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:parkmycar_client_shared/parkmycar_http_repo.dart';
import 'package:parkmycar_shared/parkmycar_shared.dart';
import 'package:parkmycar_user/blocs/vehicles_bloc.dart';

class MockVehicleRepository extends Mock implements VehicleHttpRepository {}

class FakeVehicle extends Fake implements Vehicle {}

void main() {
  group('VehiclesBloc', () {
    late VehicleHttpRepository repository;

    setUp(() {
      repository = MockVehicleRepository();
    });

    setUpAll(() {
      registerFallbackValue(
        FakeVehicle(),
      );
    });

    group('create test', () {
      Vehicle newVehicle = Vehicle('ABC123 ', 1);

      blocTest<VehiclesBloc, VehiclesState>(
        'create item test',
        setUp: () {
          when(() => repository.create(any()))
              .thenAnswer((_) async => newVehicle);
          when(() => repository.getAll()).thenAnswer((_) async => [newVehicle]);
        },
        build: () => VehiclesBloc(repository: repository),
        seed: () => VehiclesLoaded(vehicles: []),
        act: (bloc) =>
            bloc.add(CreateVehicle(vehicle: newVehicle, personId: 1)),
        expect: () => [
          VehiclesLoaded(vehicles: [newVehicle])
        ],
        verify: (bloc) {
          verify(() => repository.create(newVehicle)).called(1);
        },
      );
    });
  });
}
