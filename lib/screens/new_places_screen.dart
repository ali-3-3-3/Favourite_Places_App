import 'dart:io';

import 'package:favourite_places_app/models/place.dart';
import 'package:favourite_places_app/providers/list_of_places_provider.dart';
import 'package:favourite_places_app/widgets/image_input.dart';
import 'package:favourite_places_app/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewPlace extends ConsumerStatefulWidget {
  const NewPlace({super.key});

  @override
  ConsumerState<NewPlace> createState() {
    return _NewPlaceState();
  }
}

class _NewPlaceState extends ConsumerState<NewPlace> {
  final _titleController = TextEditingController();
  File? _selectedImage;
  PlaceLocation? _selectedLocation;

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
  }

  void _savePlace(Place place) async {
    final enteredTitle = _titleController.text;
    if (!context.mounted ||
        enteredTitle.isEmpty ||
        _selectedImage == null ||
        _selectedLocation == null) {
      return;
    }

    final wasAdded =
        ref.read(listOfPlacesProvider.notifier).toggleAddedPlaceStatus(place);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(await wasAdded
            ? 'Place was added to your list.'
            : 'Place was removed from your list.'),
      ),
    );

    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new place!'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              TextField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Name'),
                ),
                controller: _titleController,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ImageInput(
                onPickedImage: (image) {
                  setState(() {
                    _selectedImage = image;
                  });
                },
              ),
              const SizedBox(
                height: 10,
              ),
              LocationInput(
                onSelectLocation: (location) {
                  setState(() {
                    _selectedLocation = location;
                  });
                },
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_titleController.text.isEmpty) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Column(
                                children: [
                                  Text(
                                    'Please enter a title.',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                                  ),
                                ],
                              );
                            });
                      }
                      if (_selectedImage == null) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Column(
                                children: [
                                  Text(
                                    'Please take a picture.',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                                  ),
                                ],
                              );
                            });
                      } else {
                        _savePlace(
                          Place(
                            title: _titleController.text,
                            image: _selectedImage!,
                            location: _selectedLocation!,
                          ),
                        );
                      }
                    },
                    label: const Text('Add item'),
                    icon: const Icon(Icons.add),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
