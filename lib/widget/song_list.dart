import 'package:flutter/material.dart';
import 'package:song_app/model/song_list_model.dart';
import 'package:song_app/widget/song_item.dart';

class SongList extends StatelessWidget {
  final List<Results> songList;

  const SongList({Key key, this.songList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Expanded(
        child: Padding(
          child: ListView(
            children: <Widget>[
              ListView.separated(
                  itemCount: songList.length,
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return SongItemWidget(songModel: songList[index]);
                  },
                  separatorBuilder: (context, index) {
                    return Divider();
                  })
            ],
          ),
          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
        ),
      ),
    );
  }
}
