import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:localshare/pages/reciever.dart';
import 'package:localshare/pages/send.dart';
import 'package:lottie/lottie.dart';

import '../core/config/string.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Local",style: TextStyle(color: Colors.blue,fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,fontFamily: 'GaMaamli-Regular'),),
                  Text(" Share",style: TextStyle(color: Colors.green,fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,fontFamily: 'GaMaamli-Regular'),),
                ],
              ),
            ),
            Lottie.asset('assets/lotties/Animation.json'),

      Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipPath(
          clipper: OctagonalClipper(),
          child: MaterialButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (ctx){
                return const Reciever();
              }
              ));
            },
            height: 100,
            minWidth: 200,
            color: Colors.blue.shade700,
            child: Text(AppString.recieve,style:  TextStyle(color: Colors.white,fontFamily: 'GaMaamli-Regular',fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize),),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipPath(
          clipper: OctagonalClipper(),
          child: MaterialButton(
            height: 100,
            minWidth: 200,
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (ctx){
                return const Send();
              }
              ));
            },
            color: Colors.green.shade700,
            child: Text(AppString.send,style:  TextStyle(color: Colors.white,fontFamily: 'GaMaamli-Regular',fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize),),
          ),
        ),
      ),

          ],
        ),
      ),
    );
  }
}
