import 'package:crypto_exchange/cryptocurrency_manager.dart';
import 'package:flutter/material.dart';

class Provider extends InheritedWidget {

  final CryptocurrencyManager cryptocurrencyManager;

  const Provider({
    Key key,
    @required Widget child,
    @required this.cryptocurrencyManager,
  })
      : assert(child != null),
        super(key: key, child: child);

  static Provider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(Provider) as Provider;
  }

  @override
  bool updateShouldNotify(Provider old) => true;
}