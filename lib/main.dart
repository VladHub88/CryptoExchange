import 'package:crypto_exchange/cryptocurrencyList/cryptocurrency_list.dart';
import 'package:crypto_exchange/cryptocurrency_manager.dart';
import 'package:crypto_exchange/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      cryptocurrencyManager: CryptocurrencyManager(),
      child: MaterialApp(
        home: CryptocurrencyList(),
        theme: ThemeData.dark(),
      ),
    );
  }
}