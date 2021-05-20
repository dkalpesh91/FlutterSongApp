import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:song_app/model/song_list_model.dart';
import 'package:song_app/services/song_download_service.dart';

enum SongPlayerState { LOADING, STOPPED, PLAYING, PAUSED, COMPLETED }

class SongProvider with ChangeNotifier {
  AudioPlayer _audioPlayer;
  Results _songDetails;

  List<Results> _songList;
  List<Results> allSongList;

  int get totalRecords => _songList != null ? _songList.length : 0;

  Results get currentSong => _songDetails;

  getPlayerState() => _playerState;

  getAudioPlayer() => _audioPlayer;

  getCurrentSong() => _songDetails;

  SongPlayerState _playerState = SongPlayerState.STOPPED;
  StreamSubscription _positionSubscription;

  SongProvider() {
    _initStreams();
  }

  void _initStreams() {
    if (_songDetails == null) {
      if (_songList != null && _songList.length > 0) {
        _songDetails = _songList[0];
      }
    }
  }

  void resetStreams() {
    _initStreams();
  }

  void initAudioPlugin() {
    if (_playerState == SongPlayerState.STOPPED) {
      _audioPlayer = new AudioPlayer();
    } else {
      _audioPlayer = getAudioPlayer();
    }
  }

  setAudioPlayer(Results music) async {
    _songDetails = music;

    await initAudioPlayer();
    notifyListeners();
  }

  initAudioPlayer() async {
    updatePlayerState(SongPlayerState.LOADING);

    _positionSubscription =
        _audioPlayer.onAudioPositionChanged.listen((Duration p) {
      if (_playerState == SongPlayerState.LOADING && p.inMilliseconds > 0) {
        updatePlayerState(SongPlayerState.PLAYING);
      }

      notifyListeners();
    });

    _audioPlayer.onPlayerStateChanged.listen((AudioPlayerState state) async {
      if (state == AudioPlayerState.PLAYING) {
        updatePlayerState(SongPlayerState.PLAYING);
        notifyListeners();
      } else if (state == AudioPlayerState.STOPPED ||
          state == AudioPlayerState.COMPLETED) {
        updatePlayerState(SongPlayerState.STOPPED);
        notifyListeners();
      }
    });
  }

  playSong() async {
    await _audioPlayer.play(currentSong.previewUrl, stayAwake: true);
  }

  playNextSong() async {
    await _audioPlayer.play(currentSong.previewUrl, stayAwake: true);
  }

  playPreviousSong() async {
    await _audioPlayer.play(currentSong.previewUrl, stayAwake: true);
  }

  stopSong() async {
    if (_audioPlayer != null) {
      _positionSubscription?.cancel();
      updatePlayerState(SongPlayerState.STOPPED);
      await _audioPlayer.stop();
    }
    //await _audioPlayer.dispose();
  }

  bool isPlaying() {
    return getPlayerState() == SongPlayerState.PLAYING;
  }

  bool isLoading() {
    return getPlayerState() == SongPlayerState.LOADING;
  }

  bool isStopped() {
    return getPlayerState() == SongPlayerState.STOPPED;
  }

  fetchAllSongs({
    String searchQuery = "",
  }) async {
    stopSong();
    _songList = <Results>[];
    allSongList = <Results>[];
    String urlfor = "https://itunes.apple.com/search?term=" +
        searchQuery +
        "&entity=musicArtist" +
        "&entity=song";
    SongListModel model = await SongDownloadService.fetchAllSongs(urlfor);

    if (model != null && model.results.length > 0) {
      allSongList.addAll(model.results);
    }
    notifyListeners();
  }

  void updatePlayerState(SongPlayerState state) {
    _playerState = state;
    notifyListeners();
  }
}
