import 'package:favourite_places_app/models/place.dart';
import 'package:favourite_places_app/providers/list_of_places_provider.dart';
import 'package:favourite_places_app/screens/place_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesList extends ConsumerWidget {
  const PlacesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Place> listOfPlaces = ref.watch(listOfPlacesProvider);
    if (listOfPlaces.isNotEmpty) {
      return ListView.builder(
          itemCount: listOfPlaces.length,
          itemBuilder: (ctx, index) {
            return Dismissible(
              key: ValueKey(
                listOfPlaces[index].id,
              ),
              onDismissed: (direction) {
                ref
                    .read(listOfPlacesProvider.notifier)
                    .toggleAddedPlaceStatus(listOfPlaces[index]);
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Place was removed from your places.',
                    ),
                    duration: Duration(milliseconds: 200),
                  ),
                );
              },
              child: ListTile(
                leading: CircleAvatar(
                  radius: 26,
                  backgroundImage: FileImage(listOfPlaces[index].image),
                ),
                title: Text(
                  listOfPlaces[index].title,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
                subtitle: Text(
                  listOfPlaces[index].location.address,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PlaceScreen(
                      place: listOfPlaces[index],
                    ),
                  ),
                ),
              ),
            );
          });
    } else {
      return Center(
        child: Text(
          'Add some places!',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
      );
    }
  }
}
