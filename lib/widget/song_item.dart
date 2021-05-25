import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:song_app/model/song_list_model.dart';
import 'package:song_app/services/song_provider.dart';

class SongItemWidget extends StatefulWidget {
  final Results songModel;

  SongItemWidget({Key key, this.songModel}) : super(key: key);

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

  Widget _buildSongRow() {
    var playerProvider = Provider.of<SongProvider>(context, listen: false);
    playerProvider.resetStreams();
    bool isSelectedSong;
    if (playerProvider.currentSong == null) {
      isSelectedSong = false;
    } else {
      isSelectedSong =
          this.widget.songModel.trackId == playerProvider.currentSong.trackId;
    }

    return getSongItem(playerProvider, isSelectedSong);
  }

  Widget getSongItem(SongProvider playerProvider, bool isSelectedSong) {
    return ListTile(
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
            playerProvider,
            isSelectedSong,
          ),
        ],
      ),
      onTap: () {
        if (!playerProvider.isStopped()) {
          playerProvider.stopSong();
        } else {
          if (!playerProvider.isLoading()) {
            playerProvider.initAudioPlugin();
            playerProvider.setAudioPlayer(this.widget.songModel);

            playerProvider.playSong();
          }
        }
      },
    );
  }

  Widget _image(url, {size}) {
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Image.network(url),
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
      icon: _buildAudioButton(playerProvider, _isSelectedSong),
    );
  }

  getSpinkKit() {
    return SpinKitWave(
      color: Color(0xFF5eb0e5),
      size: 20.0,
    );
  }

  Widget _buildAudioButton(SongProvider model, _isSelectedSong) {
    if (_isSelectedSong) {
      if (model.isLoading()) {
        return Center(
          child: getSpinkKit(),
        );
      }

      if (!model.isStopped()) {
        return Center(
          child: getSpinkKit(),
        );
      }

      if (model.isStopped()) {
        return Offstage();
      }
    } else {
      return Offstage();
    }

    return new Container();
  }
}
