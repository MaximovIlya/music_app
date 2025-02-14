import 'package:dartz/dartz.dart';

abstract class ArtistRepository {

  Future<Either> getArtists();
}