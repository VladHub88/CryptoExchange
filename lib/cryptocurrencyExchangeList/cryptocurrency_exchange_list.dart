import 'package:crypto_exchange/cryptocurrencyExchangeList/cryptocurrency_exchange.dart';
import 'package:crypto_exchange/cryptocurrencyExchangeList/cryptocurrency_exchange_block.dart';
import 'package:crypto_exchange/cryptocurrencyExchangeList/cryptocurrency_exchange_row.dart';
import 'package:crypto_exchange/cryptocurrencyList/cryptocurrency.dart';
import 'package:crypto_exchange/cryptocurrency_manager.dart';
import 'package:crypto_exchange/provider.dart';
import 'package:flutter/material.dart';

class CryptocurrencyExchangeList extends StatefulWidget {

  final Cryptocurrency cryptocurrency;
  final Image cryptocurrencyIcon;


  const CryptocurrencyExchangeList({Key key, this.cryptocurrency, this.cryptocurrencyIcon}) : super(key: key);

  @override
  _CryptocurrencyExchangeListState createState() => _CryptocurrencyExchangeListState();
}

class _CryptocurrencyExchangeListState extends State<CryptocurrencyExchangeList> with SingleTickerProviderStateMixin {

  AppBar get appBar => _appBar;

  @override
  void initState() {
    _bounceController = new AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _bounceAnimation = new CurvedAnimation(parent: _bounceController, curve: Curves.bounceOut);
  }

  @override
  Widget build(BuildContext context) {
    _appBar = AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Hero(
              tag: widget.cryptocurrency.id,
              child: CircleAvatar(
                  child: widget.cryptocurrencyIcon,
                  backgroundColor: Colors.transparent
              ),
            ),
            Text('${widget.cryptocurrency.name}')
          ],)
    );

    _cryptocurrencyExchangeBlock = CryptocurrencyExchangeBlock(
        cryptocurrencyManager: Provider.of(context).cryptocurrencyManager,
        cryptocurrencySymbol: widget.cryptocurrency.symbol
    );

    return Scaffold(
      appBar: appBar,
      body: _mainWidget(appBarHeight: appBar.preferredSize.height, animation: _bounceAnimation)
    );
  }

  ////////////////////////////
  // Private
  CryptocurrencyExchangeBlock _cryptocurrencyExchangeBlock;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  AppBar _appBar;
  AnimationController _bounceController;
  Animation<double> _bounceAnimation;

  Widget _mainWidget({@required appBarHeight: double, @required animation: Animation}) {
    Widget _list = StreamBuilder(stream: _cryptocurrencyExchangeBlock.marketsStream, builder: (context, snapshot) {
      List<Market> _cryptocurrencyMarkets = List<Market>();

      _cryptocurrencyMarkets = snapshot.data;
      final listViewKey = GlobalKey();

      // Handle error and no data
      if (_cryptocurrencyExchangeBlock.initialDataLoaded == true &&
          (snapshot.error != null || _cryptocurrencyMarkets == null ||
              _cryptocurrencyMarkets.length == 0)) {
        _bounceController.forward();
        return ListView(
          children: [
            SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: MediaQuery
                  .of(context)
                  .size
                  .height -  3 * appBarHeight,
                child: ScaleTransition(
                  scale: animation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/generic/nothingfound.png',
                      ),
                      Text(snapshot.error != null ? 'Error occured' : 'Nothing found')
                    ],
                  ),
                )
            )
          ],
        );
      }


      return ListView.builder(
          itemCount: _cryptocurrencyMarkets == null ? 0 : _cryptocurrencyMarkets.length,
          itemBuilder: (_, int idx) {
            return CryptocurrencyExchangeRow(
                market: _cryptocurrencyMarkets[idx],
            );
          });
    });

    var _refreshIndicator = RefreshIndicator(
      key: _refreshIndicatorKey,
      child: _list,
      onRefresh: _cryptocurrencyExchangeBlock.refresh,
    );

    // Dirty hack to show activity indicator on start
    Future.delayed(Duration(milliseconds: 200)).then((_) {
      _refreshIndicatorKey.currentState?.show();
    });
    return _refreshIndicator;
  }
}