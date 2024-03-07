import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whattsup/Model/GroupContactModel.dart';
import 'package:whattsup/groups%20d/view/pagegroup.dart';
import '../../features/contacts/class/selectContactsClass.dart';
import '../../features/contacts/controller/selectContactsController.dart';
import '../../features/contacts/views/contactcard.dart';

class CreatGroupScreen extends ConsumerStatefulWidget {
  const CreatGroupScreen({super.key});

  @override
  ConsumerState<CreatGroupScreen> createState() => _CreatGroupScreenState();
}

class _CreatGroupScreenState extends ConsumerState<CreatGroupScreen> {
  List<Contact> contacts = [];
  List<GroupContactModel> groupcontact = [];

  //this list holds the data for the listview
  List<GroupContactModel> founduser = [];
  List<GroupContactModel> group = [];
  bool isselected = false;

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
      List<GroupContactModel> tmpcontacts = [];
      value.forEach((element) {
        if(element.phones.isNotEmpty){
          //print("error = ${element.phones[0]}");

        tmpcontacts.add(GroupContactModel(
            name: element.displayName,
            profilePic: element.photo.toString(),
            isselected: false,
          phones: element.phones[0].number.toString(),
        ));

        }
      });
      setState(() {
        groupcontact = tmpcontacts;
        founduser = groupcontact;
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
    List<GroupContactModel> result = [];
    if (enterkeyword.isEmpty) {
      //if the seacrh filed is empty or only contains white-space, we'll display all user
      result = groupcontact;
    } else {
      result = groupcontact
          .where((user) => user.name
              .toString()
              .toLowerCase()
              .contains(enterkeyword.toLowerCase()))
          .toList();
    }
    // Refresh the uid
    setState(() {
      founduser = result;
      print(founduser);
    });
  }

  bool issearch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            : Column(
                children: [
                  SizedBox(
                    width: 150,
                  ),
                  SizedBox(width: 150, child: Text('New group')),
                  SizedBox(
                      width: 150,
                      child: Visibility(
                          visible: group.length > 0,
                          replacement: Text(
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                              ),
                              'Add particiipants'),
                          child: Text(
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                              ),
                              '${group.length} of ${founduser.length}'))),
                ],
              ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                issearch = !issearch;
              });
            },
            icon:
                issearch ? const Icon(Icons.cancel) : const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          // SizedBox(height: 20,),
          SizedBox(
            width: 350,
            child: Text(
              'Contacts on WhatsApp',
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Visibility(
            // visible: true,
             visible: group.length > 0,
            child: Column(
              children: [
                Container(
                  height: 100,
                  width: 500,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: founduser.length,
                      itemBuilder: (context, index) {
                        //GroupContactModel groupdata=founduser[index];
                        if (founduser[index].isselected == true) {
                          return InkWell(
                            child: SizedBox(
                              width: 80,

                              child: InkWell(onTap: (){
    setState(() {
               isselected = !isselected;
               group.remove(founduser[index]);
               founduser[index].isselected = false;
          });
                              },
                                child: Column(
                                  children: [
                                    Stack(children: [
                                    CircleAvatar(
                                    backgroundImage: NetworkImage(
                                    founduser[index]
                                        .profilePic
                                        .toString(),

                                                                ),),
                                                            Positioned(
                                          right: -2,
                                          bottom: -2,
                                          child: Icon(
                                            Icons.cancel_rounded,
                                            color: Colors.redAccent,
                                          ),
                                        ),



                                    ],


                                      // child: Column(
                                      //   children: [
                                      //     ListTile(
                                      //       onTap: () {
                                      //         setState(() {
                                      //           isselected = !isselected;
                                      //           group.remove(founduser[index]);
                                      //           founduser[index].isselected = false;
                                      //         });
                                      //       },
                                      //       leading: Stack(
                                      //         children: [
                                      //           CircleAvatar(
                                      //             // backgroundImage: NetworkImage(
                                      //             //   founduser[index]
                                      //             //       .profilePic
                                      //             //       .toString(),
                                      //             // ),
                                      //           ),
                                      //           Positioned(
                                      //             right: -2,
                                      //             bottom: -2,
                                      //             child: Icon(
                                      //               Icons.cancel_rounded,
                                      //               color: Colors.redAccent,
                                      //             ),
                                      //           ),
                                      //         ],
                                      //       ),
                                      //     ),
                                      //     Text(founduser[index].name ?? ''),
                                      //   ],
                                      // ),
                                                                  ),
                                    Text(founduser[index].name ?? ''),
                                  ],
                                ),
                              ),
                              ),
                            );

                         // );
                        } else {
                          return Container(
                            width: 1,
                          );
                        }
                      }),
                ),
                Divider(
                  thickness: 3,
                )
              ],
            ),
          ),

          SizedBox(
            height: 700,
            child: ListView.builder(
                itemCount: founduser.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    child: contactcard(contactmodal: founduser[index]),
                    onTap: () {
                      if (founduser[index].isselected == true) {
                        setState(() {
                          group.remove(founduser[index]);
                          founduser[index].isselected = false;
                        });
                      } else {
                        setState(() {
                          group.add(founduser[index]);
                          founduser[index].isselected = true;
                        });
                      }
                      // ;
                    },
                  );
                }),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: Icon(Icons.east_rounded),
        onPressed: () {
          if (group.length > 1) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => pagegroup(group: group)));
          } else {
            Text('At list 1 contact must beselected');
          }
        },
      ),

      // SizedBox(height: MediaQuery.of(context).size.height,
      //   child: founduser.isNotEmpty
      //       ? ListView.builder(
      //     itemCount: founduser.length,
      //     itemBuilder: (context, index) => ListTile(
      //       onTap: () {
      //         selectContact(founduser[index], context, ref,
      //             founduser[index].displayName);
      //       },
      //       leading: founduser[index].photo != null
      //           ? CircleAvatar(
      //         radius: 40,
      //         backgroundImage:
      //         MemoryImage(founduser[index].photo!),
      //         backgroundColor: Colors.transparent,
      //       )
      //           : const CircleAvatar(
      //         radius: 40,
      //         backgroundImage: NetworkImage(
      //           userprofilePic,
      //         ),
      //       ),
      //       title: Text(founduser[index].displayName.toString()),
      //     ),
      //   )
      //       : krmLoader(),
      // ),
    );
  }
}
