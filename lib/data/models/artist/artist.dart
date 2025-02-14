import 'package:music_app/domain/entities/artist/artist.dart';

class ArtistModel {
  String? name;

  ArtistModel({
    required this.name,
  });

  ArtistModel.fromJson(Map<String, dynamic> data) {
    name = data['name'];
  }
}

extension ArtistmodelX on ArtistModel {
  ArtistEntity toEntity() {
    return ArtistEntity(
      name: name!,
    );
  }
}
