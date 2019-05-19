import 'package:crypto_exchange/cryptocurrencyExchangeList/cryptocurrency_exchange.dart';
import 'package:crypto_exchange/cryptocurrency_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class CryptocurrencyExchangeBlock {

  Stream<List<Market>> get marketsStream => _marketsSubject.stream;
  bool get initialDataLoaded => _initialDataLoaded;

  CryptocurrencyExchangeBlock(
      { @required CryptocurrencyManager cryptocurrencyManager,
        @required cryptocurrencySymbol: String}):
        _cryptocurrencyManager = cryptocurrencyManager,
        _cryptocurrencySymbol = cryptocurrencySymbol {}

  Future<void> refresh() =>
    _cryptocurrencyManager.fetchCryptocurrencyExchange(
        _cryptocurrencySymbol,
        _resultCurrency
    ).then((cryptocurrencyExchange) {
      _initialDataLoaded = true;
      _marketsSubject.add(cryptocurrencyExchange.ticker.markets);
    }, onError: (error) {
      _initialDataLoaded = false;
    });

  ////////////////////////////
  // Private
  final _resultCurrency = 'usd';
  final CryptocurrencyManager _cryptocurrencyManager;
  final String _cryptocurrencySymbol;
  final _marketsSubject = PublishSubject<List<Market>>();
  bool _initialDataLoaded = false;
}
