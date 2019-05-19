import 'package:crypto_exchange/cryptocurrencyExchangeList/cryptocurrency_exchange.dart';
import 'package:crypto_exchange/cryptocurrencyExchangeList/cryptocurrency_exchange_block.dart';
import 'package:crypto_exchange/cryptocurrency_manager.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockCryptocurrencyManager extends Mock implements CryptocurrencyManager {

}

void main() {
  Map<String, dynamic> testCryptocurrencyExchangeJson = {
    'ticker': {
      'base': 'SHITCOIN',
      'target': 'USD',
      'price': '7952.27964835',
      'volume': '125571.76297719',
      'change': '51.34763365',
      'timestamp': 1558272905,
      'success': true,
      'error': '',
      'markets': [{
        'market': 'Binance',
        'price': '7934.60000000',
        'volume': 56159.798011
      }]
    }
  };

  test('Test cryptocurrency exchange parsing and block', () {
    CryptocurrencyExchange testCryptocurrencyExchange = CryptocurrencyExchange.fromJson(
        testCryptocurrencyExchangeJson
    );

    expect(testCryptocurrencyExchange.ticker.markets.length, 1);
    expect(testCryptocurrencyExchange.ticker.base, 'SHITCOIN');
    expect(testCryptocurrencyExchange.ticker.price, '7952.27964835');

    var cryptocurrencyManagerMock = MockCryptocurrencyManager();
    when(cryptocurrencyManagerMock.fetchCryptocurrencyExchange('SHITCOIN', 'usd')).thenAnswer( (_) =>
        new Future.value(testCryptocurrencyExchange)
    );

    var cryptocurrencyExchangeBlock = CryptocurrencyExchangeBlock(
        cryptocurrencyManager: cryptocurrencyManagerMock,
        cryptocurrencySymbol: 'SHITCOIN'
    );

    cryptocurrencyExchangeBlock.refresh().whenComplete((){
      expect(cryptocurrencyExchangeBlock.initialDataLoaded, true);
    });
  });


}