import 'dart:async';
import 'package:crypto_exchange/cryptocurrencyList/cryptocurrency.dart';
import 'package:crypto_exchange/cryptocurrency_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class CryptocurrencyBlock {
  Stream<List<Cryptocurrency>> get cryptocurrencyList =>
      _cryptocurrencyListSubject.stream;

  String get searchString => _searchString;

  bool get initialDataLoaded => _initialDataLoaded;

  CryptocurrencyBlock({@required CryptocurrencyManager cryptocurrencyManager})
      : _cryptocurrencyManager = cryptocurrencyManager {}

  void setSearchString(String searchString) {
    this._searchString = searchString;
    _cryptocurrencyListSubject.add(_filterCryptocurrencyList(
        _cryptocurrencyList,
        searchString: _searchString));
  }

  Future<void> refresh() =>
      _cryptocurrencyManager.fetchCryptocurrency().then((cryptocurrencyList) {
        _initialDataLoaded = true;
        _cryptocurrencyList = cryptocurrencyList;
        _cryptocurrencyListSubject.add(_filterCryptocurrencyList(
            _cryptocurrencyList,
            searchString: _searchString));
      });

  ////////////////////////////
  // Private
  String _searchString = "";
  List<Cryptocurrency> _cryptocurrencyList = List();
  var _initialDataLoaded = false;

  final CryptocurrencyManager _cryptocurrencyManager;
  final _cryptocurrencyListSubject = BehaviorSubject<List<Cryptocurrency>>();

  _filterCryptocurrencyList(List<Cryptocurrency> cryptocurrencyList,
          {@required String searchString}) =>
      _cryptocurrencyList.where((i) {
        return i.symbol.contains(searchString) || searchString.length == 0;
      }).toList();
}
