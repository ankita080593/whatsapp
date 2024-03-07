import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:whattsup/Model/contactmodal.dart';
import 'package:whattsup/comman/krmLoader.dart';
import 'package:whattsup/features/contacts/class/selectContactsClass.dart';

import '../features/contacts/controller/selectContactsController.dart';
import 'globlevariable.dart';
class SearchView extends ConsumerStatefulWidget {
  static const String routeName = "select_contact";
  final device;
  const SearchView({required this.device ,super.key});
  void selectContact(
      Contact selectedcontact,
      BuildContext context,
      WidgetRef ref,
      String displayName

      ) {
    ref.read(selectContactsControllerprovider).selectContact(
      selectedcontact,
      context,
      displayName,
    );

  }

  @override
  ConsumerState<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends ConsumerState<SearchView> {
   List<Contact> contacts = [];
  //this list holds the data for the listview
  List<Contact> founduser = [];

  void getContacts() async{
    ref.read(selectContactsClassProvider).getContacts().then(( value) {
      setState(() {
        contacts=value;
        founduser = value;
      });
    });
  }

  @override
  initState() {
    //at the beginning ,all users are show
    super.initState();
    getContacts();
  }
  // This function is called whenever the text filed changes
  void runFilter (String enterkeyword) {
    List<Contact> result = [];
    if(enterkeyword.isEmpty) {
      //if the seacrh filed is empty or only contains white-space, we'll display all user
      result = contacts;
    } else {

      result = contacts.where((user) =>
      user.name.toString().toLowerCase().contains(enterkeyword.toLowerCase())
      ).toList();

    }
    // Refresh the uid
    setState(() {
      founduser= result;
      print(founduser);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Center(
      //     child: Text("Search User Name",style: TextStyle(
      //         fontStyle: FontStyle.italic,
      //         fontWeight: FontWeight.bold
      //     ),),
      //   ),
      //   backgroundColor: Colors.purple,
      // ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(height: 10,),
            TextFormField(
              onChanged: (value) => runFilter(value),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                  hintText: 'Search',
                  suffixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(width: 2),
                  )
              ),
            ),
            SizedBox(height: 10,),
            Expanded(
                child: founduser.isNotEmpty ? ListView.builder(
                  itemCount: founduser.length,
                  itemBuilder: (context,index) => Card(
                    elevation: 1,
                    margin: EdgeInsets.symmetric(vertical: 2),
                    child: ListTile(
                      leading: founduser[index].photo != null
                          ? CircleAvatar(
                        radius: 40,
                        backgroundImage: MemoryImage(founduser[index].photo!),
                        backgroundColor: Colors.transparent,
                      ):const CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                        userprofilePic,
                      ),
                    ),
                      title: Text(founduser[index].displayName.toString()),
                    ),
                  ),
                ) : krmLoader()
            ),
          ],
        ),
      ),
    );
  }
}