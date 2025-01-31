import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:jewelbook_calculator/ui/dashboard/dashboard.dart';
// import 'package:jewelbook_calculator/ui/otp_screen/otp_controller.dart';
import 'package:jewelbook_calculator/widget/DefaultButton.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _appBar(context),
        body:
            // GetBuilder<OTPController>(builder: (controller) {
            //   return
            Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 200,
                    height: 150,
                    child: Image.asset('assets/images/app_icon.png'),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'We have sent a verification code to your mobile number.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 40,
                    child: TextField(
                      // controller: controller.otpControllers[index],
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          FocusScope.of(context).nextFocus();
                        }
                        if (index == 5) {
                          FocusScope.of(context).unfocus();
                        }
                      },
                    ),
                  );
                }),
              ),
              // const SizedBox(height: 20),
              // Obx(() {
              //   // if (controller.start.value > 0) {
              //   //   return Text(
              //   //     "Didn't get the OTP code? ${controller.start.value}s",
              //   //     style: TextStyle(color: Colors.grey),
              //   //   );
              //   // } else {
              //   return InkWell(
              //     onTap: () {
              //       // controller.resendOTP();
              //     },
              //     child: const Text(
              //       "Didn't get the OTP code? Resend OTP",
              //       style: TextStyle(color: Colors.grey),
              //     ),
              //   );
              // }),
              const SizedBox(height: 40),
              DefaultButton(
                text: "Verify OTP",
                press: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Dashboard(),
                    ),
                    (route) => false,
                  );
                },
              )
            ],
          ),
        ));
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      elevation: 10.0,
      backgroundColor: Colors.white,
      titleSpacing: 0,
      leading: Builder(
        builder: (context) {
          return InkWell(
            onTap: () {
              // Get.back();
            },
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 25,
            ),
          );
        },
      ),
      title: const Text(
        'Enter Verification Code',
        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
      ),
    );
  }
}
