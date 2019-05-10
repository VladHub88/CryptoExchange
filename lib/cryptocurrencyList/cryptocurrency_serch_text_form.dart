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
        child: TextFormField(
          controller: searchController,
            autovalidate: false,
            decoration: InputDecoration(
                labelText: 'Cryptocurrency symbol',
                suffixIcon: IconButton(icon: Icon(Icons.search), onPressed: () {
                  if (_formKey.currentState.validate()) {
                    onChanged(searchController.text);
                  }
                })
            ),
            validator: (symbol) {
              if (symbol.length > 0 && symbol.length < 3) {
                return 'Must be at least 3 characters';
              }
            }
        ),
      ),
    );
  }
}
