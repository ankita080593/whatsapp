import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:whattsup/features/auth/views/verification.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height/6,
            ),
            Center(child:
            //Image.asset('assets/images/wapp.jpeg'),),
            CircleAvatar(backgroundImage: AssetImage('assets/images/wapp.jpeg'),radius: 150,)),
            SizedBox(
              height: MediaQuery.of(context).size.height/10,
            ),
            Text(
              'Welcome to WhatsApp',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
            SizedBox(
              height:MediaQuery.of(context).size.height/30,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Read our Privacy Policy.Tap"Agree and continue"to ',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
            ),
            Text(
              'accept the Terms of Service',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height/20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width/1.5,
              height: MediaQuery.of(context).size.height/15,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>verification()));
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),backgroundColor: Colors.green.shade600
                  ),
                  child: Text(
                    'Agree and continue',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
