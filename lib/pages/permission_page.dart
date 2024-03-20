import 'package:flutter/material.dart';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';
import 'package:localshare/pages/home_page.dart';

class PermissionPage extends StatefulWidget {
  const PermissionPage({super.key});

  @override
  State<PermissionPage> createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Ilovadan to'liq ishlashi uchun kerak bo'ladigan ruxsatlar.",style: TextStyle(fontSize: 25,color: Colors.blueAccent),softWrap: true,textAlign: TextAlign.center,),
            ),
            FilledButton(
                onPressed: () {
                  // request storage permission
                  FlutterP2pConnection().askStoragePermission();
                  // check if storage permission is granted
                  FlutterP2pConnection().checkStoragePermission();
                },
                child: const Text("Xotiradan foydalanish")),
            FilledButton(
                onPressed: () {
                  // enable location
                  FlutterP2pConnection().enableLocationServices();
                  // check if location is enabled
                  FlutterP2pConnection().checkLocationEnabled();
                  // request location permission
                  FlutterP2pConnection().askLocationPermission();
                  // check if location permission is granted
                  FlutterP2pConnection().checkLocationPermission();
                },
                child: const Text("Joylashuvni aniqlash")),
            FilledButton(
                onPressed: () {
                  // enable wifi
                  FlutterP2pConnection().enableWifiServices();
                  // check if wifi is enabled
                  FlutterP2pConnection().checkWifiEnabled();
                },
                child: const Text("Wifidan foydalanish")),

            const SizedBox(height: 40,),

            MaterialButton(
              minWidth: 80,
              height: 60,
              color: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomePage()));
              },
            child: const Text("Tekshirish",style: TextStyle(color: Colors.white,fontSize: 25),),
            )
          ],
        ),
      ),
    );
  }
}
