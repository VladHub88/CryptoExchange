import 'package:crypto_exchange/cryptocurrencyExchangeList/cryptocurrency_exchange.dart';
import 'package:crypto_exchange/cryptocurrencyList/cryptocurrency.dart';
import 'package:flutter/material.dart';

class CryptocurrencyExchangeRow extends StatelessWidget {

  final Market market;

  const CryptocurrencyExchangeRow({Key key, @required this.market}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: ListTile(
        leading: Text('${market.market}'),
        trailing: Text('${market.price}'),
      ),
    );
  }
}