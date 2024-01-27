import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Typer extends StatefulWidget {
  final String text;

  const Typer({Key? key, required this.text}) : super(key: key);

  @override
  State<Typer> createState() => _TyperState();
}

class _TyperState extends State<Typer> with AutomaticKeepAliveClientMixin{
  var newText;
  late Timer timer;
  late int index;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void startTimer() {
    final textToType = widget.text;
    index = 0;
    timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (index < textToType.length) {
        setState(() {
          newText = textToType.substring(0, index + 1);
          index++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(newText ?? "", style: TextStyle(fontFamily: "poppinsRegular", color: Color(0xff353535), fontSize: 13.sp),);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
