import 'package:asaanmakaan/Constants/Color.dart';
import 'package:flutter/material.dart';

import '../../../Constants/FontSizes.dart';
import '../../../Constants/FontWeights.dart';
import '../../../Utils/Text.dart';

class TermsAndPrivacy extends StatelessWidget {
  const TermsAndPrivacy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w*0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: h*0.06,),
              Row(
                children: [
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
                  textLeftRubik('Terms & Privacy', darkTextColor, w600, size25),
                ],
              ),
              SizedBox(height: 20,),
              textRoboto('Terms of Service', darkTextColor, w500, size18),
              SizedBox(height: 10,),
              textLeftRubik('Welcome to Asaan Makaan, the real estate app that makes listing and finding properties easy and convenient. By accessing or using our app, you agree to comply with these Terms of Service. Please read them carefully.', lightTextColor, w400, size15),

              SizedBox(height: 12,),

              Container(
                width: w,
                child: textLeftRubik("Acceptance of Terms: By using Asaan Makaan, you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use the app.Use of the App: Asaan Makaan grants you a limited, non-exclusive, non-transferable, and revocable license to use the app for its intended purpose.User Accounts: You may be required to create an account to access certain features of the app. You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account.Listing Properties: Users are solely responsible for the accuracy and legality of the properties they list on Asaan Makaan. By listing a property, you represent and warrant that you have the authority to do so and that all information provided is true and accurate.Viewing Properties: Users may view properties listed on Asaan Makaan for personal, non-commercial use only. Any use of the app for commercial purposes is strictly prohibited.Contacting Users: Users may contact each other through the app regarding listed properties. However, users agree to use this feature responsibly and to comply with all applicable laws and regulations.Intellectual Property: Asaan Makaan and its content, including but not limited to text, graphics, logos, and images, are the property of Asaan Makaan or its licensors and are protected by copyright and other intellectual property laws.Third-Party Links: Asaan Makaan may contain links to third-party websites or services that are not owned or controlled by Asaan Makaan. We assume no responsibility for the content, privacy policies, or practices of any third-party websites or services.Modifications to the Terms: Asaan Makaan reserves the right to modify or revise these Terms of Service at any time. By continuing to use the app after such changes are made, you agree to be bound by the revised terms.Termination: Asaan Makaan reserves the right to terminate or suspend your access to the app at any time, with or without cause and without prior notice.Governing Law: These Terms of Service shall be governed by and construed in accordance with the laws of government, without regard to its conflict of law provisions.Contact Us: If you have any questions about these Terms of Service, please contact us at zakriyamateen3@gmail.com.",
                    lightTextColor,w300, size12),
              ),

              SizedBox(height: 20,),
              textRoboto('Privacy Policies', darkTextColor, w500, size18),
              SizedBox(height: 10,),
              textLeftRubik('At Asaan Makaan, we are committed to protecting your privacy. This Privacy Policy explains how we collect, use, and disclose information about you when you use our app.', lightTextColor, w400, size15),

              SizedBox(height: 12,),

              Container(
                width: w,
                child: textLeftRubik("Information We Collect: We may collect personal information such as your name, email address, and phone number when you create an account on Asaan Makaan. We also collect information about the properties you list or view on the app.How We Use Your Information: We may use the information we collect to provide, maintain, and improve the app, to communicate with you about your account or listings, and to personalize your experience. We may also use your information to send you promotional emails or messages about new features or properties that may be of interest to you.Information Sharing: We may share your information with third-party service providers who assist us in operating the app or conducting our business. We may also share your information in response to a legal request or if we believe it is necessary to protect the rights, property, or safety of Asaan Makaan, our users, or others.Data Security: We take reasonable measures to protect the information we collect from unauthorized access, disclosure, alteration, or destruction. However, no method of transmission over the internet or electronic storage is 100% secure, and we cannot guarantee the absolute security of your information.Children's Privacy: Asaan Makaan is not intended for use by children under the age of 13, and we do not knowingly collect personal information from children under the age of 13. If you are a parent or guardian and believe that your child has provided us with personal information, please contact us.Changes to This Policy: We may update this Privacy Policy from time to time. If we make material changes to this policy, we will notify you by email or by posting a notice on the app prior to the changes taking effect.Contact Us: If you have any questions about this Privacy Policy, please contact us at zakriyamateen3@gmail.com.",
                    lightTextColor,w300, size12),
              ),
              SizedBox(height:40),
            ],
          ),
        ),
      )
    );
  }
}
