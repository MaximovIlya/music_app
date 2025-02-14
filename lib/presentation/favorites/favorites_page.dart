import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/common/helpers/is_dark_mode.dart';
import 'package:music_app/common/widgets/appbar/app_bar.dart';
import 'package:music_app/common/widgets/favorite_button/favorite_button.dart';
import 'package:music_app/core/configs/constants/app_urls.dart';
import 'package:music_app/presentation/profile/bloc/favorite_songs_cubit.dart';
import 'package:music_app/presentation/profile/bloc/favorite_songs_state.dart';
import 'package:music_app/presentation/profile/pages/profile.dart';
import 'package:music_app/presentation/song_player/pages/song_player.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        hideBack: true,
        backgroundColor: context.isDarkMode ? Colors.black : Colors.white,
        title: const Text(
          'Favorite Songs',
        ),
        action: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const ProfilePage(),
              ),
            );
          },
          icon: const Icon(
            Icons.person,
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => FavoriteSongsCubit()..getFavoriteSongs(),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              BlocBuilder<FavoriteSongsCubit, FavoriteSongsState>(
                builder: (context, state) {
                  if (state is FavoriteSongsLoading) {
                    return const CircularProgressIndicator();
                  }
                  if (state is FavoriteSongsLoaded) {
                    return ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => SongPlayerPage(
                                  songEntity: state.favoriteSongs[index],
                                  songs: state.favoriteSongs,
                                ),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          '${AppURLs.coverFirestorage}${state.favoriteSongs[index].artist} - ${state.favoriteSongs[index].title}.jpg?${AppURLs.mediaAlt}',
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
                                        state.favoriteSongs[index].title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        state.favoriteSongs[index].artist,
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
                                    state.favoriteSongs[index].duration
                                        .toString()
                                        .replaceAll('.', ':'),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  FavoriteButton(
                                    songEntity: state.favoriteSongs[index],
                                    key: UniqueKey(),
                                    function: () {
                                      context
                                          .read<FavoriteSongsCubit>()
                                          .removeSong(index);
                                    },
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
                      itemCount: state.favoriteSongs.length,
                    );
                  }
      
                  if (state is FavoriteSongsFailure) {
                    return const Text(
                      'Please try again',
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
