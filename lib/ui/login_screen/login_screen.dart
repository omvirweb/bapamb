import 'package:flutter/material.dart';
import 'package:jewelbook_calculator/ui/otp_screen/otp_screen.dart';
import 'package:jewelbook_calculator/widget/DefaultButton.dart';

// import 'login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // return GetBuilder<LoginController>(builder: (controller) {
    return Scaffold(
        body: Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus(); // Close the keyboard
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 80),
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
                const SizedBox(height: 50),
                const Text(
                  "We've been awaiting you",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                const TextField(
                  // controller: controller.mobilenumber,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  decoration: InputDecoration(
                    labelText: 'Enter Mobile Number',
                    border: OutlineInputBorder(),
                    counterText: "",
                  ),
                ),
                const SizedBox(height: 20),
                DefaultButton(
                  text: "Get OTP",
                  press: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OtpScreen(),
                      ),
                      (route) => false,
                    );
                  },
                ),
                // const SizedBox(height: 20),
                // GestureDetector(
                //   onTap: () {
                //     Navigator.pushAndRemoveUntil(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => const register(),
                //       ),
                //       (route) => false,
                //     );
                //   },
                //   child: MouseRegion(
                //     cursor: SystemMouseCursors.click, // Change cursor on hover
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         const Icon(
                //           Icons.person_add_alt,
                //           size: 18,
                //         ),
                //         const SizedBox(width: 5),
                //         Text(
                //           "Create an Account",
                //           style: TextStyle(
                //             fontSize: 14, // Slightly larger text
                //             fontWeight: FontWeight.bold,
                //             color: Colors.black,
                //             shadows: [
                //               Shadow(
                //                 blurRadius: 2.0,
                //                 color: Colors.black.withOpacity(
                //                     0.2), // Subtle shadow for depth
                //                 offset: const Offset(1.0, 1.0),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
