import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:song_app/services/song_provider.dart';
import 'package:song_app/widget/now_playing.dart';
import 'package:song_app/widget/song_item.dart';

class SongDashBoardWidget extends StatefulWidget {
  @override
  _SongDashBoardWidgetState createState() => _SongDashBoardWidgetState();
}

class _SongDashBoardWidgetState extends State<SongDashBoardWidget> {
  final _searchQuery = new TextEditingController();
  Timer _debounce;
  bool isDataRequested = false;

  @override
  void dispose() {
    // TODO: implement dispose
    _searchQuery.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    var playerProvider = Provider.of<SongProvider>(context, listen: false);

    playerProvider.initAudioPlugin();
    playerProvider.resetStreams();
    playerProvider.fetchAllSongs(searchQuery: "Love you");

    _searchQuery.addListener(_onSearchChanged);
  }

  _onSearchChanged() {
    var songsBloc = Provider.of<SongProvider>(context, listen: false);

    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      isDataRequested = true;
      songsBloc.fetchAllSongs(
        searchQuery: _searchQuery.text,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color green = Color(0xFF5eb0e5);
    return Scaffold(
      backgroundColor: Color(0xFFf3f3f3),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Music App",
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Color(0xFFffffff)),
        ),
        elevation: 0,
        backgroundColor: green,
      ),
      body: Column(
        children: [_searchBar(), _songsList(), _nowPlaying()],
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.search),
          new Flexible(
            child: new TextField(
              cursorColor: Colors.black,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(5),
                hintText: 'Search Song',
              ),
              controller: _searchQuery,
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget _songsList() {
    return Consumer<SongProvider>(
      builder: (context, songModel, child) {
        if (songModel.allSongList.length > 0) {
          return new Expanded(
            child: Padding(
              child: ListView(
                children: <Widget>[
                  ListView.separated(
                      itemCount: songModel.allSongList.length,
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return SongItemWidget(
                            songModel: songModel.allSongList[index]);
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      })
                ],
              ),
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            ),
          );
        }

        if (isDataRequested) {
          isDataRequested = false;
          return getSpinkKit();
        }

        if (songModel.allSongList.length == 0) {
          return new Expanded(
            child: _noData(),
          );
        }

        return getSpinkKit();
      },
    );
  }

  getSpinkKit() {
    return SpinKitFadingCircle(
      color: Color(0xFF5eb0e5),
      size: 30.0,
    );
  }

  Widget _noData() {
    String noDataTxt = "";
    bool showTextMessage = false;

    noDataTxt = "No Music Found";
    showTextMessage = true;

    return Column(
      children: [
        new Expanded(
          child: Center(
            child: showTextMessage
                ? new Text(
                    noDataTxt,
                    textScaleFactor: 1,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : getSpinkKit(),
          ),
        ),
      ],
    );
  }

  Widget _nowPlaying() {
    var playerProvider = Provider.of<SongProvider>(context, listen: true);
    playerProvider.resetStreams();
    String trackName;
    String trackImage;
    if (playerProvider.currentSong == null) {
      trackName = "";
      trackImage = "";
    } else {
      trackName = playerProvider.currentSong.trackName;
      trackImage = playerProvider.currentSong.artworkUrl100;
    }
    return Visibility(
      visible: playerProvider.getPlayerState() == SongPlayerState.PLAYING,
      child: NowPlayingWidget(
        songTitle: trackName,
        songImageURL: trackImage,
      ),
    );
  }
}
