import 'package:chewie/chewie.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:live_tv/blocs/tv_bloc.dart';
import 'package:live_tv/models/tv_response.dart';
import 'package:video_player/video_player.dart';
import '../ad_Manager.dart';
import 'hero_widget.dart';
import 'package:screen/screen.dart';



class VideoPlayer extends StatefulWidget{
  final String url;
  final String name;
  final tvResponse channelList;
  const VideoPlayer(this.url,this.name,this.channelList);
  @override
  State<StatefulWidget> createState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    // TODO: implement createState
    return _ShowPlayerState();
  }
}

class _ShowPlayerState extends State<VideoPlayer>{

  ChewieController _chewieController;
  BannerAd _bannerAd;
  TvBloc _tvBloc;

  void _loadBannerAd() {
    _bannerAd
      ..load()
      ..show(anchorType: AnchorType.bottom);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: AdManager.bannerAdUnitId,
      size: AdSize.banner,
    );
    _loadBannerAd();
    _tvBloc = TvBloc();
    _chewieController = ChewieController(
      videoPlayerController: VideoPlayerController.network(widget.url),
      aspectRatio: 3/2,
      autoInitialize: true,
      autoPlay: true,
      looping: true,
      errorBuilder: (context,errorMessage) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
        child: IconButton(
          icon: Icon(Icons.play_circle_outline,color: Colors.white
          ),
          iconSize: 100,
          onPressed: () {
           setState(() {
             _chewieController = ChewieController(
                 videoPlayerController: VideoPlayerController.network(widget.url),
             aspectRatio: 3/2,
             autoInitialize: true,
             autoPlay: true,
             );
           });
          }),
          ),
        );
      },
      allowedScreenSleep: false,
     fullScreenByDefault: false,
    );

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isLandscape = orientation == Orientation.portrait;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: Text(widget.name,
              style: TextStyle(color: Colors.white, fontSize: 20)),
          backgroundColor: Color(0xFF339933),
        ),
        primary: !isLandscape,
        resizeToAvoidBottomPadding:true,
        body: Wrap(
          direction: Axis.horizontal,
          children: [
            _buildHeroWidgetContent(),
            addSection,
            horiZontalList(context,widget.channelList),
          ],
        ),
      ),
    );
  }


  Widget addSection = Container(
    color: Colors.yellow,
    padding: const EdgeInsets.all(10),
    child: Row(
      children: [
        Expanded(
          /*1*/
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /*2*/
              AnimatedContainer(
                curve: Curves.fastOutSlowIn,
                duration: Duration(seconds: 2),
                padding: const EdgeInsets.only(bottom: 4,top: 4),
                child: Text(
                  'BD Live TV',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.red
                  ),
                ),
              ),
              Text(
                'Channel List',
                style: TextStyle(
                  color: Colors.indigo,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Chewie _buildHeroWidgetContent() {
    Screen.keepOn(true);
    return Chewie(
      controller: _chewieController,
    );
  }

  Widget horiZontalList(BuildContext context, tvResponse channelList) {
       final ThemeData theme = Theme.of(context);
        return AnimatedContainer(
            curve: Curves.bounceInOut,
            duration: Duration(seconds: 8),
          color: Color(0xFF202020),
           margin: EdgeInsets.symmetric(vertical: 20.0),
           height: 170.0,
           child: ListView.builder(
               scrollDirection: Axis.horizontal,
               itemCount: channelList.records.length,
               itemBuilder: (context,index){
                 return Container(
                   margin: const EdgeInsets.symmetric(horizontal: 2.0,vertical: 2.0),
                   width: 150.0,
                   color: Colors.white,
                   child: InkWell(
                     onTap: () {
                       print("tapped");
                       Navigator.of(context).push(MaterialPageRoute(
                           builder: (context) =>
                               VideoPlayer(channelList.records[index].description,channelList.records[index].name,channelList)));
                     },
                     child: Column(
                       // TODO: Center items on the card (103)
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: <Widget>[
                         AspectRatio(
                           aspectRatio: 18 / 14,
                           child: FadeInImage.assetNetwork(
                               placeholder : "assests/icon/icon.png",
                               image: channelList.records[index].price,
                           ),
                         ),
                         Expanded(
                           child: Padding(
                             padding: EdgeInsets.fromLTRB(8.0, 6.0, 8.0, 4.0),
                             child: Column(
                               // TODO: Align labels to the bottom and center (103)
                               crossAxisAlignment: CrossAxisAlignment.start,
                               // TODO: Change innermost Column (103)
                               children: <Widget>[
                                 // TODO: Handle overflowing labels (103)
                                 Text(
                                   channelList.records[index].name,
                                   maxLines: 1,
                                   style: theme.textTheme.subtitle2,
                                 ),
                                 SizedBox(height: 8.0),
                                 Text(
                                   (channelList.records[index].categoryName),
                                 ),
                               ],
                             ),
                           ),
                         ),
                       ],
                     ),
                   ),
                 );
               },
           )
       );
     }

  @override
  void dispose() {

    _chewieController.videoPlayerController.dispose();
    _chewieController.dispose();
    _bannerAd?.dispose();
    super.dispose();
    Screen.keepOn(false);
  }
}
