import 'package:crypto_exchange/cryptocurrencyList/cryptocurrency.dart';
import 'package:crypto_exchange/cryptocurrencyExchangeList/cryptocurrency_exchange_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CryptocurrencyRow extends StatelessWidget {

  final Cryptocurrency cyptocurrency;

  const CryptocurrencyRow({Key key, this.cyptocurrency}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<Image> _buildImage() async {
      return rootBundle.load(cyptocurrency.iconUrl).then((value) {
        return Image.memory(value.buffer.asUint8List());
      }).catchError((_) {
        return Image.asset(
          'assets/cryptocurrencyIcons/notFound.png',
        );
      });
    }

    return InkWell(
      child: ListTile(
        leading: FutureBuilder(future: _buildImage(), builder: (context, AsyncSnapshot<Image> image) {
          return CircleAvatar(
              child: image.data,
              backgroundColor: Colors.transparent
          );
        }),

        title: Text('${cyptocurrency.name}'),
        subtitle: Text('${cyptocurrency.symbol.toUpperCase()}'),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => CryptocurrencyExchangeList(cryptocurrency: cyptocurrency)
        ));
      },
    );
  }
}