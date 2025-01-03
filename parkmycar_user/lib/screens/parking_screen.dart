import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkmycar_client_shared/parkmycar_http_repo.dart';
import 'package:parkmycar_shared/parkmycar_shared.dart';

import '../blocs/active_parking_bloc.dart';
import '../globals.dart';
import 'parking_ongoing_screen.dart';
import 'parking_start_dialog.dart';

class ParkingScreen extends StatefulWidget {
  const ParkingScreen({super.key});

  @override
  State<ParkingScreen> createState() => _ParkingScreenState();
}

class _ParkingScreenState extends State<ParkingScreen> {
  late TextEditingController _searchController;
  late Future<List<ParkingSpace>> allItems;

  @override
  void initState() {
    super.initState();

    allItems = getParkingSpaces();

    _searchController = TextEditingController();
    _searchController.addListener(_queryListener);
  }

  void _queryListener() {
    _search(_searchController.text);
  }

  Future<List<ParkingSpace>> getParkingSpaces([String? query]) async {
    var items = await ParkingSpaceHttpRepository()
        .getAll((a, b) => a.streetAddress.compareTo(b.streetAddress));
    if (query != null) {
      items = items
          .where((e) =>
              e.streetAddress.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    // Added delay to demonstrate loading animation
    return Future.delayed(
        Duration(milliseconds: delayLoadInMilliseconds), () => items);
  }

  void _search(String query) {
    setState(() {
      allItems = getParkingSpaces(query);
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_queryListener);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 2.0; // Make the animations go slower
    final ActiveParkingState activeParkingState =
        context.watch<ActiveParkingBloc>().state;

    return switch (activeParkingState.status) {
      ParkingStatus.active || ParkingStatus.starting => ParkingOngoingScreen(
          onEndParking: () {},
        ),
      _ => buildThisPage(context),
    };
  }

  Widget buildThisPage(BuildContext context) {
    return BlocListener(
      bloc: BlocProvider.of<ActiveParkingBloc>(context),
      listener: (context, ActiveParkingState state) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        switch (state.status) {
          case ParkingStatus.active:
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('En parkering har startats!')));
          case ParkingStatus.nonActive:
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('En parkering har avslutats!')));
          case ParkingStatus.errorStarting:
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Det gick inte att starta en parkering!')));
          case ParkingStatus.errorEnding:
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Det gick inte att avsluta en parkering!')));
          default: // Do nothing
        }
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SearchBar(
              leading: const Icon(Icons.search),
              // trailing: <Widget>[ // Use for clearing search
              //   const Icon(Icons.close),
              //   SizedBox(
              //     width: 6.0,
              //   ),
              // ],
              hintText: 'Sök gata...',
              controller: _searchController,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ParkingSpace>>(
                future: allItems,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return SizedBox.expand(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text('Finns inga parkeringsplatser.'),
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        setState(() {
                          allItems = getParkingSpaces();
                        });
                      },
                      child: ListView.builder(
                          padding: const EdgeInsets.all(12.0),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            var parkingSpace = snapshot.data![index];
                            return ListTile(
                              onTap: () async {
                                // Use push instead of showDialog to only to
                                // make hero animation work.
                                Parking? parking = await Navigator.of(context)
                                    .push<Parking>(MaterialPageRoute(
                                        builder: (context) =>
                                            ParkingStartDialog(parkingSpace)));

                                debugPrint(parking.toString());
                                if (parking != null &&
                                    parking.isValid() &&
                                    context.mounted) {
                                  context
                                      .read<ActiveParkingBloc>()
                                      .add(ActiveParkingStart(parking));
                                }
                              },
                              leading: Hero(
                                  tag: 'parkingicon${parkingSpace.id}',
                                  transitionOnUserGestures: true,
                                  child: Image.asset(
                                    'assets/parking_icon.png',
                                    width: 30.0,
                                  )),
                              title: Text(parkingSpace.streetAddress),
                              subtitle: Text(
                                  '${parkingSpace.postalCode} ${parkingSpace.city}\n'
                                  'Pris per timme: ${parkingSpace.pricePerHour} kr'),
                            );
                          }),
                    );
                  }

                  if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  return Center(child: CircularProgressIndicator());
                }),
          ),
        ],
      ),
    );
  }
}
