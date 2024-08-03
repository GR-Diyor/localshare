import 'package:flutter/material.dart';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';
import 'package:localshare/core/config/color.dart';
import 'package:localshare/pages/home_page.dart';
import '../core/config/string.dart';

class PermissionPage extends StatefulWidget {
  const PermissionPage({super.key});

  @override
  State<PermissionPage> createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {


  void snack(String msg) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Text(
          msg,
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        children: [
          SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height*0.2,),
                Padding(
                  padding:const EdgeInsets.all(8.0),
                  child: Text(AppString.appUsePermissionText,style: TextStyle(fontSize: 23,color: AppColor.secondaryColor,fontFamily: 'GaMaamli-Regular'),softWrap: true,textAlign: TextAlign.center,),
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.2,),
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.9,
                  child: MaterialButton(
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      height: 50,
                      onPressed: () {
                        // request storage permission
                        FlutterP2pConnection().askStoragePermission();
                        // check if storage permission is granted
                        FlutterP2pConnection().checkStoragePermission();
                      },
                      child:  Row(
                        children: [
                          const Icon(Icons.memory,color: Colors.white,),
                          const SizedBox(width: 15,),
                          Text(AppString.useMemory,style: const TextStyle(color: Colors.white,fontSize: 20),),
                        ],
                      )),
                ),
                const SizedBox(height: 15,),
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.9,
                  child: MaterialButton(
                    color: Colors.blue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      height: 50,
                      onPressed: () async {
                        // enable location
                        FlutterP2pConnection().enableLocationServices();
                        // check if location is enabled
                        FlutterP2pConnection().checkLocationEnabled();
                        // request location permission
                        FlutterP2pConnection().askLocationPermission();
                        // check if location permission is granted
                        FlutterP2pConnection().checkLocationPermission();
                      },
                      child:  Row(
                        children: [
                          const Icon(Icons.location_on,color: Colors.white,),
                          const SizedBox(width: 15,),
                          Text(AppString.findLocation,style: const TextStyle(color: Colors.white,fontSize: 18),),
                        ],
                      )),
                ),
                const SizedBox(height: 15,),
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.9,
                  child: MaterialButton(
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      height: 50,
                      onPressed: () {
                        // enable wifi
                        FlutterP2pConnection().enableWifiServices();
                        // check if wifi is enabled
                        FlutterP2pConnection().checkWifiEnabled();
                      },
                      child:  Row(
                        children: [
                          const Icon(Icons.wifi,color: Colors.white,),
                          const SizedBox(width: 15,),
                          Text(AppString.useWifi,style: const TextStyle(color: Colors.white,fontSize: 18),),
                        ],
                      )),
                ),

                SizedBox(height: MediaQuery.of(context).size.height*0.1,),


              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: MaterialButton(
                minWidth: 200,
                height: 50,
                color: AppColor.secondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                onPressed: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const HomePage()));
                },
                child:  Text(AppString.checkPermissions,style: TextStyle(color: AppColor.primaryColor,fontSize: 23),),
              ),
            ),
          )
        ],
      ),
    );
  }
}