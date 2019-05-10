import 'package:crypto_exchange/cryptocurrencyExchangeList/cryptocurrency_exchange.dart';
import 'package:crypto_exchange/cryptocurrencyExchangeList/cryptocurrency_exchange_block.dart';
import 'package:crypto_exchange/cryptocurrencyExchangeList/cryptocurrency_exchange_row.dart';
import 'package:crypto_exchange/cryptocurrencyList/cryptocurrency.dart';
import 'package:crypto_exchange/cryptocurrency_manager.dart';
import 'package:crypto_exchange/provider.dart';
import 'package:flutter/material.dart';

class CryptocurrencyExchangeList extends StatefulWidget {

  final Cryptocurrency cryptocurrency;

  const CryptocurrencyExchangeList({Key key, this.cryptocurrency}) : super(key: key);

  @override
  _CryptocurrencyExchangeListState createState() => _CryptocurrencyExchangeListState();
}

class _CryptocurrencyExchangeListState extends State<CryptocurrencyExchangeList> {

  AppBar get appBar => _appBar;

  @override
  Widget build(BuildContext context) {
    _appBar = AppBar(
      title: Text('${widget.cryptocurrency.name}'),
    );

    _cryptocurrencyExchangeBlock = CryptocurrencyExchangeBlock(
        cryptocurrencyManager: Provider.of(context).cryptocurrencyManager,
        cryptocurrencySymbol: widget.cryptocurrency.symbol
    );

    return Scaffold(
      appBar: appBar,
      body: _mainWidget(appBarHeight: appBar.preferredSize.height)
    );
  }

  ////////////////////////////
  // Private
  CryptocurrencyExchangeBlock _cryptocurrencyExchangeBlock;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  AppBar _appBar;

  Widget _mainWidget({@required appBarHeight: double}) {
    Widget _list = StreamBuilder(stream: _cryptocurrencyExchangeBlock.marketsStream, builder: (context, snapshot) {
      List<Market> _cryptocurrencyMarkets = List<Market>();
      _cryptocurrencyMarkets = snapshot.data;
      final listViewKey = GlobalKey();

      // Handle error and no data
      if (_cryptocurrencyExchangeBlock.initialDataLoaded == true &&
          (snapshot.error != null || _cryptocurrencyMarkets == null ||
              _cryptocurrencyMarkets.length == 0)) {
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
              child: Center(child: Text(snapshot.error != null
                  ? 'Error occured  (╯°□°）╯︵ ┻━┻ '
                  : 'No data  (╯°□°）╯︵ ┻━┻ ')
              ),
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