
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:live_tv/blocs/tv_bloc.dart';
import 'package:live_tv/models/tv_response.dart';
import 'package:live_tv/networking/Response.dart';
import 'package:live_tv/view/player_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:toast/toast.dart';
import '../ad_Manager.dart';



class GetTvList extends  StatefulWidget {

  @override
  _GetTvListState createState() => _GetTvListState();

}

class _GetTvListState extends State<GetTvList> {
  TvBloc _tvBloc;
  BannerAd _bannerAd;
  String helper;
  String title;
 FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  void _loadBannerAd() {
    _bannerAd
      ..load()
      ..show(anchorType: AnchorType.bottom);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (message) async {

        setState(() {
          title = message['notification']['title'];
          helper = "You have received a notification  ";

        });
      },
      onResume:(message) async {
        setState(() {
          title = message['data']['title'];
          helper = "Received new notification";
        });
    }
    );
    _tvBloc = TvBloc();
    _bannerAd = BannerAd(
      adUnitId: AdManager.bannerAdUnitId,
      size: AdSize.banner,
    );
    _loadBannerAd();

  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text('BD Live TV',
            style: TextStyle(color: Colors.white, fontSize: 20)),
        backgroundColor: Color(0xFF339933),
      ),
      backgroundColor: Color(0xFF333333),
      body: RefreshIndicator(
        onRefresh: () => _tvBloc.fetchTv(),
        child: StreamBuilder<Response<tvResponse>>(
          stream: _tvBloc.tvDataStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data.status) {
                case Status.LOADING:
                  return Loading(loadingMessage: snapshot.data.message);
                  break;
                case Status.COMPLETED:
                  return ChannelList(channelList: snapshot.data.data);
                  break;
                case Status.ERROR:
                  return Error(
                    errorMessage: snapshot.data.message,
                    onRetryPressed: () => _tvBloc.fetchTv(),
                  );
                  break;
              }
            }
            return AnimatedContainer( duration: Duration(seconds: 8), curve: Curves.bounceInOut,);
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tvBloc.dispose();
    super.dispose();
    _bannerAd?.dispose();
  }
}
class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              '',
              style: TextStyle(color: Colors.white, fontSize: 25),

            ),
            decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assests/icon/icon.png'))),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.featured_play_list),
            title: Text('Categories'),
            onTap: () =>Toast.show("Coming soon", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () =>Toast.show("Coming soon", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM) ,
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Feedback'),
            onTap: _launchURL,
          ),
          ListTile(
            leading: Icon(Icons.textsms),
            title: Text('Privacy Policy'),
            onTap: _launchPolicyURL,
          ),
          ListTile(
            leading: Icon(Icons.rate_review),
            title: Text('Rate Us'),
            onTap: () =>Toast.show("Coming soon", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM),
          ),
        ],
      ),
    );
  }

}
_launchURL() async {
  const url = 'https://forms.gle/VC5EsESjCSgrTuoG6';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
_launchPolicyURL() async {
  const url = 'https://docs.google.com/document/d/1aCPqhZqObuVdsGFhW7_b3ZgBNAIgbpRbp-Z6vm2JV1M/edit?usp=sharing';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
class ChannelList extends StatelessWidget{
  final tvResponse channelList;
  const ChannelList({Key key, this.channelList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new OrientationBuilder(
      builder: (context,orientation){
        return GridView.count(
        crossAxisCount: orientation == Orientation.portrait ? 3 : 4,
        padding: EdgeInsets.all(8.0),
        childAspectRatio: 8.0 / 10.0,
        // TODO: Build a grid of cards (102)
        children: _buildGridCards(context,channelList),
        );
      },
    );
  }


}
List<Card> _buildGridCards(BuildContext context, tvResponse channelList) {
    if (channelList == null || channelList.records.isEmpty) {
      return const <Card>[];
    }

    final ThemeData theme = Theme.of(context);

    return channelList.records.map((channel) {
      return Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
           Navigator.of(context).push(MaterialPageRoute(
           builder: (context) =>
               VideoPlayer(channel.description,channel.name,channelList)));

          },
          // TODO: Adjust card heights (103)
          child: Column(
            // TODO: Center items on the card (103)
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AspectRatio(
                aspectRatio: 18 / 14,
                child: FadeInImage.assetNetwork(
                    placeholder : "assests/icon/icon.png",
                    image: channel.price,
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
                        channel.name,
                        maxLines: 1,
                        style: theme.textTheme.subtitle2,
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        (channel.categoryName),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )

      );
    }).toList();
  }
class Loading extends StatelessWidget {
  final String loadingMessage;

  const Loading({Key key, this.loadingMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            loadingMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          SizedBox(height: 24),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ],
      ),
    );
  }
}
class Error extends StatelessWidget {
  final String errorMessage;

  final Function onRetryPressed;

  const Error({Key key, this.errorMessage, this.onRetryPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          RaisedButton(
            color: Colors.white,
            child: Text('Retry', style: TextStyle(color: Colors.black)),
            onPressed: onRetryPressed,
          )
        ],
      ),
    );
  }
}