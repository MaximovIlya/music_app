import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:music_app/data/models/artist/artist.dart';
import 'package:music_app/domain/entities/artist/artist.dart';

abstract class ArtistFirebaseService {
  Future<Either> getArtists();
}

class ArtistFirebaseServiceImpl extends ArtistFirebaseService {
  @override
  Future<Either> getArtists() async {
    try {
      List<ArtistEntity> artists = [];
      var data = await FirebaseFirestore.instance.collection('Artists').get();

      for (var element in data.docs) {
        var artistModel = ArtistModel.fromJson(element.data());
        artists.add(artistModel.toEntity());
      }

      return Right(artists);
    } catch (e) {
      return const Left('An error occurred, please try again');
    }
  }
}
