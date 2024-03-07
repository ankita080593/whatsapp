import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whattsup/comman/SerchView.dart';
import 'package:whattsup/features/chats/view/message.dart';
import 'package:whattsup/groups%20d/view/CreateGroupScreen.dart';

import '../../../Model/contactmodal.dart';
import '../../../comman/Error404Screen.dart';
import '../../../comman/colors.dart';
import '../../../comman/globlevariable.dart';
import '../../../comman/krmLoader.dart';
import '../class/selectContactsClass.dart';
import '../controller/selectContactsController.dart';

// class SelectContactsScreen extends ConsumerWidget {
//   static const String routeName = "select_contact";
//   final device;
//   const SelectContactsScreen({required this.device,super.key});
class SelectContactsScreen extends ConsumerStatefulWidget {
  static const String routeName = "select_contact";
  final device;

  const SelectContactsScreen({required this.device, super.key});

  @override
  ConsumerState<SelectContactsScreen> createState() =>
      _SelectContactsScreenState();
}

class _SelectContactsScreenState extends ConsumerState<SelectContactsScreen> {
  List<Contact> contacts = [];

  //this list holds the data for the listview
  List<Contact> contactlist = [];

  void selectContact(Contact selectedcontact, BuildContext context,
      WidgetRef ref, String displayName) {
    ref.read(selectContactsControllerprovider).selectContact(
          selectedcontact,
          context,
          displayName,
        );
  }

  void getContacts() async {
    ref.read(selectContactsClassProvider).getContacts().then((value) {
      setState(() {
        contacts = value;
        contactlist = value;
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
  void runFilter(String enterkeyword) {
    List<Contact> result = [];
    if (enterkeyword.isEmpty) {
      //if the seacrh filed is empty or only contains white-space, we'll display all user
      result = contacts;
    } else {
      result = contacts
          .where((user) => user.name
              .toString()
              .toLowerCase()
              .contains(enterkeyword.toLowerCase()))
          .toList();
    }
    // Refresh the uid
    setState(() {
      contactlist = result;
      //(founduser);
    });
  }

  bool issearch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // title: const Text("Select Contact"),
          title: issearch
              ? TextFormField(
                  onChanged: (value) => runFilter(value),
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      hintText: 'Search',
                      suffixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(width: 2),
                      )),
                )
              : const Text("Select Contact"),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  issearch = !issearch;
                });
              },
              icon: issearch
                  ? const Icon(Icons.cancel)
                  : const Icon(Icons.search),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (contex) => CreatGroupScreen()));
                },
                leading: CircleAvatar(
                  child: Icon(
                    Icons.people,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.teal,
                  radius: 20,
                ),
                title: Text('New group'),
              ),
              ListTile(
                onTap: () {
                  // Navigator.push(
                  //     context, MaterialPageRoute(builder: (context) => save()));
                },
                leading: CircleAvatar(
                  child: Icon(
                    Icons.person_add,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.teal,
                  radius: 20,
                ),
                title: Text('New contact'),
                trailing: Icon(Icons.qr_code),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                  width: 350,
                  child: Text('Contacts on WhatsApp',
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.bold))),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: contactlist.isNotEmpty
                    ? ListView.builder(
                        itemCount: contactlist.length,
                        itemBuilder: (context, index) => ListTile(
                          onTap: () {
                            selectContact(contactlist[index], context, ref,
                                contactlist[index].displayName);
                          },
                          leading: contactlist[index].photo != null
                              ? CircleAvatar(
                                  radius: 40,
                                  backgroundImage:
                                      MemoryImage(contactlist[index].photo!),
                                  backgroundColor: Colors.transparent,
                                )
                              : const CircleAvatar(
                                  radius: 40,
                                  backgroundImage: NetworkImage(
                                    userprofilePic,
                                  ),
                                ),
                          title:
                              Text(contactlist[index].displayName.toString()),
                        ),
                      )
                    : krmLoader(),
              ),
            ],
          ),
        )
        // body: ref.watch(selectContactsControllerfutureprovider).when(
        //   data: (contactlist) {
        //     return ListView.builder(
        //       itemCount: contactlist.length,
        //       itemBuilder: (context, index) {
        //         contactlist[index].photo;
        //         return InkWell(
        //           onTap: () {
        //             selectContact(contactlist[index], context, ref,contactlist[index].displayName);
        //           },
        //           child: Column(
        //             children: [
        //               Padding(
        //                 padding: const EdgeInsets.symmetric(vertical: 8.0),
        //                 child: ListTile(
        //                   leading: contactlist[index].photo != null
        //                       ? CircleAvatar(
        //                     radius: 40,
        //                     backgroundImage: MemoryImage(
        //                       contactlist[index].photo!,
        //                     ),
        //                   )
        //                       : const CircleAvatar(
        //                     radius: 40,
        //                     backgroundImage: NetworkImage(
        //                       userprofilePic,
        //                     ),
        //                   ),
        //                   title: Text(
        //                     contactlist[index].displayName,
        //                     style: const TextStyle(
        //                       fontSize: 15,
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //               // const Divider(
        //               //   color: dividerColor,
        //               // )
        //             ],
        //           ),
        //         );
        //       },
        //     );
        //   },
        //   error: (error, trace) {
        //     return Error404Screen(
        //       error: error.toString(),
        //     );
        //   },
        //   loading: () {
        //     return const krmLoader();
        //   },
        // ),
        );
  }

  Widget serchview() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          TextFormField(
            onChanged: (value) => runFilter(value),
            decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                hintText: 'Search',
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(width: 2),
                )),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: contactlist.isNotEmpty
                ? ListView.builder(
                    itemCount: contactlist.length,
                    itemBuilder: (context, index) => Card(
                      elevation: 1,
                      margin: EdgeInsets.symmetric(vertical: 2),
                      child: ListTile(
                        leading: contactlist[index].photo != null
                            ? CircleAvatar(
                                radius: 40,
                                backgroundImage:
                                    MemoryImage(contactlist[index].photo!),
                                backgroundColor: Colors.transparent,
                              )
                            : const CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(
                                  userprofilePic,
                                ),
                              ),
                        title: Text(contactlist[index].displayName.toString()),
                      ),
                    ),
                  )
                : const krmLoader(),
          ),
        ],
      ),
    );
  }
}
