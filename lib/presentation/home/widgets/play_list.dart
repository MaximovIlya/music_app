import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/common/widgets/appbar/app_bar.dart';
import 'package:music_app/common/widgets/favorite_button/favorite_button.dart';
import 'package:music_app/core/configs/constants/app_urls.dart';
import 'package:music_app/domain/entities/artist/artist.dart';
import 'package:music_app/domain/entities/song/song.dart';
import 'package:music_app/presentation/aritst/pages/artist.dart';
import 'package:music_app/presentation/home/bloc/artists_cubit.dart';
import 'package:music_app/presentation/home/bloc/artists_state.dart';
import 'package:music_app/presentation/home/bloc/play_list_cubit.dart';
import 'package:music_app/presentation/home/bloc/play_list_state.dart';
import 'package:music_app/presentation/song_player/pages/song_player.dart';

class PlayList extends StatefulWidget {
  const PlayList({super.key});

  @override
  State<PlayList> createState() => _PlayListState();
}

class _PlayListState extends State<PlayList> {
  final TextEditingController _search = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<dynamic> filteredResults = [];
  List<SongEntity> unfilteredSongs = [];
  List<ArtistEntity> unfilteredArtists = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });

    _search.addListener(() {
      _searchMusicAndArtists();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: BasicAppBar(
          title: _searchField(context),
        ),
        body: SingleChildScrollView(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => PlayListCubit()..getPlayList(),
              ),
              BlocProvider(
                create: (_) => ArtistsCubit()..getArtists(),
              ),
            ],
            child: BlocBuilder<PlayListCubit, PlayListState>(
              builder: (context, playlistState) {
                if (playlistState is PlayListLoading) {
                  return Container(
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  );
                }
                if (playlistState is PlayListLoaded) {
                  unfilteredSongs = playlistState.songs;

                  return BlocBuilder<ArtistsCubit, ArtistsState>(
                    builder: (context, artistsState) {
                      if (artistsState is ArtistsLoading) {
                        return Container(
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(),
                        );
                      }
                      if (artistsState is ArtistsLoaded) {
                        unfilteredArtists = artistsState.artists;

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 40,
                            horizontal: 16,
                          ),
                          child: Column(
                            children: [
                              _resultsList(filteredResults),
                            ],
                          ),
                        );
                      }
                      return Container();
                    },
                  );
                }
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _resultsList(List<dynamic> results) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final result = results[index];
        if (result is SongEntity) {
          return _songItem(result);
        } else if (result is ArtistEntity) {
          return _artistItem(result);
        }
        return Container();
      },
      separatorBuilder: (context, index) => const SizedBox(
        height: 20,
      ),
      itemCount: results.length,
    );
  }

  Widget _songItem(SongEntity song) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => SongPlayerPage(
              songEntity: song,
              songs: filteredResults.whereType<SongEntity>().toList(),
            ),
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                height: 70,
                width: 70,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          '${AppURLs.coverFirestorage}${song.artist} - ${song.title}.jpg?${AppURLs.mediaAlt}'),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    song.artist,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Text(
                song.duration.toString().replaceAll('.', ':'),
              ),
              const SizedBox(
                width: 20,
              ),
              FavoriteButton(
                songEntity: song,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _artistItem(ArtistEntity artist) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => ArtistPage(
              url:
                  '${AppURLs.artistFirestorage}${artist.name}.jpg?${AppURLs.mediaAlt}',
              name: artist.name,
            ),
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                height: 70,
                width: 70,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      alignment: const Alignment(-0.1, 1),
                      image: NetworkImage(
                          '${AppURLs.artistFirestorage}${artist.name}.jpg?${AppURLs.mediaAlt}'),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                artist.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _searchField(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 50,
      child: TextField(
        controller: _search,
        focusNode: _focusNode,
        textAlign: TextAlign.start,
        onEditingComplete: () {
          FocusManager.instance.primaryFocus?.unfocus();
          _searchMusicAndArtists();
        },
        decoration: const InputDecoration(
          hintText: 'Search music or artists',
          filled: true,
          fillColor: Color.fromARGB(255, 46, 46, 46),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        ),
      ),
    );
  }

  void _searchMusicAndArtists() {
    final query = _search.text.toLowerCase();
    setState(() {
      filteredResults = [];
      if (query.isNotEmpty) {
        filteredResults.addAll(unfilteredSongs.where((song) {
          return song.title.toLowerCase().contains(query) || song.artist.toLowerCase().contains(query);
        }));
        filteredResults.addAll(unfilteredArtists.where((artist) {
          return artist.name.toLowerCase().contains(query);
        }));
      }
    });
  }
}
