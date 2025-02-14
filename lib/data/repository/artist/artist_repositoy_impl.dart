import 'package:dartz/dartz.dart';
import 'package:music_app/data/sources/artists/artist_firebase_service.dart';
import 'package:music_app/domain/repository/artist/artist.dart';
import 'package:music_app/service_locator.dart';

class ArtistRepositoryImpl extends ArtistRepository {
  @override
  Future<Either> getArtists() async{
    return await sl<ArtistFirebaseService>().getArtists();
  }
}
