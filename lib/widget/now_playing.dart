import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:song_app/services/song_provider.dart';

// This class will show Playing song view with controls like forward, stop and rewind
class NowPlayingWidget extends StatefulWidget {
  final String songTitle;
  final String songImageURL;

  NowPlayingWidget({Key key, this.songTitle, this.songImageURL})
      : super(key: key);

  @override
  _NowPlayingWidgetState createState() => _NowPlayingWidgetState();
}

class _NowPlayingWidgetState extends State<NowPlayingWidget>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<Offset> offset;
  double progressValue = 0.0;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    offset = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 1.0))
        .animate(controller);
    controller.reverse(from: 10.0);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    controller.dispose();
    offset = null;
  }

  @override
  Widget build(BuildContext context) {
    var playerProvider = Provider.of<SongProvider>(context, listen: false);
    return Container(
      child: SingleChildScrollView(
        child: SlideTransition(
          position: offset,
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(color: Color(0xFF5eb0e5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          height: 65.0,
                          width: 290.0,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color(0xFFFE1483), width: 3.0),
                              borderRadius: BorderRadius.circular(40.0)),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                getRewindView(playerProvider),
                                stopSong(playerProvider),
                                forwardSong(playerProvider)
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: getSlider(playerProvider),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // This widget create forward icon view and perform next song when click on Icon
  Widget forwardSong(SongProvider playerProvider) {
    return InkWell(
      child: Icon(MaterialCommunityIcons.fast_forward,
          size: 30.0, color: Color(0xFFFE1483)),
      onTap: () {
        int indexOfSong = playerProvider.allSongList.indexWhere(
            (song) => song.trackId == playerProvider.currentSong.trackId);
        int songListLength = playerProvider.allSongList.length;
        if (songListLength == indexOfSong) {
          return;
        }
        playerProvider.initAudioPlugin();
        playerProvider
            .setAudioPlayer(playerProvider.allSongList[indexOfSong + 1]);
        playerProvider.playSong();
      },
    );
  }

  // This widget create Stop icon view and perform Stop song when click on Icon
  Widget stopSong(SongProvider playerProvider) {
    return Container(
      width: 50.0,
      height: 50.0,
      decoration:
          BoxDecoration(color: Color(0xFFFE1483), shape: BoxShape.circle),
      child: IconButton(
        icon: Icon(
          Icons.stop,
          size: 30.0,
          color: Colors.white,
        ),
        onPressed: () {
          playerProvider.stopSong();
        },
      ),
    );
  }

  // This widget create rewind icon view and perform previous song when click on Icon
  Widget getRewindView(SongProvider playerProvider) {
    return InkWell(
        child: Icon(MaterialCommunityIcons.rewind,
            size: 30.0, color: Color(0xFFFE1483)),
        onTap: () {
          int indexOfSong = playerProvider.allSongList.indexWhere(
              (song) => song.trackId == playerProvider.currentSong.trackId);
          if (0 == indexOfSong) {
            return;
          }
          playerProvider.initAudioPlugin();
          playerProvider
              .setAudioPlayer(playerProvider.allSongList[indexOfSong - 1]);
          playerProvider.playSong();
        });
  }

  // This widget show slider view
  Widget getSlider(SongProvider playerProvider) {
    return Slider(
        value: progressValue,
        min: 0.0,
        activeColor: Color(0xFFFE1483),
        inactiveColor: Color(0xFFFE1483),
        max: playerProvider.currentSong.trackTimeMillis.toDouble(),
        onChanged: (double value) {});
  }
}
