import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localshare/pages/home_page.dart';
import 'package:localshare/pages/permission_page.dart';
import 'package:lottie/lottie.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Local",style: TextStyle(color: Colors.blue,fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,fontFamily: 'GaMaamli-Regular'),),
                  Text(" Share",style: TextStyle(color: Colors.green,fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,fontFamily: 'GaMaamli-Regular'),),
                ],
              ),
              const SizedBox(height:20),
              const Text("Qulay interfeys\ntezkor ma'lumotlar almashuvi",style:TextStyle(fontSize: 20,color:Colors.blue,fontFamily: 'GaMaamli-Regular'),textAlign: TextAlign.center,),
              SizedBox(height: MediaQuery.of(context).size.height*0.05,),
                SizedBox(
                  height: 150,
                    width: 150,
                    child: Lottie.asset("assets/lotties/splash.json",fit: BoxFit.cover)),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
             padding: const EdgeInsets.only(bottom: 40),
                child: MaterialButton(
                  color: Colors.blue,
              minWidth: 200,
              height: 50,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              onPressed: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx){
                      return const PermissionPage();
                    }
                    ));
              },
              child: const Text("Davom etish",style: TextStyle(color: Colors.white,fontSize:22,fontFamily: 'GaMaamli-Regular'),),
            )),
          ),
        ],
      ),
    );
  }
}
