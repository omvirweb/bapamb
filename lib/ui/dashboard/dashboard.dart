import 'package:flutter/material.dart';
import 'package:jewelbook_calculator/ui/login_screen/login_screen.dart';
import 'package:jewelbook_calculator/ui/mobile_scanner/qr_code_scanner.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: _qrCodeScanButton(context),
      drawer: _buildDrawer(context),
    );
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
              Scaffold.of(context).openDrawer(); // Open the drawer
            },
            child: const Icon(
              Icons.menu_rounded,
              size: 25,
              color: Colors.black,
            ),
          );
        },
      ),
      title: const Text(
        'JewelBook Bapa',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 18,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _qrCodeScanButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => qrCodeScanner()),
          );
        },
        child: const Text('Scan QR Code'),
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        // padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Image.asset('assets/images/app_icon.png'),
                  ),
                ),
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'Version : 1.0',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10), // Optional: Change text color
                  ),
                )
              ],
            ),
          ),

          ListTile(
            leading: const Icon(Icons.home_filled),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pop(context);
              // Get.to(const Dashboard());
            },
          ),
          // ListTile(
          //   leading: const Icon(Icons.group_add_rounded),
          //   title: const Text('Saving Scheme'),
          //   onTap: () {
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => savingSchemeScreen(),
          //         ));
          //     // Get.to(IssueItemScreen());
          //   },
          // ),
          // ListTile(
          //   leading: const Icon(Icons.group_add_rounded),
          //   title: const Text('Join Saving Scheme'),
          //   onTap: () {
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => savingSchemeJoinScreen(),
          //         ));
          //     // Get.to(IssueItemScreen());
          //   },
          // ),

          // ListTile(
          //   leading: const Icon(Icons.group_add_rounded),
          //   title: const Text('My Home Page'),
          //   onTap: () {
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => MyHomePage(),
          //         ));
          //     // Get.to(IssueItemScreen());
          //   },
          // ),

          Expanded(child: Container()),
          const Divider(), // Divider to separate the logout option
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
