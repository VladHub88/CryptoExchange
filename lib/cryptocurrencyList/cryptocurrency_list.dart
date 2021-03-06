import 'package:crypto_exchange/cryptocurrencyList/cryptocurrency.dart';
import 'package:crypto_exchange/cryptocurrencyList/cryptocurrency_block.dart';
import 'package:crypto_exchange/cryptocurrencyList/cryptocurrency_row.dart';
import 'package:crypto_exchange/cryptocurrency_manager.dart';
import 'package:crypto_exchange/cryptocurrencyList/cryptocurrency_serch_text_form.dart';
import 'package:crypto_exchange/provider.dart';
import 'package:flutter/material.dart';

class CryptocurrencyList extends StatefulWidget {
  @override
  _CryptocurrencyListState createState() => _CryptocurrencyListState();
}

class _CryptocurrencyListState extends State<CryptocurrencyList> {

  AppBar get appBar => _appBar;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  @override
  void didChangeDependencies() {
    if (_block == null) {
      _block = CryptocurrencyBlock(cryptocurrencyManager: Provider
          .of(context)
          .cryptocurrencyManager);
    }
  }

  @override
  Widget build(BuildContext context) {
    _appBar = AppBar(title: Text('Cryptocurrency List'));

    return Scaffold(
        appBar: _appBar,
        body: Center(
            child: Column(
              children: <Widget>[
                CryptocurrencySearchTextForm(onChanged: (searchString) {
                  _block.setSearchString(searchString);
                }),
                Expanded(
                  child: _mainWidget(
                      shouldReloadOnStart: !_block.initialDataLoaded,
                      appBarHeight: appBar.preferredSize.height
                  )
                ),
              ],
            )
        )
    );
  }

  ////////////////////////////
  // Private

  AppBar _appBar;
  CryptocurrencyBlock _block;
  List<Cryptocurrency> _filteredCryptocurrencyList = List<Cryptocurrency>();

  Widget _mainWidget({@required shouldReloadOnStart: bool, @required appBarHeight: double}) {
    Widget list = StreamBuilder(stream: _block.cryptocurrencyList, builder: (context, snapshot) {

      if (snapshot.error == null && snapshot.data != null) {
        _filteredCryptocurrencyList = snapshot.data;
      }

      return ListView.builder(
              itemCount: _filteredCryptocurrencyList.length,
              itemBuilder: (_, int idx) {
                return CryptocurrencyRow(
                    cryptocurrency: _filteredCryptocurrencyList[idx]
                );
              }
      );
    });

    var _refreshIndicator = RefreshIndicator(
      key: _refreshIndicatorKey,
      child: list,
      onRefresh: _block.refresh,
    );


    if (shouldReloadOnStart) {
      // Dirty hack to show activity indicator on start
      Future.delayed(Duration(milliseconds: 200)).then((_) {
        _refreshIndicatorKey.currentState?.show();
      });
    }

    return _refreshIndicator;
  }
}