import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jewelbook_calculator/routes/app_pages.dart';
import 'package:jewelbook_calculator/utils/size_config.dart';
import 'package:jewelbook_calculator/utils/utils.dart';

void main() async {
  await registerServices();
  await registerControllers();
  await getDeviceId();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return GetMaterialApp(
      title: 'JewelBook Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          useMaterial3: true,
          textTheme: GoogleFonts.poppinsTextTheme()),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}
