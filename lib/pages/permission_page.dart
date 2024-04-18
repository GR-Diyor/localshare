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

  final _flutterP2pConnectionPlugin = FlutterP2pConnection();

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
      appBar: AppBar(
        backgroundColor: AppColor.primaryBackgroundColor,
        title: Text(AppString.persmissionText,
        style: TextStyle(color: AppColor.primaryColor),),
      ),
      body: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             Padding(
              padding:const EdgeInsets.all(8.0),
              child: Text(AppString.appUsePermissionText,style: TextStyle(fontSize: 25,color: AppColor.secondaryColor),softWrap: true,textAlign: TextAlign.center,),
            ),
            FilledButton(
                onPressed: () {
                  // request storage permission
                  FlutterP2pConnection().askStoragePermission();
                  // check if storage permission is granted
                  FlutterP2pConnection().checkStoragePermission();
                },
                child:  Text(AppString.useMemory)),
            FilledButton(
                onPressed: () async {
                  // enable location
                  FlutterP2pConnection().enableLocationServices();
                  // check if location is enabled
                  FlutterP2pConnection().checkLocationEnabled();
                  // request location permission
                  FlutterP2pConnection().askLocationPermission();
                  // check if location permission is granted
                  FlutterP2pConnection().checkLocationPermission();
                  String? ip = await _flutterP2pConnectionPlugin.getIPAddress();
                  snack("${AppString.ip} $ip");
                },
                child:  Text(AppString.findLocation)),
            FilledButton(
                onPressed: () {
                  // enable wifi
                  FlutterP2pConnection().enableWifiServices();
                  // check if wifi is enabled
                  FlutterP2pConnection().checkWifiEnabled();
                },
                child:  Text(AppString.useWifi)),

            const SizedBox(height: 40,),

            MaterialButton(
              minWidth: 80,
              height: 60,
              color: AppColor.secondaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomePage()));
              },
            child:  Text(AppString.checkPermissions,style: TextStyle(color: AppColor.primaryColor,fontSize: 25),),
            )
          ],
        ),
      ),
    );
  }
}
