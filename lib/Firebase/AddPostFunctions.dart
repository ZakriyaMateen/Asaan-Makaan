
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<void> postAdd({
  required var provider,
  required String location,
  required var phoneController,
  required var emailController,
  required var descriptionController,
  required var titleController,
  required var plotNumberController,
  required var priceController,
  required var areaController,
  required BuildContext context
})async {

    try {
        provider.updateIsUploading(true);

      if (provider.images.isNotEmpty) {
        for (var image in provider.images) {
          try {
            String fileName = DateTime.now().millisecondsSinceEpoch.toString();
            Reference storageRef = FirebaseStorage.instance.ref().child( 'images/$fileName');
            if (kIsWeb) {
              Uint8List imageData = await XFile(image!.path).readAsBytes();
              await storageRef.putData(imageData, SettableMetadata(contentType: 'image/jpeg'));
              final imageUrl = await storageRef.getDownloadURL();
              provider.imageUrls.add(imageUrl);
            } else {
              var x = await storageRef.putFile(image!);
              String imageUrlMobile = await x.ref.getDownloadURL();
              provider.imageUrls.add(imageUrlMobile);
            }
          } catch (e) {print('Error uploading image: $e');}
        }

        CollectionReference rootRef = await FirebaseFirestore.instance.collection(provider.selectedCity);

        CollectionReference typeRef = await rootRef.doc(provider.propertyTypeOption).collection(provider.propertyTypeOption);

        CollectionReference cityRef = await typeRef.doc(provider.purposeOptionSelected).collection(provider.purposeOptionSelected);

     DocumentReference reference =   await cityRef.add(
            {
              'timestamp': FieldValue.serverTimestamp(),
              'purpose': provider.purposeOptionSelected,
              'propertyTypeOption': provider.propertyTypeOption,
              'city': provider.selectedCity,
              'homesPlotsCommercial': provider.propertyTypeOption == 'Homes' ? provider.propertyTypeOptionHomesSelected :
              provider.propertyTypeOption == 'Plots' ? provider.propertyTypeOptionPlotsSelected : provider.propertyTypeOption == 'Commercial' ? provider.propertyTypeOptionCommercialSelected : 'null',
              'location': location,
              'plotNumber': plotNumberController.text.toString(),
              'area': areaController.text.toString(),
              'areaType': provider.areaType,
              'totalPrice': priceController.text.toString(),
              'readyForPossession': provider.possessionSwitchVal.toString(),
              'bedrooms': provider.propertyTypeOption != 'Homes' ? 'null' : provider.bedroom,
              'bathrooms': provider.propertyTypeOption != 'Homes' ? 'null' : provider.bathroom,
              'propertyTitle': titleController.text.toString(),
              'propertyDescription': descriptionController.text.toString(),
              'images': provider.imageUrls,
              'displayImage': provider.imageUrls[0],
              'phone': phoneController.text.toString(),
              'email':emailController.text.toString(),
              'uid':FirebaseAuth.instance.currentUser!.uid

            });

        DocumentReference ref = await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).collection('MyProperties').add( {
          'timestamp': FieldValue.serverTimestamp(),
          'purpose': provider.purposeOptionSelected,
          'propertyTypeOption': provider.propertyTypeOption,
          'city': provider.selectedCity,
          'homesPlotsCommercial': provider.propertyTypeOption == 'Homes' ? provider.propertyTypeOptionHomesSelected : provider.propertyTypeOption == 'Plots' ? provider.propertyTypeOptionPlotsSelected : provider.propertyTypeOption == 'Commercial' ? provider.propertyTypeOptionCommercialSelected : 'null',
          'location': location,
          'plotNumber': plotNumberController.text.toString(),
          'area': areaController.text.toString(),
          'areaType': provider.areaType,
          'totalPrice': priceController.text.toString(),
          'readyForPossession': provider.possessionSwitchVal.toString(),
          'bedrooms': provider.propertyTypeOption != 'Homes' ? 'null' : provider.bedroom,
          'bathrooms': provider.propertyTypeOption != 'Homes' ? 'null' : provider.bathroom,
          'propertyTitle': titleController.text.toString(),
          'propertyDescription': descriptionController.text.toString(),
          'images': provider.imageUrls,
          'uid':FirebaseAuth.instance.currentUser!.uid,
          'email':emailController.text.toString(),
          'likedBy':[],
          'displayImage': provider.imageUrls[0],
          'phone': phoneController.text.toString(),
        });

        await ref.update({
          'docId':ref.id,
          'listingDocId':reference.id
        });

      await reference.update({
        'docId':reference.id
      }).then((value) {

        provider.resetAll();
        provider.updateIsUploading(false);
        provider.updateIsSuccess(true);

      });

      }

      else {

        CollectionReference rootRef = await FirebaseFirestore.instance.collection(provider.selectedCity);

        CollectionReference typeRef = await rootRef.doc(provider.propertyTypeOption).collection(provider.propertyTypeOption);

        CollectionReference cityRef = await typeRef.doc(provider.purposeOptionSelected).collection(provider.purposeOptionSelected);


        DocumentReference reference1=
        await cityRef.add(
            {
              'timestamp': FieldValue.serverTimestamp(),
              'purpose': provider .purposeOptionSelected,
              'propertyTypeOption': provider .propertyTypeOption,
              'city': provider.selectedCity,
              'homesPlotsCommercial': provider.propertyTypeOption == 'Homes'? provider.propertyTypeOptionHomesSelected: provider.propertyTypeOption == 'Plots' ? provider .propertyTypeOptionPlotsSelected :provider.propertyTypeOption ==    'Commercial'? provider .propertyTypeOptionCommercialSelected: 'null',
              'location': location,
              'plotNumber': plotNumberController.text.toString(),
              'area': areaController.text.toString(),
              'areaType': provider.areaType,
              'totalPrice': priceController.text.toString(),
              'readyForPossession': provider.possessionSwitchVal.toString(),
              'bedrooms': provider.propertyTypeOption != 'Homes'? 'null': provider.bedroom,
              'bathrooms': provider.propertyTypeOption != 'Homes'? 'null': provider.bathroom,
              'propertyTitle': titleController.text.toString(),
              'propertyDescription': descriptionController.text.toString(),
              'images': [],
              'uid':FirebaseAuth.instance.currentUser!.uid,
              'email':emailController.text.toString(),
              'displayImage': 'data:image/jpeg;base64,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',
              'phone': phoneController.text.toString(),
              'likedBy':[],
            });
        DocumentReference ref = await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).collection('MyProperties').add( {
          'timestamp': FieldValue.serverTimestamp(),
          'purpose': provider.purposeOptionSelected,
          'propertyTypeOption': provider.propertyTypeOption,
          'city': provider.selectedCity,
          'homesPlotsCommercial': provider.propertyTypeOption == 'Homes'? provider.propertyTypeOptionHomesSelected:provider.propertyTypeOption == 'Plots'  ? provider.propertyTypeOptionPlotsSelected :provider.propertyTypeOption =='Commercial'? provider.propertyTypeOptionCommercialSelected: 'null',
          'location': location,
          'plotNumber': plotNumberController.text.toString(),
          'area': areaController.text.toString(),
          'areaType': provider.areaType,
          'totalPrice': priceController.text.toString(),
          'readyForPossession': provider.possessionSwitchVal.toString(),
          'bedrooms': provider.propertyTypeOption != 'Homes'? 'null': provider.bedroom,
          'bathrooms': provider .propertyTypeOption != 'Homes'? 'null': provider.bathroom,
          'propertyTitle': titleController.text.toString(),
          'propertyDescription': descriptionController.text.toString(),
          'uid':FirebaseAuth.instance.currentUser!.uid,
          'email':emailController.text.toString(),
          'images': provider.imageUrls,
          'likedBy':[],
          'displayImage': provider.imageUrls[0],
          'phone': phoneController.text.toString(),
        });

        await ref.update({
          'docId':ref.id,
          'listingDocId':reference1.id
        });

        await reference1.update({
          'docId':reference1.id
        }).then((value) {
          provider.resetAll();
          provider.updateIsUploading(false);
          provider.updateIsSuccess(true);

        });
      }

    }
    catch (e) {
      print(e.toString());
      print('could not  ');
      provider.updateIsUploading(false);
      provider.updateIsSuccess(false);

    }
}