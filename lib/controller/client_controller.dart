
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ping_discover_network_plus/ping_discover_network_plus.dart';

import '../model/client.dart';

class ClientController extends GetxController {
  String? deviceName;
  StreamSubscription<List<DiscoveredPeers>>? streamPeers;
  Stream<NetworkAddress>? stream;
  var textEditController = TextEditingController();
  final flutterP2pConnectionPlugin = FlutterP2pConnection();
  WifiP2PInfo? wifiP2PInfo;
  StreamSubscription<WifiP2PInfo>? streamWifiInfo;
  List<DiscoveredPeers> peers = [];
  bool isConnect = false;
  List<String> recieverString = [];
  Socket? socket;
  int port = 4000;
  ClientModel? clientModel;
  NetworkAddress? adress;
  bool doubleConnect = false;
  bool socketConnect= false;
  String Udata='';
  String ip = '';
  bool isSave = false;

  @override
  void onInit() {
    // clientModel = ClientModel(onData: onData,onError: onError);
    super.onInit();
  }




  void saveSms()async{
    //AppService.addSms("+9989382", "salom");
    isSave = true;
    update();
  }
  void init() async {
    await flutterP2pConnectionPlugin.initialize();
    await flutterP2pConnectionPlugin.register();
    streamWifiInfo =
        flutterP2pConnectionPlugin.streamWifiP2PInfo().listen((event) {
          wifiP2PInfo = event;
          debugPrint(wifiP2PInfo?.groupOwnerAddress);
          update();
        });

    streamPeers = flutterP2pConnectionPlugin.streamPeers().listen((event) {
      peers = event;
      debugPrint(peers.toString());
      update();
    });

    discover();
    update();
  }


  void connect(int index,BuildContext context) async{
    doubleConnect=false;
    isConnect = await flutterP2pConnectionPlugin
        .connect(peers[index].deviceAddress);

    if(isConnect){
      doubleConnect=true;
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

  onData(Uint8List data) {
    // Udata = String.fromCharCodes(data);
    // update();
    String parsing = String.fromCharCodes(data);
    recieverString.add(parsing);
    update();
  }

  void discover(){
    flutterP2pConnectionPlugin.discover();
  }



// Connect to socket    for client
  Future connectToSocket(BuildContext context) async {
    ip = await flutterP2pConnectionPlugin.getIPAddress()??'';
    Directory directory = await getApplicationDocumentsDirectory();
    if (wifiP2PInfo != null) {
      await flutterP2pConnectionPlugin.connectToSocket(
        groupOwnerAddress: wifiP2PInfo!.groupOwnerAddress,
        // downloadPath is the directory where received file will be stored
        downloadPath: directory.path,
        // the max number of downloads at a time. Default is 2.
        maxConcurrentDownloads: 2,
        // delete incomplete transfered file
        deleteOnError: true,
        // on connected to socket
        onConnect: (address) async {

          stream = NetworkAnalyzer.i.discover2(
              address.substring(0, address.lastIndexOf('.')),
              port);
          update();
          stream!.listen((NetworkAddress networkAdress) async {
            if (networkAdress.exists) {
              // snack("Manzil: ${networkAdress.ip}",context);
              debugPrint("Ip:${networkAdress.ip}");
              adress = networkAdress;
              update();
            }
          });
          clientModel = ClientModel(
            hostName: adress?.ip,
            onData: onData,
            onError: onError,
            port: port,
          );
          clientModel?.connect();
          socketConnect = true;
          snack("Qurilma ulandi.Manzil: $address",context);
          update();
        },
        // receive transfer updates for both sending and receiving.
        transferUpdate: (transfer) {

          snack("Recieved:${transfer.filename}",context);
          // transfer.count is the amount of bytes transfered
          // transfer.total is the file size in bytes
          if(transfer.receiving){
            // recieverString.add(transfer.filename);
            // update();

            snack("Kelgan xabar: ${transfer.filename}",context);
            update();
          }
          update();
          // if transfer.receiving is true, you are receiving the file, else you're sending the file.
          // call `transfer.cancelToken?.cancel()` to cancel transfer. This method is only applicable to receiving transfers.
          print(
              "ID: ${transfer.id}, FILENAME: ${transfer.filename}, PATH: ${transfer.path}, COUNT: ${transfer.count}, TOTAL: ${transfer.total}, COMPLETED: ${transfer.completed}, FAILED: ${transfer.failed}, RECEIVING: ${transfer.receiving}");
        },
        // handle string transfer from server
        receiveString: (req) async {
          debugPrint(req);
          if(req != null){
            recieverString.add(req);
            update();
          }
        },
      );
    }else{
      snack("Qurilma ulanmadi. ${wifiP2PInfo?.clients}",context);
    }
    update();
  }
  Future<void>serverClose()async{

    await clientModel?.socket?.close();
    await flutterP2pConnectionPlugin.unregister();
    await flutterP2pConnectionPlugin.removeGroup();
    recieverString.clear();
    peers.clear();
    socketConnect = false;
    doubleConnect = false;
    isConnect = false;
    debugPrint("Reciever closed");
    update();
  }

}