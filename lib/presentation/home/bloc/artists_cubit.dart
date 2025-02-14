import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/domain/usecases/artist/get_artist.dart';
import 'package:music_app/presentation/home/bloc/artists_state.dart';
import 'package:music_app/service_locator.dart';

class ArtistsCubit extends Cubit<ArtistsState> {
  ArtistsCubit() : super(ArtistsLoading());

  Future<void> getArtists() async {
    var returnedArtists = await sl<GetArtistUseCase>().call();
    returnedArtists.fold(
      (l) {
        emit(
          ArtistsLoadFailure(),
        );
      },
      (data) {
        emit(
          ArtistsLoaded(artists: data),
        );
      },
    );
  }
}
