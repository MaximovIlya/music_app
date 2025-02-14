import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/common/bloc/favorite_button/favorite_button_state.dart';
import 'package:music_app/domain/usecases/song/add_ro_remove_favorite_song.dart';
import 'package:music_app/service_locator.dart';

class FavoriteButtonCubit extends Cubit<FavoriteButtonState> {
  FavoriteButtonCubit() : super(FavoriteButtonInitial());

  Future<void> favoriteButtonUpdated(String songId) async {
    var result =
        await sl<AddOrRemoveFavoriteSongUseCase>().call(params: songId);

    result.fold(
      (l) {},
      (isFavorite) {
        emit(
          FavoriteButtonUpdated(
            isFavorite: isFavorite
          ),
        );
      },
    );
  }
}
