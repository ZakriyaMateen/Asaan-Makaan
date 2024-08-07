import 'package:asaanmakaan/Constants/Color.dart';
import 'package:asaanmakaan/Utils/Text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Constants/FontSizes.dart';
import '../../Constants/FontWeights.dart';



class UserDetails extends StatefulWidget {
  final String uid;
  const UserDetails({Key? key, required this.uid}) : super(key: key);

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {

  String fullName = '';
  String imageUrl = '';
  String email = '';
  String phone = '';
  String password = '';


  Future<void> getUserData()async{
    try{
      DocumentSnapshot userSnap = await FirebaseFirestore.instance.collection('Users').doc(widget.uid).get();

      String _fullName = await userSnap['firstName']+' '+userSnap['lastName'];
      String _imageUrl = await userSnap['imageUrl'];
      String _email = await userSnap['email'];
      String _phone = await userSnap['phone'];
      String _password = await userSnap['password'];

      setState(() {
        fullName=_fullName;
        email = _email;
        phone = _phone;
        password = _password;
        imageUrl = _imageUrl;
      });
    }
    catch(e){
      print(e.toString());
    }
  }
  Future<void> init()async{
    getUserData();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: greyShade2,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              textRoboto('User Details', primaryColor, w500, size22)
            ],
          ),
          SizedBox(height: h*0.05,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Container(
                width: w*0.22,
               height: h*0.6,
                decoration: BoxDecoration(
                  color:white,
                  borderRadius: BorderRadius.circular(12)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration:BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black,width: 1.5)
                          ),
                          child: CircleAvatar(
                            backgroundColor: greyShade2,
                            backgroundImage: NetworkImage(imageUrl),
                            radius: 100,
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 40,),
                  textRoboto('Name', darkTextColor,w500, size22),
                  // SizedBox(height: 2,),
                  textRoboto(fullName, lightTextColor,w400, size19),
                  SizedBox(height: 10,),

                  textRoboto('Email', darkTextColor,w500, size22),
                  // SizedBox(height: 2,),
                  textRoboto(email, lightTextColor,w400, size19),
                  SizedBox(height: 10,),

                  textRoboto('Phone', darkTextColor,w500, size22),
                  // SizedBox(height: 2,),
                  textRoboto(phone, lightTextColor,w400, size19),
                  SizedBox(height: 10,),

                  textRoboto('Password', darkTextColor,w500, size22),
                  // SizedBox(height: 2,),
                  textRoboto(password, lightTextColor,w400, size19),
                  SizedBox(height: 10,)
                  ],
                ),
              ),
              SizedBox(width: 20,),
              Container(
                width: w*0.6,
                height: h*0.65,
                decoration: BoxDecoration(
                  color:white,
                  borderRadius: BorderRadius.circular(12)
                ),
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance.collection('Users').doc(widget.uid).collection('MyProperties').snapshots(),

                builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                return  Center(
                child: CircularProgressIndicator(color: primaryColor,),
                );
                } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
                } else {
                final docs = snapshot.data!.docs;
                return GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4), itemBuilder: (context,index){
                  var data = docs[index].data();
                  return Container(
                    width: 400,
                    height: 400,
                    margin: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12)                      
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width:400,
                          height: 170,
                          decoration:BoxDecoration(
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12),bottomRight: Radius.circular(12)),
                          ),
                            child: ClipRRect(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(12),topRight: Radius.circular(12)),
                                child: Image.network(data['displayImage'],fit: BoxFit.cover,)
                            )),
                        SizedBox(height: 17,),
                        Padding(padding: EdgeInsets.only(left: 6),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                textRoboto("Property : ", darkTextColor,w500, size20),
                                textRoboto(data['propertyTypeOption'], lightTextColor,w400, size18),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                textRoboto("Price : ", darkTextColor,w500, size20),
                                textRoboto((data['totalPrice']).toString().length>11?data['totalPrice'].toString().substring(0,10):data['totalPrice'], lightTextColor, w400, size18)],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                textRoboto("area : " , darkTextColor,w500, size20),
                                textRoboto((data['area']).toString().length>9?data['area'].toString().substring(0,8):data['area']+" "+data['areaType'], lightTextColor, w400, size18),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 4,right: 4),
                                  child: InkWell(
                                      onTap:()async{
                                        try{

                                          await FirebaseFirestore.instance.collection('Users').doc(widget.uid).collection('MyProperties').doc(data['docId']).delete().then((value) async{
                                            try{
                                              await FirebaseFirestore.instance.collection('Users').doc(widget.uid).collection(data['city']).doc(data['propertyTypeOption']).collection(data['propertyTypeOption']).doc(data['purpose']).delete().then((value) {
                                                Navigator.pop(context);
                                              });
                                            }
                                            catch(e){
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: textRoboto('Some error occurred!',white, w400, size16)));
                                              Navigator.pop(context);
                                            }
                                          });


                                        }catch(e){
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: textRoboto('Could not delete, please try again later!',white, w400, size16)));
                                          Navigator.pop(context);

                                          print(e.toString());
                                        }
                                      },
                                      child: Icon(Icons.delete_forever,color: primaryColor,size: size17,)),
                                )
                              ],
                            )
                          ],
                        ),)


                      ],
                    ),
                  );

                },itemCount: docs.length,);

                }}),
              )
            ],
          )
        ],
      ),
    );
  }
}
