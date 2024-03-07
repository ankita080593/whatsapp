
/*class Contact {
  var time;
  var profilePic;
  String ? name;
  String ? message;
  bool isselected = false;
  String ?gender;
  var age;

  Contact({
    this.time,
    this.profilePic,
    this.name,
    this.message,
    this.isselected=false,
    this.gender,
    this.age
  });
}*/


class contactmodal{
  var time;
  var profilePic;
  String ? name;
  String ? message;
  bool isselected = false;
  final String contactId;
  contactmodal({
    this.time,
    this.profilePic,
    this.name,
    this.message,
    this.isselected=false,
    required this.contactId,

  });



}