import 'package:flutter/material.dart';
import 'package:live_tv/blocs/tv_category_bloc.dart';
import 'package:live_tv/models/tv_categories.dart';
import 'package:live_tv/networking/Response.dart';



class GetTvCategories extends StatefulWidget {
  @override
  _GetTvState createState() => _GetTvState();

}

class _GetTvState extends State<GetTvCategories>{
  TvCategoryBloc _categoryBloc;
    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _categoryBloc = TvCategoryBloc();
  }



    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          automaticallyImplyLeading: false,
          title: Text('Tv Categories',
              style: TextStyle(color: Colors.white, fontSize: 20)),
          backgroundColor: Color(0xFF339933),
        ),
        backgroundColor: Color(0xFF333333),
        body: RefreshIndicator(
          onRefresh: () => _categoryBloc.fetchCategories(),
          child: StreamBuilder<Response<tvCategories>>(
            stream: _categoryBloc.categoryListStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                switch (snapshot.data.status) {
                  case Status.LOADING:
                    return Loading(loadingMessage: snapshot.data.message);
                    break;
                  case Status.COMPLETED:
                    return CategoryList(categoryList: snapshot.data.data);
                    break;
                  case Status.ERROR:
                    return Error(
                      errorMessage: snapshot.data.message,
                      onRetryPressed: () => _categoryBloc.fetchCategories(),
                    );
                    break;
                }
              }
              return Container();
            },
          ),
        ),
      );
    }

@override
void dispose() {
  _categoryBloc.dispose();
  super.dispose();
}
}
class CategoryList extends StatelessWidget {
  final tvCategories categoryList;

  const CategoryList({Key key, this.categoryList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(0xFF202020),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 0.0,
                vertical: 1.0,
              ),
              child: InkWell(
                  onTap: () {
                   // Navigator.of(context).push(MaterialPageRoute(
                       // builder: (context) =>
                            //ShowChuckyJoke(categoryList.[index])));
                  },
                  child: SizedBox(
                    height: 65,
                    child: Container(
                      color: Color(0xFF333333),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                        child: Text(
                        categoryList.records.asMap().values.elementAt(index).name,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w100,
                              fontFamily: 'Roboto'),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  )));
        },
        itemCount: categoryList.records.length,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
      ),
    );
  }
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