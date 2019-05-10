import 'dart:convert';
import 'package:crypto_exchange/cryptocurrencyExchangeList/cryptocurrency_exchange.dart';
import 'package:crypto_exchange/cryptocurrencyList/cryptocurrency.dart';
import 'package:http/http.dart' as http;

class CryptocurrencyManager {
  Future<List<Cryptocurrency>> fetchCryptocurrency() async {
    final response = await http.get("https://api.cryptowat.ch/assets");
    if (response.statusCode == 200) {
      Map<String, dynamic> responseJson = jsonDecode(response.body);
      List resultJson = responseJson['result'];
      List<Cryptocurrency> cryptocurrencyList = resultJson.map(
              (cryptocurrencyJson) =>
              Cryptocurrency.fromJson(cryptocurrencyJson)
      ).toList();
      return cryptocurrencyList;
    } else {
      throw Exception('Failed to load cryptocurrency list');
    }
  }
  
  Future<CryptocurrencyExchange> fetchCryptocurrencyExchange(String from, String to) async {
    final response = await http.get('https://api.cryptonator.com/api/full/${from}-${to}');
    if (response.statusCode == 200) {
      Map<String, dynamic> responseJson = jsonDecode(response.body);
      CryptocurrencyExchange cryptocurrencyExchange = CryptocurrencyExchange.fromJson(responseJson);
      return cryptocurrencyExchange;
    } else {
      throw Exception('Failed to load cryptocurrency exchange list');
    }
  }
}
