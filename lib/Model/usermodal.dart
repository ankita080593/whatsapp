class usermodal{
  String ? photoUrl;
  String ?name;
  String ?uid;
  bool isOnline=true;
  String ?phoneNumber;
  List?groupId;
  String?displayName;

  usermodal({

    this.name,this.photoUrl,this.uid,this.isOnline=true,this.phoneNumber,this.groupId,this.displayName
  });
  usermodal.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        uid = json['uid'],
        photoUrl = json['photoUrl'],
        isOnline = json['isOnline'],
        phoneNumber = json['phoneNumber'],
        groupId = json['groupId'];

  Map<String, dynamic> toJson() => {
    'name' : name,
    'uid' : uid,
    'photoUrl' : photoUrl,
    'isOnline' : isOnline,
    'phoneNumber': phoneNumber,
    'groupId' : groupId,
  };
}