
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ClientController extends GetxController {
  String? deviceName;
  StreamSubscription<List<DiscoveredPeers>>? stream;
  var textEditController = TextEditingController();
  final flutterP2pConnectionPlugin = FlutterP2pConnection();
  List<DiscoveredPeers> peers = [];
  @override
  void onInit() {
    super.onInit();
    getIpAdress();
  }

  void getIpAdress() async {
    await flutterP2pConnectionPlugin.initialize();
    await flutterP2pConnectionPlugin.register();
    final wifiIP = await flutterP2pConnectionPlugin.getIPAddress();
    debugPrint(wifiIP);
    if (wifiIP != null) {
      stream = flutterP2pConnectionPlugin.streamPeers().listen(
        (v)=>peers,
        onError: onError,
      );
      update();
    }
  }

  void sendMessage(String message,BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.black87,
        content: Text(message,style: const TextStyle(color: Colors.white54),)));
    // if (clientModel != null) {
    //   logs.add("Reciever me: $message");
    //   clientModel!.write(message);
    //   update();
    // }
    update();
  }

  void connect(int index,BuildContext context) async{
    bool? bo = await flutterP2pConnectionPlugin
        .connect(peers[index].deviceAddress);
    if(bo){
      snack("Device ulandi",context);
    }else{
      snack("Device ulanmadi",context);

    }
      update();
    }


void snack(String msg,BuildContext context) async {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 2),
      content: Text(
        msg,
      ),
    ),
  );
}


  onError(dynamic error) {
    debugPrint("Error: $error");
  }
}