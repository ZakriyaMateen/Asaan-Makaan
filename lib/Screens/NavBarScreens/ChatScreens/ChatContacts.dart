import 'package:asaanmakaan/Constants/Color.dart';
import 'package:asaanmakaan/Screens/NavBarScreens/ChatScreens/ChatScreen.dart';
import 'package:asaanmakaan/Utils/Text.dart';
import 'package:asaanmakaan/Utils/Transitions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../Constants/FontSizes.dart';
import '../../../Constants/FontWeights.dart';
import 'ArchivedChats.dart';

class ChatContacts extends StatefulWidget {
  const ChatContacts({Key? key}) : super(key: key);

  @override
  State<ChatContacts> createState() => _ChatContactsState();
}

class _ChatContactsState extends State<ChatContacts> {
  bool isArchiving = false;
  @override
  Widget build(BuildContext context) {

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: h*0.047,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                  SizedBox(width: w*0.05,),
                      InkWell(
                        onTap: (){Navigator.pop(context);},
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                              color: darkTextColor,
                              shape: BoxShape.circle
                          ),
                          child: Center(
                            child: Icon(Icons.arrow_back_ios_new_outlined,color: white,size: size12,),
                          ),
                        ),
                      ),SizedBox(width: 15,),
                      SizedBox(width: w*0.05 ,),
                      textLeftRubik('Messages', darkTextColor, w600, size25),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: w*0.05),
                    child: InkWell(
                      onTap:(){
                        navigateWithTransition(context,ArchivedChats(), TransitionType.slideRightToLeft);
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          textLeftRubik('Archived', darkTextColor, w500, size18),
                          SizedBox(width: 5,),
                          Icon(Icons.archive_outlined,color: primaryColor,)
                        ],
                      ),
                    ),
                  )
                ],
              ),

              SizedBox(height: 20,),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance.collection('Chats')
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
                    final unFilteredDocs = snapshot.data!.docs;
                    var docs = unFilteredDocs.where((doc) {
                      var data = doc.data() as Map<String, dynamic>;
                      return data['combinedUid'].toString().contains(FirebaseAuth.instance.currentUser!.uid) &&
                            data['archived']=='false';
                      ;
                    }).toList();
                    return
                      docs.length==0?
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 50,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(CupertinoIcons.arrow_turn_down_right,size: 18,),
                              textRoboto('Nothing to show!', lightTextColor, w400, size17)
                            ],
                          )
                        ],
                      ):
                      ListView.builder(itemBuilder: (context,index){
                        var data = docs[index]!.data();
                        return GestureDetector(
                            onLongPress: (){
                              showDialog(context: context, builder: (context){
                                return StatefulBuilder(
                                  builder: (BuildContext context,  StateSetter setstate) {
                                    return  Dialog(

                                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                       backgroundColor: white,
                                       child:
                                       Container(
                                         width: 150,
                                         height: 120,
                                         decoration: BoxDecoration(
                                             color: white,
                                             borderRadius: BorderRadius.circular(12)
                                         ),
                                         alignment: AlignmentDirectional.center,
                                         child: isArchiving?Center(child: CircularProgressIndicator(color:primaryColor),): Column(
                                         mainAxisSize: MainAxisSize.min,
                                           crossAxisAlignment: CrossAxisAlignment.center,
                                           mainAxisAlignment: MainAxisAlignment.center,
                                           children: [
                                             Padding(
                                               padding: EdgeInsets.symmetric(horizontal: 8,vertical: 3),
                                               child: textCenter('Archive this chat?', darkTextColor, w500, size18),
                                             ),
                                             SizedBox(height: 8,),
                                             Row(
                                               crossAxisAlignment: CrossAxisAlignment.center,
                                               mainAxisAlignment: MainAxisAlignment.center,
                                               children: [
                                                 InkWell(
                                                     onTap:()async{
                                                       try{
                                                           setstate(() {
                                                             isArchiving = true;
                                                           });
                                                         await FirebaseFirestore.instance.collection('Chats').doc(data['docId']).update(
                                                             {'archived':'true'}).then((value) {
                                                           setstate(() {
                                                             isArchiving = false;
                                                           });
                                                           Navigator.pop(context);
                                                         });
                                                       }catch(e){
                                                         setstate(() {
                                                           isArchiving = false;
                                                         });
                                                         Navigator.pop(context);

                                                         print(e.toString());
                                                       }
                                                     },
                                                     child: textCenter('Confirm', primaryColor, w400, size15)),
                                                 SizedBox(width: 8,),
                                                 textCenter('|', lightTextColor, w400, size15),
                                                 SizedBox(width: 8,),
                                                 InkWell(
                                                     onTap:(){Navigator.pop(context);},
                                                     child: textCenter('Cancel', darkTextColor, w400, size15)),
                                               ],
                                             )
                                           ],
                                         ),
                                       ),
                                     );
                                  },
                                );
                              },);
                            },
                          onTap:(){
                            if(data['receiverUid']==FirebaseAuth.instance.currentUser!.uid){
                              navigateWithTransition(context, ChatScreen(user2Uid: data['senderUid']), TransitionType.slideRightToLeft);
                            }
                            else{
                              navigateWithTransition(context, ChatScreen(user2Uid: data['receiverUid']), TransitionType.slideRightToLeft);
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 6),
                            child: Padding(
                                  padding:  EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                          Row(
                                  children: [
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
                                                child:  Image.network(data['senderProfileImage']==''?
                                                'data:image/png;base64,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'
                                                    :data['senderProfileImage'],fit: BoxFit.cover,),
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
                                          child: Image.network(data['senderProfileImage']==''?
                                          'data:image/png;base64,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'
                                              :data['senderProfileImage'],fit: BoxFit.cover,),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [

                                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                                  stream:

                                                  isMe(data['senderUid'])?
                                                  FirebaseFirestore.instance.collection('Users').where('uid',isEqualTo:data['receiverUid']).limit(1)
                                                      .snapshots():
                                                  FirebaseFirestore.instance.collection('Users').where('uid',isEqualTo:data['senderUid']).limit(1)
                                                      .snapshots()
                                          ,
                                                  builder: (context, snapshot) {
                                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                                  return  Container(
                                                    width: 25,
                                                    height: 25,
                                                    child: Center(
                                                    child: CircularProgressIndicator(color: primaryColor,),
                                                    ),
                                                  );
                                                  } else if (snapshot.hasError) {
                                                  return Text('Error: ${snapshot.error}');
                                                  } else {
                                                  final docs = snapshot.data!.docs;
                                                  final data = docs[0].data();
                                                  return     textRoboto(data['firstName']+' '+data['lastName'], darkTextColor, w500, size17);

                                                  }}),

                                        textRoboto(data['lastMessage'], !isMe(data['senderUid'])?darkTextColor:lightTextColor,!isMe(data['senderUid'])? w500:w400, size17),
                                      ],
                                    )
                                  ],
                                ),
                          textRoboto(data['time'], darkTextColor, w400, size17),

                      ],
                    ),
                  ),
                ),
                        );
              },itemCount: docs.length,shrinkWrap: true,physics: NeverScrollableScrollPhysics(),);
                  }
                }
                )

            ],
          ),
        ),
      )
    );
  }

  bool isMe(String userUid){
    return FirebaseAuth.instance.currentUser!.uid == userUid;
  }
}
