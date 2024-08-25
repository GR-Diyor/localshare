import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:path_provider/path_provider.dart';
import '../model/send_data.dart';
import '../model/server.dart';


class ServerController extends GetxController{
  final flutterP2pConnectionPlugin = FlutterP2pConnection();
  List<DiscoveredPeers> peers = [];
  WifiP2PInfo? wifiP2PInfo;
  StreamSubscription<WifiP2PInfo>? _streamWifiInfo;
  StreamSubscription<List<DiscoveredPeers>>? _streamPeers;
  TransferData? transferData;
  List<String> recieverString = [];

  TextEditingController textEditingController = TextEditingController();
  //bool? isConnect =false;
  bool deviceConnected = false;
  bool doubleConnect = false;
  Server? server;
  String ip = '';

  @override
  void onInit(){
    server = Server(onData, onError);
    // startOrStopServer();
    super.onInit();
  }
  @override
  void dispose() {
    super.dispose();
  }


  void init(BuildContext context) async {
    await flutterP2pConnectionPlugin.initialize();
    await flutterP2pConnectionPlugin.register();
    _streamWifiInfo =
        flutterP2pConnectionPlugin.streamWifiP2PInfo().listen((event) {
          wifiP2PInfo = event;
          debugPrint(wifiP2PInfo?.groupOwnerAddress);
          update();
        });

    _streamPeers = flutterP2pConnectionPlugin.streamPeers().listen((event) {
      peers = event;
      debugPrint(peers.toString());
      update();
    });

    discover();
    //startSocket(context);
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

  // Future<void> startOrStopServer()async{
  //   final wifiIP = await AppInit().info.getWifiIP();
  //   debugPrint("asdeasd:$wifiIP");
  //   if(server!.running){
  //     await server!.close();
  //     recieverString.clear();
  //   }else {
  //     await server!.start(wifiIP);
  //   }
  //   update();
  // }


  /// for server   host
  Future<void> startSocket(BuildContext context) async {
    ip = await flutterP2pConnectionPlugin.getIPAddress()??'';
    Directory directory = await getApplicationDocumentsDirectory();
    if (wifiP2PInfo != null) {
      await flutterP2pConnectionPlugin.createGroup();
      await flutterP2pConnectionPlugin.startSocket(
        groupOwnerAddress: wifiP2PInfo!.groupOwnerAddress,
        downloadPath: directory.path,
        maxConcurrentDownloads: 2,
        deleteOnError: true,
        onConnect: (name, address) {
          snack("$name nomli qurilma ulandi.Manzil: $address",context);
          // server?.start(address.substring(0, address.lastIndexOf(':')));
          deviceConnected = true;
          update();

        },
        transferUpdate: (TransferUpdate transfer) {
          debugPrint("transfer file : $transfer");
        },
        receiveString: (req) {
          debugPrint("Recieve string  : $req");
        },
      );
      doubleConnect =true;
      update();
    }
    update();
  }


  Future<void> sendMessage(String data,BuildContext context) async {
    recieverString.add(data);
    flutterP2pConnectionPlugin.sendStringToSocket(data);
    snack("Xabar yuborildi", context);
    update();
  }

  void discover(){
    flutterP2pConnectionPlugin.discover();
    update();
  }

  void onData(Uint8List? data){
    if(data!=null){
      final recievedData = String.fromCharCodes(data);
      recieverString.add(recievedData);
      update();
    }
  }
  void onError(dynamic error){
    debugPrint("$error");
  }

  void handleMessage(String data){
    server!.boardCast(data);
    update();
  }

  Future<void> startOrStopServer()async{
    final wifiIP = await flutterP2pConnectionPlugin.getIPAddress();
    await server!.start(wifiIP);

    update();
  }
  Future<void>serverClose()async{
    await server?.close();
    recieverString.clear();
    await flutterP2pConnectionPlugin.unregister();
    await flutterP2pConnectionPlugin.removeGroup();
    deviceConnected = false;
    doubleConnect =false;
    peers.clear();
    debugPrint("Server closed");
    update();
  }
}


