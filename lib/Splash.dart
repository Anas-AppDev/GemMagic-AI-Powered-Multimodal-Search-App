import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gemini2/Home.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  var lottieCtrl;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 4), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Home()));
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(Color(0xFF0B2757), BlendMode.color),
            child: Lottie.asset("assets/lottie/spaceSplash.json",
                height: double.infinity,
                width: double.infinity,
                repeat: true,
                fit: BoxFit.fill),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 300.h,
                ),
                Shimmer.fromColors(
                  baseColor: Color(0xff666666),
                  highlightColor: Color(0xFFe1e1e1),
                  direction: ShimmerDirection.ltr,
                  period: Duration(milliseconds: 5000),
                  child: Text(
                    "Gemini",
                    style: TextStyle(
                        fontSize: 45.sp,
                        fontFamily: "poppinsRegular",
                        color: Colors.white,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 200.h,
                ),
                Image.asset("assets/images/robot.png", height: 280.h,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
