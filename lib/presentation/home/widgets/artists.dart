import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/core/configs/constants/app_urls.dart';
import 'package:music_app/domain/entities/artist/artist.dart';
import 'package:music_app/presentation/aritst/pages/artist.dart';
import 'package:music_app/presentation/home/bloc/artists_cubit.dart';
import 'package:music_app/presentation/home/bloc/artists_state.dart';

class Artists extends StatelessWidget {
  const Artists({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ArtistsCubit()..getArtists(),
      child: SizedBox(
        height: 200,
        child: BlocBuilder<ArtistsCubit, ArtistsState>(
          builder: (context, state) {
            if (state is ArtistsLoading) {
              return Container(
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator());
            }

            if (state is ArtistsLoaded) {
              return _artists(
                state.artists,
              );
            }

            return Container();
          },
        ),
      ),
    );
  }

  Widget _artists(List<ArtistEntity> artists) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => ArtistPage(
                  url:
                      '${AppURLs.artistFirestorage}${artists[index].name}.jpg?${AppURLs.mediaAlt}',
                  name: artists[index].name,
                ),
              ),
            );
          },
          child: SizedBox(
            width: 160,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        alignment: const Alignment(-0.1, 1),
                        image: NetworkImage(
                            '${AppURLs.artistFirestorage}${artists[index].name}.jpg?${AppURLs.mediaAlt}'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  artists[index].name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(
        width: 14,
      ),
      itemCount: artists.length,
    );
  }
}
