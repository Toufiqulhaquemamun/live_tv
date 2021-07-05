import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:live_tv/view/tv_categories_view.dart';
import 'package:live_tv/view/tv_list_view.dart';

import 'ad_Manager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<void> _initAdMob() {
    // TODO: Initialize AdMob SDK
    return FirebaseAdMob.instance.initialize(appId: AdManager.appId);
  }


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Live Tv',
      theme: ThemeData(

        primarySwatch: Colors.green,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:GetTvList() ,
    );
  }
}

