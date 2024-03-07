import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whattsup/comman/utils.dart';
import 'package:whattsup/features/auth/class/AuthClass.dart';

class verification extends ConsumerStatefulWidget {
  const verification({super.key});

  @override
  ConsumerState<verification> createState() => _verificationState();
}

class _verificationState extends ConsumerState<verification> {
  String selectedCountry = '';
  String selectedcode = '';
  TextEditingController countrypicker = TextEditingController();
  TextEditingController number = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void sendOTP(BuildContext context) {
    if (number.text.length == 10 && selectedcode != '') {
      String mynumber = "+" + selectedcode.toString() + number.text.toString();
      ref.read(authClassProvider).signInWithPhone(context, mynumber);
    } else {
      showSnackBar(
        context: context,
        message: "All Fields Are Required",
      );
    }
  }

  @override
  void initState() {
    countrypicker.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var length = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Enter your phone number',
                    style: TextStyle(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 12,
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 50,
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  "WhatsApp will need to verify your account.What's my",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                ),
              ),
              Text(
                ' number?',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: TextFormField(
                      controller: countrypicker,
                      decoration: InputDecoration(
                        hintText: selectedCountry.toString(),
                      ),
                      onTap: () {
                        showCountryPicker(
                          context: context,
                          showPhoneCode: true,
                          countryListTheme: CountryListThemeData(
                            textStyle: TextStyle(fontSize: 18),
                            borderRadius:
                                BorderRadius.only(topLeft: Radius.circular(10)),
                            inputDecoration: InputDecoration(
                              prefixIcon: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.arrow_back_rounded,
                                  color: Colors.black,
                                ),
                              ),
                              labelText: 'Choose a country',
                              labelStyle: TextStyle(
                                fontSize: 25,
                                color: Colors.green,
                              ),
                            ),
                          ),
                          // optional. Shows phone code before the country name.
                          onSelect: (country) {
                            setState(() {
                              selectedCountry = country.name.toString();
                              selectedcode = country.phoneCode.toString();
                            });
                            // print(selectedCountry);
                            // print(country.countryCode.toString());
                            // print(country.phoneCode.toString());
                          },
                        );
                      },
                      onChanged: (country) {
                        print(selectedCountry);
                      },
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: length / 5,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "+" + selectedcode.toString(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'number is required';
                            } else if (value.length != 10) {
                              return 'please enter a valid mobile number';
                            }
                            return null;
                          },
                          controller: number,
                          keyboardType: TextInputType.number,
                        ),
                      ))
                    ],
                  )
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 30,
              ),
              Text(
                'Carrier charges may apply',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 2,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  onPressed: () => sendOTP(context),
                  child: Text(
                    'Next',
                    style: TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.white),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
