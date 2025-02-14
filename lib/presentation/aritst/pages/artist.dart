import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/common/widgets/favorite_button/favorite_button.dart';
import 'package:music_app/core/configs/constants/app_urls.dart';
import 'package:music_app/domain/entities/song/song.dart';
import 'package:music_app/presentation/home/bloc/play_list_cubit.dart';
import 'package:music_app/presentation/home/bloc/play_list_state.dart';
import 'package:music_app/presentation/song_player/pages/song_player.dart';

class ArtistPage extends StatelessWidget {
  final String url;
  final String name;
  const ArtistPage({super.key, required this.url, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              _artistTopCard(name),
              Positioned(
                top: 40,
                left: 10,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    CupertinoIcons.arrow_left,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(left: 15, top: 15),
            child: Text(
              'Songs',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          BlocProvider(
            create: (_) => PlayListCubit()..getPlayList(),
            child: BlocBuilder<PlayListCubit, PlayListState>(
              builder: (context, state) {
                if (state is PlayListLoading) {
                  return Container(
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  );
                }
                if (state is PlayListLoaded) {
                  if (state.songs.isEmpty) {
                    return const Center(child: Text('No songs available'));
                  }
                  return _songs(state.songs.where((song) {
                    return song.artist.contains(name);
                  }).toList());
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _artistTopCard(String name) {
    return Container(
      height: 320,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
        image: DecorationImage(
          image: NetworkImage(url),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 50,
              color: Colors.white,
              fontFamily: 'LeagueSpartan',
            ),
          ),
        ],
      ),
    );
  }

  Widget _songs(List<SongEntity> songs) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => SongPlayerPage(
                    songEntity: songs[index],
                    songs: songs,
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
                                '${AppURLs.coverFirestorage}${songs[index].artist} - ${songs[index].title}.jpg?${AppURLs.mediaAlt}'),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          songs[index].title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          songs[index].artist,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      songs[index].duration.toString().replaceAll('.', ':'),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    FavoriteButton(
                      songEntity: songs[index],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(
          height: 20,
        ),
        itemCount: songs.length,
      ),
    );
  }
}
