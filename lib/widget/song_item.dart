import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:song_app/model/song_list_model.dart';
import 'package:song_app/services/song_provider.dart';

// This class will show song item
class SongItemWidget extends StatefulWidget {
  final Results songModel;
  final SongProvider playerProvider;

  SongItemWidget({Key key, this.songModel, this.playerProvider})
      : super(key: key);

  @override
  _SongItemWidgetState createState() => _SongItemWidgetState();
}

class _SongItemWidgetState extends State<SongItemWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildSongRow();
  }

  // This widget will create song item view
  Widget _buildSongRow() {
    bool isSelectedSong = false;
    if (widget.playerProvider != null) {
      widget.playerProvider.resetStreams();
      if (widget.playerProvider.currentSong == null) {
        isSelectedSong = false;
      } else {
        isSelectedSong = this.widget.songModel.trackId ==
            widget.playerProvider.currentSong.trackId;
      }
    }

    return getSongItem(widget.playerProvider, isSelectedSong);
  }

  // This widget will create song item view
  Widget getSongItem(SongProvider playerProvider, bool isSelectedSong) {
    return Container(
      child: Column(
        children: [
          ListTile(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  this.widget.songModel.trackName,
                  style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF182545),
                  ),
                ),
                Text(this.widget.songModel.artistName, maxLines: 2),
                Text(
                  this.widget.songModel.collectionName,
                  maxLines: 2,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            leading: _image(this.widget.songModel.artworkUrl100),
            trailing: Wrap(
              spacing: -10.0, // gap between adjacent chips
              runSpacing: 0.0, // gap between lines
              children: <Widget>[
                _buildPlayStopIcon(
                  widget.playerProvider,
                  isSelectedSong,
                ),
              ],
            ),
            onTap: () {
              if (!widget.playerProvider.isStopped()) {
                widget.playerProvider.stopSong();
                if (!widget.playerProvider.isLoading()) {
                  widget.playerProvider.initAudioPlugin();
                  widget.playerProvider.setAudioPlayer(this.widget.songModel);

                  widget.playerProvider.playSong();
                }
              } else {
                if (!widget.playerProvider.isLoading()) {
                  widget.playerProvider.initAudioPlugin();
                  widget.playerProvider.setAudioPlayer(this.widget.songModel);

                  widget.playerProvider.playSong();
                }
              }
            },
          ),
          Divider(),
        ],
      ),
    );
  }

  // This widget will show artist image
  Widget _image(url, {size}) {
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: url != null ? Image.network(url) : Offstage(),
      ),
      height: size == null ? 55 : size,
      width: size == null ? 55 : size,
      decoration: BoxDecoration(
        color: Color(0xFFFFE5EC),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
    );
  }

  Widget _buildPlayStopIcon(SongProvider playerProvider, bool _isSelectedSong) {
    return IconButton(
      icon: _buildAudioButton(widget.playerProvider, _isSelectedSong),
      onPressed: () {},
    );
  }

  // This widget will show Spink view
  getSpinkKit() {
    return SpinKitWave(
      color: Color(0xFFFE1483),
      size: 20.0,
    );
  }

  // This widget will show Spink view
  Widget _buildAudioButton(SongProvider model, _isSelectedSong) {
    if (_isSelectedSong) {
      if (model != null && model.isLoading()) {
        return Center(
          child: getSpinkKit(),
        );
      }

      if (model != null && !model.isStopped()) {
        return Center(
          child: getSpinkKit(),
        );
      }

      if (model != null && model.isStopped()) {
        return Offstage();
      }
    } else {
      return Offstage();
    }

    return new Container();
  }
}
