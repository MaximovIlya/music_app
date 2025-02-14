import 'package:music_app/core/usecase/usecase.dart';
import 'package:music_app/domain/repository/song/song.dart';
import 'package:music_app/service_locator.dart';

class IsFavoriteSongUseCase implements UseCase<bool, String> {
  @override
  Future<bool> call({String ? params}) async {
    return await sl<SongsRepository>().isFavoriteSong(params!);
  }
}
