import 'package:flutter/material.dart';
import 'package:song_app/model/song_list_model.dart';
import 'package:song_app/services/song_provider.dart';
import 'package:song_app/widget/song_item.dart';

// This class will show list of song
class SongList extends StatelessWidget {
  final List<Results> songList;
  final SongProvider playerProvider;

  const SongList({Key key, this.songList, this.playerProvider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        child: ListView.builder(
          itemCount: songList.length,
          physics: ScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return SongItemWidget(
                playerProvider: playerProvider, songModel: songList[index]);
          },
        ),
      ),
    );
  }
}
