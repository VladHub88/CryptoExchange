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

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    if (_block == null) {
      _block = CryptocurrencyBlock(cryptocurrencyManager: Provider
          .of(context)
          .cryptocurrencyManager);
    }

    return Scaffold(
        appBar: AppBar(title: Text('Currency Exchange List')),
        body: Center(
            child: Column(
              children: <Widget>[
                CryptocurrencySearchTextForm(onChanged: (searchString) {
                  _block.setSearchString(searchString);
                }),
                Expanded(
                  child: _mainWidget(shouldReloadOnStart: !_block.initialDataLoaded)
                ),
              ],
            )
        )
    );
  }

  ////////////////////////////
  // Private

  CryptocurrencyBlock _block;

  Widget _mainWidget({@required shouldReloadOnStart: bool}) {
    Widget list = StreamBuilder(stream: _block.cryptocurrencyList, builder: (context, snapshot) {
      List<Cryptocurrency> _filteredCryptocurrencyList = List<Cryptocurrency>();
      if (snapshot.error == null && snapshot.data != null) {
        _filteredCryptocurrencyList = snapshot.data;
      }

      return ListView.builder(
          itemCount: _filteredCryptocurrencyList.length,
          itemBuilder: (_, int idx) {
            return CryptocurrencyRow(
                cyptocurrency: _filteredCryptocurrencyList[idx]
            );
          });
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