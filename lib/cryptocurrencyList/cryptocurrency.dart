class Cryptocurrency {
  int id;
  String symbol;
  String name;
  String route;
  String iconUrl;
  bool fiat;

  Cryptocurrency.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    symbol = json['symbol'];
    name = json['name'];
    route = json['route'];
    fiat = json['fiat'];
    iconUrl = 'assets/cryptocurrencyIcons/${symbol}.png';
  }
}