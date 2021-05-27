// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:song_app/model/song_list_model.dart';
import 'package:song_app/widget/song_list.dart';

void main() {
  testWidgets('Song App test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      title: 'Music App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: SongList(
          songList: [
            Results.fromJson({
              "wrapperType": "track",
              "kind": "song",
              "artistId": 1168822104,
              "collectionId": 1266332358,
              "trackId": 1266332562,
              "artistName": "YoungBoy Never Broke Again",
              "collectionName": "AI YoungBoy",
              "trackName": "GG",
              "collectionCensoredName": "AI YoungBoy",
              "trackCensoredName": "GG",
              "artistViewUrl":
                  "https://music.apple.com/us/artist/youngboy-never-broke-again/1168822104?uo=4",
              "collectionViewUrl":
                  "https://music.apple.com/us/album/gg/1266332358?i=1266332562&uo=4",
              "trackViewUrl":
                  "https://music.apple.com/us/album/gg/1266332358?i=1266332562&uo=4",
              "previewUrl":
                  "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview128/v4/ab/fe/55/abfe554f-1dbe-fb4f-6684-588624199c5f/mzaf_6512458335733056516.plus.aac.p.m4a",
              "artworkUrl30":
                  "https://is5-ssl.mzstatic.com/image/thumb/Music128/v4/61/52/7d/61527d1e-600f-c7e4-b741-7b2f50e279f8/source/30x30bb.jpg",
              "artworkUrl60":
                  "https://is5-ssl.mzstatic.com/image/thumb/Music128/v4/61/52/7d/61527d1e-600f-c7e4-b741-7b2f50e279f8/source/60x60bb.jpg",
              "artworkUrl100": null,
              "collectionPrice": 9.99,
              "trackPrice": 1.29,
              "releaseDate": "2017-08-04T12:00:00Z",
              "collectionExplicitness": "explicit",
              "trackExplicitness": "explicit",
              "discCount": 1,
              "discNumber": 1,
              "trackCount": 15,
              "trackNumber": 14,
              "trackTimeMillis": 124564,
              "country": "USA",
              "currency": "USD",
              "primaryGenreName": "Hip-Hop/Rap",
              "contentAdvisoryRating": "Explicit",
              "isStreamable": true
            })
          ],
        ),
      ),
    ));

    // Verify that our counter starts at 0.
    expect(find.text('YoungBoy Never Broke Again'), findsOneWidget);
    expect(find.text('AI YoungBoy'), findsOneWidget);

    // Verify that our counter has incremented.
    expect(find.text('Music App'), findsNothing);
  });
}
