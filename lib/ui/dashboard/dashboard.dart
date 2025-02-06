import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jewelbook_calculator/ui/login_screen/login_screen.dart';
import 'package:jewelbook_calculator/ui/mobile_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove('isLoggedIn');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  bool _onWillPop(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content:
              const Text('Are you sure you want to leave this Application?'),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'No',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Yes', style: TextStyle(color: Colors.green)),
              onPressed: () {
                //application closed using this one navigator.
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
            ),
          ],
        );
      },
    );
    return false; // Prevent the default back button behavior
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        print("Showing alert dialog");
        _onWillPop(context);
      },
      child: Scaffold(
        appBar: _appBar(context),
        body: _qrCodeScanButton(context),
        drawer: _buildDrawer(context),
      ),
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
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 5,
          shadowColor: Colors.black26,
          backgroundColor: Colors.deepOrange[900],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.qr_code_scanner, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'Scan QR Code',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
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

          Expanded(child: Container()),
          const Divider(), // Divider to separate the logout option
          ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            logout(context);
                          },
                          child: const Text(
                            'Yes',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'No',
                            style: TextStyle(
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }),
        ],
      ),
    );
  }
}
