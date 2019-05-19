import 'package:flutter/material.dart';

typedef onSearchTextChanged = void Function(String searchText);

class CryptocurrencySearchTextForm extends StatefulWidget {

  onSearchTextChanged onChanged;

  CryptocurrencySearchTextForm({this.onChanged});

  @override
  _CryptocurrencySearchTextFormState createState() => _CryptocurrencySearchTextFormState(onChanged);
}

class _CryptocurrencySearchTextFormState extends State<CryptocurrencySearchTextForm> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController searchController = new TextEditingController();
  onSearchTextChanged onChanged;

  _CryptocurrencySearchTextFormState(this.onChanged);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: TextField(
          controller: searchController,
          decoration: InputDecoration(
            labelText: 'Search cryptocurrency',
              suffixIcon: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    searchController.clear();
                    onChanged('');
                  }),
          ),
          onChanged: (text) {
            onChanged(text);
          },
        ),
      ),
    );
  }
}
