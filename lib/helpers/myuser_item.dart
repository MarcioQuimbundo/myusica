import 'package:flutter/material.dart';
import 'package:myusica/helpers/myuser.dart';
import 'package:myusica/subs/myuser_profile.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Myuser item to show on the results tab
class MyuserItem extends StatefulWidget {
  final Myuser myuser;
  MyuserItem({
    @required this.myuser
  });
  
  MyuserItemState createState() => MyuserItemState();
}

class MyuserItemState extends State<MyuserItem> {
  String ppString;
  @override
  void initState() {
    super.initState();
    
    getProfilePicture(widget.myuser).then((value) {
      if (value != null) {
        setState(() {
          print("image url " + value);
          ppString = value.toString();
        });
      }
    });
  }

   // get myuser profile picture url from firebase
  Future<dynamic> getProfilePicture(Myuser myuser) async {
    try {
      FirebaseStorage storage = new FirebaseStorage(
        storageBucket: 'gs://myusica-4818e.appspot.com'
      );
      StorageReference imageLink = 
        storage.ref().child('myuser-profile-pictures').child(myuser.picture + ".jpg");
      final imageUrl = await imageLink.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print("No picture found");
      return null;
    } 
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ppString == null ? 
            CircleAvatar(
              radius: 30.0,
              child: Text(widget.myuser.name.substring(0, 1)),
            ) 
            : CircleAvatar(
              radius: 30.0,
              backgroundImage: CachedNetworkImageProvider(ppString),
              backgroundColor: Colors.transparent,
            ),
      title: Text(widget.myuser.name),
      subtitle: Text(widget.myuser.city + ", " + widget.myuser.state),
      onTap: () { 
        Navigator.push(
          context, 
          MaterialPageRoute(settings: RouteSettings(),
            builder: (context) => MyuserProfile(myuser: widget.myuser, imageUrl: ppString)));}
    );
  }
}