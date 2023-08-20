import 'package:favourite_places_app/providers/list_of_places_provider.dart';
import 'package:favourite_places_app/screens/new_places_screen.dart';
import 'package:favourite_places_app/widgets/places_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UsersPlacesScreen extends ConsumerStatefulWidget {
  const UsersPlacesScreen({super.key});

  @override
  ConsumerState<UsersPlacesScreen> createState() {
    return _UsersPlacesScreenState();
  }
}

class _UsersPlacesScreenState extends ConsumerState<UsersPlacesScreen> {
  late Future<void> _placesFuture;

  @override
  void initState() {
    super.initState();
    _placesFuture = ref.read(listOfPlacesProvider.notifier).loadPlaces();
  }

  void _addPlace() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const NewPlace(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
            onPressed: _addPlace,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: FutureBuilder(
          future: _placesFuture,
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : const PlacesList(),
        ),
      ),
    );
  }
}
