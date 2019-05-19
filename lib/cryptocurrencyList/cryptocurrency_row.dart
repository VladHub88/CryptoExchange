import 'package:crypto_exchange/cryptocurrencyList/cryptocurrency.dart';
import 'package:crypto_exchange/cryptocurrencyExchangeList/cryptocurrency_exchange_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CryptocurrencyRow extends StatefulWidget {
  final Cryptocurrency cryptocurrency;

  const CryptocurrencyRow({Key key, this.cryptocurrency}) : super(key: key);

  @override
  _CryptocurrencyRowState createState() => _CryptocurrencyRowState();
}

class _CryptocurrencyRowState extends State<CryptocurrencyRow> {

  Image _cryptocurrencyIcon = null;

  Future<Image> _buildImage() async {
    return rootBundle.load(widget.cryptocurrency.iconUrl).then((value) {
      _cryptocurrencyIcon = Image.memory(value.buffer.asUint8List());
      return _cryptocurrencyIcon;
    }).catchError((_) {
      _cryptocurrencyIcon = Image.asset(
        'assets/cryptocurrencyIcons/notFound.png',
      );
      return _cryptocurrencyIcon;
    });
  }


  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: ListTile(
        leading: FutureBuilder(future: _buildImage(), builder: (context, AsyncSnapshot<Image> image) {
          return Hero(
            tag: widget.cryptocurrency.id,
            child: CircleAvatar(
                child: image.data,
                backgroundColor: Colors.transparent
            ),
          );
        }),

        title: Text('${widget.cryptocurrency.name}'),
        subtitle: Text('${widget.cryptocurrency.symbol.toUpperCase()}'),
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => CryptocurrencyExchangeList(
                cryptocurrency: widget.cryptocurrency,
                cryptocurrencyIcon: _cryptocurrencyIcon
            )
        ));
      },
    );
  }
}
