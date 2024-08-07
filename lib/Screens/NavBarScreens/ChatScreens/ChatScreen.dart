import 'package:asaanmakaan/Constants/Color.dart';
import 'package:asaanmakaan/Utils/Text.dart';
import 'package:asaanmakaan/Utils/Transitions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../Constants/FontSizes.dart';
import '../../../Constants/FontWeights.dart';

class ChatScreen extends StatefulWidget {
  final String user2Uid;
  const ChatScreen({Key? key, required this.user2Uid}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  List<Map<String,dynamic>> chat = [
    {
      'message':'Hi how are you?',
      'time':'12:03',
      'date':'15/05/2024',
      'messageDocId':1,
    },{
      'message':'Hi how are you?',
      'time':'12:03',
      'date':'15/05/2024',
      'messageDocId':2,
    },{
      'message':'HiIIadiasidiaidiaisdiasdiaisdasidiasidiasidaisdiaisda?',
      'time':'12:03',
      'date':'15/05/2024',
      'messageDocId':3,
    },{
      'message':'Hi how are you?',
      'time':'12:03',
      'date':'15/05/2024',
      'messageDocId':4,
    },
  ];

  bool isMe(String userUid){
    return FirebaseAuth.instance.currentUser!.uid == userUid;
  }

  String combinedUids = '';
  String getCombinedUIDs(String v1, String v2) {
    // Sort the UIDs lexicographically and concatenate them
    List<String> uids = [v1, v2];
    uids.sort();
    return uids.join();
  }
  Future<void> combineUid()async{
    try{
      combinedUids = getCombinedUIDs(widget.user2Uid, FirebaseAuth.instance.currentUser!.uid);
    }
    catch(e){
      print(e.toString());
    }
  }

  String fullName = '';
  String imageUrl = '';
  String email = '';
  String phone = '';
  bool isLoading = true;
  Future<void> getReceiverData()async{

    try{
        DocumentSnapshot userSnap = await FirebaseFirestore.instance.collection('Users').doc(widget.user2Uid).get();
        String _fullName = await userSnap['firstName'] + await userSnap['lastName'];
        String _imageUrl = '';

        try{
          _imageUrl = await userSnap['imageUrl'] ;
        }
        catch(e){

        }

        String _phone    = await userSnap['phone'];
        String _email    = await userSnap['email'];

        setState(() {
          fullName = _fullName;
          imageUrl = _imageUrl;
          email    = _email;
          phone    = _phone;

          isLoading = false;
        });
    }
    catch(e){
      print(e.toString());
    }

  }
  Future<void> init()async{
    await getReceiverData().then((value) {
      combineUid();
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

      TextEditingController messageController = TextEditingController();

  FocusNode messageFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {


    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: greyShade2,
        body:
        isLoading ? Center(child: CircularProgressIndicator(color: primaryColor),):

        Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset('assets/doodles.png',width: w,height: h,fit: BoxFit.cover,filterQuality: FilterQuality.high,),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: w,
                height: h,
                color: white.withOpacity(0.65 ),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom:70,left: 8,right: 8 ),
                child:

                              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                              stream: FirebaseFirestore.instance.collection('Chats')
                                  .doc(combinedUids).collection('Messages')
                                  .orderBy('timestamp', descending: true)
                                  .snapshots(),
                              builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                              return  Center(
                                child: CircularProgressIndicator(color: primaryColor,),
                              );
                              } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                                } else {
                                  final docs = snapshot.data!.docs;

                           return   ListView.builder(itemBuilder :(context,index){
                             final data = docs[index].data();
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                     crossAxisAlignment: CrossAxisAlignment.center,
                                   mainAxisAlignment: isMe(data['senderUid'])? MainAxisAlignment.end:MainAxisAlignment.start,
                                   children: [
                                  Stack(
                                   children: [
                                  InkWell(
                                    onLongPress:  isMe(data['senderUid'])?(){
                                    showDeleteDialog(data['docId']);
                                    }:(){},
                                    child: Container(

                                       decoration:BoxDecoration(
                                    color: isMe(data['senderUid'])?primaryColor:green ,
                                    borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                        topLeft: Radius.circular(10),
                                     bottomRight: Radius.circular(  !isMe(data['senderUid'])?10:0),
                                          bottomLeft: Radius.circular(isMe(data['senderUid'])?10:0),
                                     )
                                    ),

                                    padding: EdgeInsets.only(left: 15,right: 15,top: 10,bottom: 10),
                                    margin: EdgeInsets.only(bottom: 7), constraints: BoxConstraints(
                                    maxWidth: w*0.7,
                                      minWidth: 50
                                    ),
                                    child: textRobotoMessage(data['message'], white, w400, size15)
                                    ),
                                  ),


                                   ],
                                  ),],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: isMe(data['senderUid'])? MainAxisAlignment.end:MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 4,right: !isMe(data['senderUid'])?16:0,left: isMe(data['senderUid'])?16:0  ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            textRoboto(data['time'], darkTextColor, w400, size10)
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4,),
                                ],
                              );
                              },itemCount: docs.length,reverse: true,);
                              }})
                                      ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: (){
                    showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                        ),
                        backgroundColor: white,
                        context: context, builder: (context){
                      return Container(
                        width: w,
                        height: h*0.47,
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: 28,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.network(imageUrl==''?
                                      'data:image/png;base64,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'
                                          :imageUrl,fit: BoxFit.cover,),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 33,),
                              Padding(
                                padding: EdgeInsets.only(left: 20,right: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(Icons.person,color: lightTextColor,size: size22,),
                                        SizedBox(width: 10,),
                                        textRoboto(fullName,darkTextColor ,w500, size19)
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(Icons.phone,color: lightTextColor,size: size25,),
                                        SizedBox(width: 10,),
                                        textRoboto(phone,darkTextColor ,w500, size19)
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(Icons.email,color: lightTextColor,size: size25,),
                                        SizedBox(width: 10,),
                                        textRoboto(email,darkTextColor ,w500, size19)
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );

                    });
                  },
                  child: Container(width: w,height: 64,

                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5),bottomRight: Radius.circular(5))
                  ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: w*0.05,),
                        InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back_ios,color: white,size: size18,),
                        ),
                        SizedBox(width: 5,),
                        InkWell(
                          onTap:(){
                            showDialog(context: context, builder: (context){
                              return Dialog(
                                backgroundColor: white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Container(
                                  width: 250,
                                  height: 250,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.network(imageUrl==''?
                                    'data:image/png;base64,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'
                                        :imageUrl,fit: BoxFit.cover,),
                                  ),
                                ),
                              );
                            });
                          },
                          child: Container(
                            width: 47,
                            height: 47,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: white.withOpacity(0.3),width: 1)
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(imageUrl==''?
                              'data:image/png;base64,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'
                                  :imageUrl,fit: BoxFit.cover,),
                            ),
                          ),
                        ),

                        SizedBox(width: 10,),
                        textRubik(fullName,white , w500, size16)
                      ],
                    ),
                  ),
                ),

              ],
            ),
            Align(alignment: Alignment.bottomCenter,

            child:Container(
              width: w,
              height: 60  ,
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                // color: primaryColor,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5))
              ),
              padding: EdgeInsets.symmetric(horizontal: w*0.04),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: w*0.8,
                    height: 48,
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(90)
                    ),
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: 8),
                    child: Row(
                      children: [
                        Flexible(
                          child: TextFormField(
                            focusNode: messageFocusNode,
                            controller:messageController,
                            decoration: InputDecoration.collapsed(hintText: 'Enter Message...'),
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                color: darkTextColor,
                                fontWeight: w400,
                                fontSize: size15
                              )
                            ),
                            onFieldSubmitted: (v)async{
                              if(v!.isNotEmpty){
                                await sendMessage(v!);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  InkWell(
                      onTap:()async{
                        if(messageController.text.isNotEmpty){
                          await sendMessage(messageController.text.toString());
                        }
                      },
                      child: Container(width: 40,height: 40,decoration: BoxDecoration(shape: BoxShape.circle,color: white),child: Center(child: Icon(Icons.send,color: primaryColor,size: size20,),),))

                ],
              ),
            ) ,
              )
          ],
        ),
      ),
    );
  }

  Future<void> showDeleteDialog(String messageDocId,  )async{

    try{
      showDialog(context: context, builder: (context){
        return Dialog(

          backgroundColor: white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 250,
              maxHeight: 150
            ),
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 18),
                  child: textRobotoMessage('Are you sure you want to delete this message?', darkTextColor, w500, size19),
                ),
                SizedBox(height: 18,),
                Divider(color: greyShade2,thickness: 1,),
                SizedBox(height: 10,),

                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap:()async{
                            try{
                              await FirebaseFirestore.instance.collection('Chats').doc(combinedUids).collection('Messages').doc(messageDocId).delete().then((value){
                                Navigator.pop(context);
                              });
                            }
                            catch(e){
                              print(e.toString());
                            }
                          },
                          child: textRoboto('Confirm', red, w500, size16)),
                      VerticalDivider(color: greyShade2,thickness: 1,),

                      InkWell(
                          onTap:(){
                            Navigator.pop(context);
                          },
                          child: textRoboto('Cancel', darkTextColor, w400, size16)),

                    ],
                  ),
                )
              ],
            ),
          ),
        );

      },);

    }
    catch(e){
      print(e.toString());
    }
  }

  String formatCurrentTime() {
    // Get the current time
    DateTime now = DateTime.now();

    // Create a DateFormat instance for the desired format
    DateFormat formatter = DateFormat('h:mm a');

    // Format the current time
    String formattedTime = formatter.format(now);

    return formattedTime;
  }

  Future sendMessage(String message)async{

    try{
      messageController.clear();
      messageFocusNode.requestFocus();

      DocumentReference messageRef = await FirebaseFirestore.instance.collection('Chats').doc(combinedUids);
      messageRef.set({
         'timestamp': FieldValue.serverTimestamp(),
         'lastMessage': message,
         'senderUid':FirebaseAuth.instance.currentUser!.uid,
         'time':formatCurrentTime(),
         'receiverUid':widget.user2Uid,
         'senderProfileImage':imageUrl,
         'senderName':fullName,
         'combinedUid':combinedUids,
        'archived':'false'
       });
      await messageRef.update({
        'docId':messageRef.id
      });
      messageRef.collection('Messages').add({
        'timestamp': FieldValue.serverTimestamp(),
        'message': message,
        'senderUid':FirebaseAuth.instance.currentUser!.uid,
        'time':formatCurrentTime(),
        'receiverUid':widget.user2Uid
      });
      await messageRef.update({
        'docId':messageRef.id
      });
    }
    catch(e){
      print(e.toString());
    }


  }

}
