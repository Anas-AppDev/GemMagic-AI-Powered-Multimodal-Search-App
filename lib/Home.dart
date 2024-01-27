import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gemini2/Typer.dart';
import 'package:google_gemini/google_gemini.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_corner/smooth_corner.dart';
import 'package:google_gemini/src/models/config/gemini_safety_settings.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var promptCtrl = TextEditingController();

  var geminiInit = GoogleGemini(apiKey: "AIzaSyBJfj7HtrxmOu3AGvUdp7d12GHJWVi89Rk");

  var loading = false;
  File? imgFile;
  var scrollCtrl = ScrollController();
  List chatList = [];

  void sendImg({required String query, required File image}) {
    setState(() {
      loading = true;
      chatList.add({
        "role": "User",
        "text": query,
        "image": image,
      });
      promptCtrl.clear();
      scrollToTheEnd();
    });


    geminiInit.generateFromTextAndImages(query: query, image: image).then((value) {
      setState(() {
        loading = false;
        chatList.add({"role": "Gemini", "text": value.text, "image": ""});
        scrollToTheEnd();
      });
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
        chatList.add({"role": "Gemini", "text": error.toString(), "image": ""});
        scrollToTheEnd();
      });
    });
  }

  void sendTxt({required String query}) {
    setState(() {
      loading = true;
      chatList.add({
        "role": "User",
        "text": query,
        "image": "",
      });
      promptCtrl.clear();
      scrollToTheEnd();
    });

    geminiInit.generateFromText(query).then((value) {
      setState(() {
        loading = false;
        chatList.add({"role": "Gemini", "text": value.text, "image": ""});
        scrollToTheEnd();
      });
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
        chatList.add({"role": "Gemini", "text": error.toString(), "image": ""});
        scrollToTheEnd();
      });
    });
  }

  void getImage({required ImageSource source}) async{

    var pickedImg = await ImagePicker().pickImage(source: source);

    if (pickedImg != null){
      setState(() {
        imgFile = File(pickedImg.path);
      });
    }
    else{
      print("Pick an image");
    }
  }

  void scrollToTheEnd() {
    if (scrollCtrl.hasClients) {
      scrollCtrl.animateTo(
        scrollCtrl.position.maxScrollExtent,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }


  var sampleBanner = "ca-app-pub-3940256099942544/6300978111";
  var sampleInterstitial = "ca-app-pub-3940256099942544/1033173712";
  var actualBanner = "ca-app-pub-8307889997080678/5124291984";
  var actualInterstitial = "ca-app-pub-8307889997080678/8750306688";


  late BannerAd bannerAd;
  bool isBannerLoaded = false;


  late InterstitialAd interstitialAd;
  bool isInterstitialLoaded = false;

  var adUnitBanner;
  var adUnitInterstitial;

  void initInterestitialAd() async{
    await InterstitialAd.load(
      adUnitId: adUnitInterstitial,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad){

            if (mounted){
              setState(() {
                print("interestitial loaded");
                interstitialAd = ad;
                isInterstitialLoaded = true;
              });
            }

          },
          onAdFailedToLoad: (err){
            if (mounted){
              setState(() {
                print("interestitial error");
                print(err.toString());
                interstitialAd.dispose();
                isInterstitialLoaded = false;
              });
            }
          }
      ),
    );
  }
  void initBannerAd() async{
    bannerAd = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: adUnitBanner,
      request: AdRequest(),
      listener: BannerAdListener(
          onAdLoaded: (ad){
            if (mounted){
              setState(() {
                print("banner loaded");
                isBannerLoaded = true;
              });
            }
          },
          onAdClosed: (ad){

            if (mounted){
              setState(() {
                print("banner closed");
                ad.dispose();
                isBannerLoaded = false;
              });
            }

          },
          onAdFailedToLoad: (ad, err){

            if (mounted) {
              setState(() {
                print("banner error");
                print(err.toString());
                ad.dispose();
                isBannerLoaded = false;
              });
            }
          }
      ),
    );

    await bannerAd.load();
  }


  @override
  void initState() {
    super.initState();

    adUnitBanner = Platform.isAndroid ? sampleBanner : "ca-app-pub-3940256099942544/2934735716";
    adUnitInterstitial = Platform.isAndroid ? sampleInterstitial : "ca-app-pub-3940256099942544/4411468910";


    initBannerAd();
    initInterestitialAd();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }


      },
      child: Scaffold(
        extendBody: true,
        // bottomNavigationBar: isBannerLoaded ? SizedBox(
        //   height: 60.h,
        //   width: double.infinity,
        //   child: AdWidget(ad: bannerAd,),
        // ) : Container(height: 60.h,),
        body: Stack(
          children: [
            Image.asset("assets/images/background2.png", height: double.infinity, width: double.infinity, fit: BoxFit.fill,),
            Lottie.asset("assets/lottie/stars.json",
                height: double.infinity,
                width: double.infinity,
                repeat: true,
                fit: BoxFit.fill),
            Lottie.asset("assets/lottie/stars.json",
                height: 400.h,
                width: 400.w,
                repeat: true,
                fit: BoxFit.cover),
            Lottie.asset("assets/lottie/stars.json",
                height: 600.h,
                width: 600.w,
                repeat: true,
                fit: BoxFit.scaleDown),
            Positioned(
              bottom: -25.h,
              child: Lottie.asset("assets/lottie/stars.json",
                  height: 400.h,
                  width: 400.w,
                  repeat: true,
                  fit: BoxFit.cover),
            ),
            Container(
              width: double.infinity,
              height: double.infinity,
              padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 60.h, bottom:70.h),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 20.h, left: 12.w, right: 12.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset('assets/svgs/geminiLogo.svg', height: 30.h,),
                        Text(
                          "Gemini",
                          style: TextStyle(
                            fontSize: 23.sp,
                            fontFamily: "poppinsRegular",
                            color: Colors.white,
                            letterSpacing: 1,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            setState(() {
                              imgFile=null;
                              chatList.clear();

                              HapticFeedback.heavyImpact();
                            });
                          },
                            child: Icon(CupertinoIcons.add, color: Colors.white, size: 27.r,),
                        ),

                      ],
                    ),
                  ),
                  Expanded(
                      child: chatList.isNotEmpty ? SingleChildScrollView(
                        controller: scrollCtrl,
                        child: Container(
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            // controller: scrollCtrl,
                            itemCount: chatList.length,
                            padding: EdgeInsets.only(bottom:80.h),
                            itemBuilder: (context, index) {
                              return InkWell(
                                onLongPress: (){
                                  String message = chatList[index]["text"];
                                  FlutterClipboard.copy(message).then((_) {
                                    toast(context);
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 14.h),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: chatList[index]["role"] == "User" ? MainAxisAlignment.end : MainAxisAlignment.start, // Align bot/Gemini messages to the left
                                    children: [
                                      chatList[index]["role"] == "User" ? SizedBox.shrink() : CircleAvatar(backgroundColor: Colors.white, child: SvgPicture.asset("assets/svgs/geminiLogo.svg", height: 30.h,),),
                                      chatList[index]["role"] == "User" ? SizedBox() : SizedBox(width: 10.w),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                                        decoration: ShapeDecoration(
                                          shape: SmoothRectangleBorder(
                                            borderRadius:  chatList[index]["role"] == "User" ? BorderRadius.only(bottomLeft: Radius.circular(25.r), topLeft: Radius.circular(25.r), topRight: Radius.circular(25.r), ) : BorderRadius.only(topLeft: Radius.circular(25.r), bottomRight: Radius.circular(25.r), topRight: Radius.circular(25.r), ),
                                            smoothness: 1
                                          ),
                                          gradient: chatList[index]["role"] == "User" ? LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Color(0xffFFFFFF),
                                              Color(0xffFFFFFF),
                                            ],
                                            // stops: [0.4,1],
                                          ) : LinearGradient(
                                            begin: Alignment.bottomLeft,
                                            end: Alignment.topRight,
                                            colors: [
                                              Color(0xffbad7ff),
                                              Color(0xffE7EFFF),
                                              Color(0xffE1DCDB),
                                            ],
                                            stops: [0.2,0.8,1],
                                          ),
                                        ),
                                        child: chatList[index]["image"] == ""
                                            ? ConstrainedBox(
                                            constraints: BoxConstraints(maxWidth: 230.w),
                                            child: chatList[index]["role"] == "User" ? Shimmer.fromColors(
                                            baseColor: Color(0xff047CFB),
                                            highlightColor: Color(0xFFFFB15E),
                                            direction: ShimmerDirection.ltr,
                                            period: Duration(milliseconds: 20000),
                                            child: Text(chatList[index]["text"], style: TextStyle(fontFamily: "poppinsRegular", fontSize: 13.sp),),)
                                                :
                                                Typer(text: chatList[index]['text']),
                                            // AnimatedTextKit(
                                            //   animatedTexts: [
                                            //     TyperAnimatedText(chatList[index]['text'],
                                            //       textStyle: TextStyle(fontFamily: "poppinsRegular", color: Color(0xff353535), fontSize: 13.sp),
                                            //       speed: Duration(milliseconds: 10),
                                            //     ),
                                            //   ],
                                            //   totalRepeatCount: 1,
                                            //   isRepeatingAnimation: false,
                                            //   repeatForever: false,
                                            //   displayFullTextOnTap: false,
                                            //   stopPauseOnTap: false,
                                            // )
                                        ) : Column(
                                          children: [
                                            ConstrainedBox(constraints: BoxConstraints(maxWidth: 230.w),child: SmoothClipRRect(
                                                smoothness: 1,
                                                borderRadius: BorderRadius.circular(14.r),
                                                child: Image.file(chatList[index]["image"], height: 180.h, width: 230.w ,fit: BoxFit.cover,))),
                                            SizedBox(height: 10.h,),
                                            ConstrainedBox(constraints: BoxConstraints(maxWidth: 230.w),child: Align(alignment: Alignment.topRight, child: Shimmer.fromColors(
                                                baseColor: Color(0xff047CFB),
                                                highlightColor: Color(0xFFFFB15E),
                                                direction: ShimmerDirection.ltr,
                                                period: Duration(milliseconds: 10000),
                                                child: Text(chatList[index]["text"], style: TextStyle(fontSize: 13.sp, fontFamily: "poppinsRegular"),),
                                            ),
                                            ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      chatList[index]["role"] == "User" ? SizedBox(width: 10.w) : SizedBox(),
                                      chatList[index]["role"] == "User" ? CircleAvatar(backgroundColor: Colors.white,backgroundImage: AssetImage("assets/images/avatar.png"),) : SizedBox.shrink(), // Empty space to align bot/Gemini messages
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ) : Transform.scale(
                        scale: 1.75.w,
                        child: Lottie.asset("assets/lottie/center.json",
                            repeat: true,
                        ),
                      ),
                  ),
                  loading==true ? Container(margin: EdgeInsets.only(top: 55.h),) : Container(
                    margin: EdgeInsets.only(top: 10.h),
                    child: Row(

                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SmoothContainer(
                            borderRadius: BorderRadius.circular(14.r),
                            smoothness: 1,
                            side: BorderSide(color: Color(0xFFf8f8f8), width: 1.w),
                            alignment: Alignment.center,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  // height: 47,
                                  // width: 45,
                                  child: imgFile!=null ? Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      Container(
                                        height: 35.h,
                                        width: 35.w,
                                        margin: EdgeInsets.only(left: 5.w),
                                        child: Opacity(
                                          opacity: .6,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8.r),
                                            child: Image.file(imgFile ?? File(""), fit: BoxFit.fill,),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 5.w),
                                        child: IconButton(onPressed: (){
                                          setState(() {
                                            imgFile=null;
                                            HapticFeedback.heavyImpact();
                                          });
                                        }, icon: Icon(CupertinoIcons.xmark, color: Colors.white, size: 20.r,)),
                                      ),
                                    ],
                                  ) :

                                  Container(
                                    margin: EdgeInsets.only(left: 6.w),
                                    child: IconButton(
                                      onPressed: (){
                                        setState(() {
                                          bottomSheet(context);
                                          HapticFeedback.heavyImpact();
                                          });
                                        },
                                      icon: Transform.scale(scale: 1.6.w,child: SvgPicture.asset("assets/svgs/camera nofill.svg", color: Color(0xFFf8f8f8), height: 20.h,)),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    style: TextStyle(
                                      color: Color(0xFFf8f8f8),
                                      letterSpacing: .2
                                    ),
                                    controller: promptCtrl,
                                    minLines: 1,
                                    maxLines: null,
                                    keyboardType: TextInputType.multiline,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h, bottom: 13.h),
                                      hintText: "Ask me anything ...",
                                      hintStyle: TextStyle(
                                        fontSize: 15.sp,
                                        color: Color(0xFFf8f8f8),
                                        fontFamily: "poppinsLight",
                                        // letterSpacing: 1
                                      ),
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (value) {
                                      setState(() {

                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        (promptCtrl.text.length>=1) ? Container(
                          height: 50.h,
                          margin: EdgeInsets.only(left: 10.w),
                          decoration: ShapeDecoration(
                            shape: SmoothRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                              smoothness: 1,
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              colors: [
                                Color(0xfff1f1f1),
                                Color(0xfffcfcfc),
                              ],
                              stops: [0.5,1],

                            ),
                          ),
                          child: IconButton(
                            onPressed: (){
                              HapticFeedback.heavyImpact();
                              // if (isInterstitialLoaded){
                              //   interstitialAd.show();
                              //   interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
                              //       onAdDismissedFullScreenContent: (ad){
                              //         setState(() {
                              //           ad.dispose();
                              //           isInterstitialLoaded = false;
                              //           imgFile!=null ? sendImg(query: promptCtrl.text, image: imgFile!) : sendTxt(query: promptCtrl.text);
                              //           FocusScope.of(context).unfocus();
                              //           print("Navigator");
                              //         });
                              //       },
                              //       onAdFailedToShowFullScreenContent: (ad, error){
                              //         setState(() {
                              //           ad.dispose();
                              //           imgFile!=null ? sendImg(query: promptCtrl.text, image: imgFile!) : sendTxt(query: promptCtrl.text);
                              //           FocusScope.of(context).unfocus();
                              //           print(error.toString());
                              //         });
                              //       }
                              //   );
                              // }
                              // else {
                              //   imgFile!=null ? sendImg(query: promptCtrl.text, image: imgFile!) : sendTxt(query: promptCtrl.text);
                              //   FocusScope.of(context).unfocus();
                              // }
                              imgFile!=null ? sendImg(query: promptCtrl.text, image: imgFile!) : sendTxt(query: promptCtrl.text);
                              FocusScope.of(context).unfocus();

                            },
                            icon: SvgPicture.asset("assets/svgs/Send.svg", color: Colors.black ),
                          ),
                        ) : Container(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            loading==true ? Positioned(
              bottom: 27.h,
              left: 130.w,
              child: Lottie.asset("assets/lottie/loader2.json",
                  height: 150.h,
                  width: 180.w,
                  repeat: true,
                  fit: BoxFit.cover),
            ) : SizedBox(),
          ],
        ),
      ),
    );
  }

  void toast(BuildContext context){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          margin: EdgeInsets.symmetric(horizontal: 100.w, vertical: 80.h),
          height: 40.h,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Center(
            child: Text(
              "Text Copied",
              style: TextStyle(
                fontFamily: "Poppins",
                color: Colors.white,
                fontSize: 12.sp,
              ),
            ),
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: Duration(seconds: 1),
      ),
    );
  }

  Future bottomSheet(BuildContext context){
    return showModalBottomSheet(
        context: context,
        backgroundColor: Color(0xff101010),
        barrierColor: Colors.black26,
        isDismissible: true,
        shape: SmoothRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(50.r)), smoothness: 1),
        builder: (context)=> Container(
          height: 200.h,
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: 10.h,),
              Container(
                width: 100.w,
                height: 5.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.r),
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 45.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    width: 95.w,
                    decoration: ShapeDecoration(
                      shape: SmoothRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        smoothness: 1
                      ),
                      color: Colors.white
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(onPressed: (){
                          HapticFeedback.heavyImpact();
                          getImage(source: ImageSource.gallery);
                          Navigator.of(context).pop();
                        }, icon: SvgPicture.asset("assets/svgs/gallery.svg", color: Colors.black,)),
                        Text("Gallery", style: TextStyle(color: Colors.black, fontFamily: "poppinsRegular"),),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    width: 95.w,
                    decoration: ShapeDecoration(
                      shape: SmoothRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        smoothness: 1
                      ),
                      color: Colors.white
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(onPressed: (){
                          HapticFeedback.heavyImpact();
                          getImage(source: ImageSource.camera);
                          Navigator.of(context).pop();
                        }, icon: SvgPicture.asset("assets/svgs/camera.svg", color: Colors.black, )),
                        Text("Camera", style: TextStyle(color: Colors.black, fontFamily: "poppinsRegular"),),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
    );
  }
}
