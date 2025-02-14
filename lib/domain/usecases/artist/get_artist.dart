import 'package:dartz/dartz.dart';
import 'package:music_app/core/usecase/usecase.dart';
import 'package:music_app/domain/repository/artist/artist.dart';
import 'package:music_app/service_locator.dart';

class GetArtistUseCase implements UseCase<Either, dynamic> {
  @override
  Future<Either> call({params}) async {
    return await sl<ArtistRepository>().getArtists();
  }
  
  
}
