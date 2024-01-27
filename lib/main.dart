import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gemini2/Home.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'Splash.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();

  var deviceIds = ["48E0041DFD6567F7509C3B093E447BDD"];
  RequestConfiguration requestConfiguration = RequestConfiguration(
    testDeviceIds: deviceIds,
  );
  MobileAds.instance.updateRequestConfiguration(requestConfiguration);


  runApp(
    ScreenUtilInit(
        designSize: const Size(430, 932),
        builder: (_ , child) {
          return MaterialApp(
            home: Splash(),
            debugShowCheckedModeBanner: false,
          );
        }
    ),
  );
}