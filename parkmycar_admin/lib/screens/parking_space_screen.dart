import 'package:flutter/material.dart';
import 'package:parkmycar_admin/screens/parking_space_edit_dialog.dart';
import 'package:parkmycar_client_shared/parkmycar_http_repo.dart';
import 'package:parkmycar_shared/parkmycar_shared.dart';

import '../globals.dart';

class ParkingSpaceScreen extends StatefulWidget {
  const ParkingSpaceScreen({super.key});

  @override
  State<ParkingSpaceScreen> createState() => _ParkingSpaceScreenState();
}

class _ParkingSpaceScreenState extends State<ParkingSpaceScreen> {
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

  Future<void> updateParkingSpace(ParkingSpace parkingSpace) async {
    String successMessage;
    try {
      if (parkingSpace.id > 0) {
        await ParkingSpaceHttpRepository().update(parkingSpace);
        successMessage =
            'Parkeringsplatsen ${parkingSpace.streetAddress} har updaterats!';
      } else {
        await ParkingSpaceHttpRepository().create(parkingSpace);
        successMessage =
            'Parkeringsplatsen ${parkingSpace.streetAddress} har lagts till!';
      }

      // Update listview
      setState(() {
        allItems = getParkingSpaces(_searchController.text);
      });

      // Use to avoid use_build_context_synchronously warning
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(successMessage)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Det gick inte att spara parkeringsplatsen ${parkingSpace.streetAddress}!')));
    }
  }

  Future<bool?> showDeleteDialog(ParkingSpace item) {
    return showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Ta bort ${item.streetAddress}?'),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Avbryt')),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Ta bort')),
            ],
          );
        });
  }

  void removeParkingSpace(ParkingSpace item) async {
    try {
      await ParkingSpaceHttpRepository().delete(item.id);

      // Update listview
      setState(() {
        allItems = getParkingSpaces(_searchController.text);
      });

      // Use !mounted to avoid use_build_context_synchronously warning
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Parkeringsplatsen ${item.streetAddress} har tagits bort!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Det gick inte att ta bort fordonet ${item.streetAddress}!')));
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_queryListener);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
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
              child: Container(
                constraints: const BoxConstraints(maxWidth: 840),
                child: FutureBuilder<List<ParkingSpace>>(
                    future: allItems,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.isEmpty) {
                          return SizedBox.expand(
                            child: Text('Hittade inga parkeringsplatser.'),
                          );
                        }

                        return ListView.builder(
                            padding: const EdgeInsets.all(12.0),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              var item = snapshot.data![index];
                              return ListTile(
                                leading: Image.asset(
                                  'assets/parking_icon.png',
                                  width: 30.0,
                                ),
                                title: Text(item.streetAddress),
                                subtitle: Text(
                                    '${item.postalCode} ${item.city}\n'
                                    'Pris per timme: ${item.pricePerHour} kr'),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () async {
                                          ParkingSpace? updatedItem =
                                              await showDialog<ParkingSpace>(
                                            context: context,
                                            builder: (context) =>
                                                ParkingSpaceEditDialog(
                                                    parkingSpace: item),
                                          );

                                          debugPrint(updatedItem.toString());

                                          if (updatedItem != null &&
                                              updatedItem.isValid()) {
                                            await updateParkingSpace(
                                                updatedItem);
                                          }
                                        }),
                                    IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () async {
                                          var delete =
                                              await showDeleteDialog(item);
                                          if (delete == true) {
                                            removeParkingSpace(item);
                                          }
                                        }),
                                  ],
                                ),
                              );
                            });
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
            ),
          ],
        ),
        Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () async {
                ParkingSpace? newItem = await showDialog<ParkingSpace>(
                  context: context,
                  builder: (context) => ParkingSpaceEditDialog(),
                );

                debugPrint(newItem.toString());

                if (newItem != null && newItem.isValid()) {
                  await updateParkingSpace(newItem);
                }
              },
              child: Icon(Icons.add),
            )),
      ],
    );
  }
}
