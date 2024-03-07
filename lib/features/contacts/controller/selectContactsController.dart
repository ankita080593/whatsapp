import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../../Model/contactmodal.dart';
import '../class/selectContactsClass.dart';
final selectContactsControllerfutureprovider = FutureProvider(
      (ref) {
    final selectContactsClass = ref.watch(selectContactsClassProvider);
    return selectContactsClass.getContacts();
  },
);

final selectContactsControllerprovider = Provider((ref) {
  final selectContactsClass = ref.watch(selectContactsClassProvider);
  return SelectContactsController(
    ref: ref,
    selectContactsClass: selectContactsClass,
  );
});

class SelectContactsController {
  final ProviderRef ref;
  final SelectContactsClass selectContactsClass;

  SelectContactsController({
    required this.ref,
    required this.selectContactsClass,
  });

  void selectContact(Contact selectedcontact, BuildContext context,String displayName) {

    selectContactsClass.selectContact(selectedcontact, context,displayName);
  }
}

