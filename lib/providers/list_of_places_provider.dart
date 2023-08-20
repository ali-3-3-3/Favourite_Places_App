import 'dart:io';

import 'package:favourite_places_app/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)');
    },
    version: 1,
  );
  return db;
}

class ListOfPlacesNotifier extends StateNotifier<List<Place>> {
  ListOfPlacesNotifier() : super(const []);

  Future<void> loadPlaces() async {
    final db = await _getDatabase();
    final data = await db.query('user_places');
    final places = data
        .map(
          (row) => Place(
            id: row['id'] as String,
            title: row['title'] as String,
            image: File(row['image'] as String),
            location: PlaceLocation(
              latitude: row['lat'] as double,
              longitude: row['lng'] as double,
              address: row['address'] as String,
            ),
          ),
        )
        .toList();
    state = places;
  }

  Future<bool> toggleAddedPlaceStatus(Place place) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final filename = path.basename(place.image.path);
    final copiedImage = await place.image.copy('${appDir.path}/$filename');

    final placeAdded = state.contains(place);
    if (placeAdded) {
      final db = await _getDatabase();

      db.delete(place.id);

      state = state.where((p) => p.id != place.id).toList();
      return false;
    } else {
      final newP = Place(
        title: place.title,
        image: copiedImage,
        location: place.location,
      );
      final db = await _getDatabase();

      db.insert('user_places', {
        'id': newP.id,
        'title': newP.title,
        'image': newP.image.path,
        'lat': newP.location.latitude,
        'lng': newP.location.longitude,
        'address': newP.location.address,
      });

      state = [newP, ...state];
      return true;
    }
  }
}

final listOfPlacesProvider =
    StateNotifierProvider<ListOfPlacesNotifier, List<Place>>(
  (ref) => ListOfPlacesNotifier(),
);
