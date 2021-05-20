import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:song_app/services/song_provider.dart';
import 'package:song_app/widget/song_dashboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SongProvider(),
          child: SongDashBoardWidget(),
        ),
      ],
      child: MaterialApp(
        title: '',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SongDashBoardWidget(),
      ),
    );
  }
}
