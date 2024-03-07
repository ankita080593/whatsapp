import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
class country extends StatefulWidget {
  const country({super.key});

  @override
  State<country> createState() => _countryState();
}

class _countryState extends State<country> {
   Country ?_selectedCountry;
 void _openCountryPicker() {
   showCountryPicker(
     context: context,
     onSelect: (Country country) {
       setState(() {
         _selectedCountry = country;
       });
       Navigator.pop(context);
     },
     showPhoneCode: true,
     countryListTheme: CountryListThemeData(
       // Customize the appearance of the country list
       // For example, you can set the backgroundColor, textStyle, etc.
     ),
   );
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      title: Text('Country Picker Example'),
    ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _openCountryPicker,
              child: Text('Open Country Picker'),
            ),
            SizedBox(height: 20.0),
            _selectedCountry != null
                ? Column(
              children: [
                Text('Selected Country: ${_selectedCountry?.displayName}'),
                Text('Dialing Code: +${_selectedCountry?.phoneCode}'),
              ],
            )
                : Container(),
          ],
        ),
      ),
    );
  }
}
