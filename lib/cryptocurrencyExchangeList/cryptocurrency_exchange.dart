class CryptocurrencyExchange {
  Ticker ticker;
  bool success;
  String error;

  CryptocurrencyExchange({this.ticker, this.success, this.error});

  CryptocurrencyExchange.fromJson(Map<String, dynamic> json) {
    ticker =
    json['ticker'] != null ? new Ticker.fromJson(json['ticker']) : null;
    success = json['success'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ticker != null) {
      data['ticker'] = this.ticker.toJson();
    }
    data['success'] = this.success;
    data['error'] = this.error;
    return data;
  }
}

class Ticker {
  String base;
  String target;
  String price;
  String volume;
  String change;
  List<Market> markets;

  Ticker(
      {this.base,
        this.target,
        this.price,
        this.volume,
        this.change,
        this.markets});

  Ticker.fromJson(Map<String, dynamic> json) {
    base = json['base'];
    target = json['target'];
    price = json['price'];
    volume = json['volume'];
    change = json['change'];
    if (json['markets'] != null) {
      markets = new List<Market>();
      json['markets'].forEach((v) {
        markets.add(new Market.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['base'] = this.base;
    data['target'] = this.target;
    data['price'] = this.price;
    data['volume'] = this.volume;
    data['change'] = this.change;
    if (this.markets != null) {
      data['markets'] = this.markets.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Market {
  String market;
  String price;
  double volume;

  Market({this.market, this.price, this.volume});

  Market.fromJson(Map<String, dynamic> json) {
    market = json['market'];
    price = json['price'];
    volume = json['volume'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['market'] = this.market;
    data['price'] = this.price;
    data['volume'] = this.volume;
    return data;
  }
}

