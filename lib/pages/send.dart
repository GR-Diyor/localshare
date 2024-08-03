import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';

import '../model/send_data.dart';

class Send extends StatefulWidget {
  const Send({super.key});

  @override
  State<Send> createState() => _SendState();
}

class _SendState extends State<Send> with WidgetsBindingObserver {
  final TextEditingController msgText = TextEditingController();
  final _flutterP2pConnectionPlugin = FlutterP2pConnection();
  List<DiscoveredPeers> peers = [];
  WifiP2PInfo? wifiP2PInfo;
  StreamSubscription<WifiP2PInfo>? _streamWifiInfo;
  StreamSubscription<List<DiscoveredPeers>>? _streamPeers;
  TransferData? transferData;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _init();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _flutterP2pConnectionPlugin.unregister();
    closeSocketConnection();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _flutterP2pConnectionPlugin.unregister();
    } else if (state == AppLifecycleState.resumed) {
      _flutterP2pConnectionPlugin.register();
    }
  }

  void _init() async {
    await _flutterP2pConnectionPlugin.initialize();
    await _flutterP2pConnectionPlugin.register();
    _streamWifiInfo =
        _flutterP2pConnectionPlugin.streamWifiP2PInfo().listen((event) {
      setState(() {
        wifiP2PInfo = event;
      });
    });
    _streamPeers = _flutterP2pConnectionPlugin.streamPeers().listen((event) {
      setState(() {
        peers = event;
      });
    });
    _flutterP2pConnectionPlugin.discover();
    startSocket();
    setState(() {
    });
  }

  Future connectToSocket() async {
    if (wifiP2PInfo != null) {
      await _flutterP2pConnectionPlugin.connectToSocket(
        groupOwnerAddress: wifiP2PInfo!.groupOwnerAddress,
        downloadPath: "/storage/emulated/0/Download/",
        maxConcurrentDownloads: 3,
        deleteOnError: true,
        onConnect: (address) {
          snack("connected to socket: $address");
        },
        // onCloseSocket: (){
        //   snack("closed to socket");
        // },
        transferUpdate: (TransferUpdate transfer) {

          // if (transfer.count == 0) transfer.cancelToken?.cancel();
          setState(() {
            transferData = TransferData(filename: transfer.filename, path: transfer.path, count: transfer.count, total: transfer.total, completed: transfer.completed, failed: transfer.failed, receiving: transfer.receiving, id: transfer.id, cancelToken: transfer.cancelToken);
          });
          if (transfer.completed) {
            snack(
                "${transfer.failed ? "failed to ${transfer.receiving ? "receive" : "send"}" : transfer.receiving ? "received" : "sent"}: ${transfer.filename}");
          }
          print(
              "ID: ${transfer.id}, FILENAME: ${transfer.filename}, PATH: ${transfer.path}, COUNT: ${transfer.count}, TOTAL: ${transfer.total}, COMPLETED: ${transfer.completed}, FAILED: ${transfer.failed}, RECEIVING: ${transfer.receiving}");
        },
        receiveString: (req) async {
          snack(req);
        },
      );
    }
  }
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


  Future startSocket() async {
    if (wifiP2PInfo != null) {
      await _flutterP2pConnectionPlugin.createGroup();
      await _flutterP2pConnectionPlugin.startSocket(
        groupOwnerAddress: wifiP2PInfo!.groupOwnerAddress,
        downloadPath: "/storage/emulated/0/Download/",
        maxConcurrentDownloads: 2,
        deleteOnError: true,
        onConnect: (name, address) {
          snack("$name connected to socket with address: $address");
        },
        transferUpdate: (transfer) {
          if (transfer.completed) {
            snack(
                "${transfer.failed ? "failed to ${transfer.receiving ? "receive" : "send"}" : transfer.receiving ? "received" : "sent"}: ${transfer.filename}");
          }
          print(
              "ID: ${transfer.id}, FILENAME: ${transfer.filename}, PATH: ${transfer.path}, COUNT: ${transfer.count}, TOTAL: ${transfer.total}, COMPLETED: ${transfer.completed}, FAILED: ${transfer.failed}, RECEIVING: ${transfer.receiving}");
        },
        // onCloseSocket: () {
        //   print("close connection");
        // },
        receiveString: (req) async {
          snack(req);
        },
      );

    }
  }

  Future closeSocketConnection() async {
    bool closed = _flutterP2pConnectionPlugin.closeSocket();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "closed: $closed",
        ),
      ),
    );
  }

  Future sendMessage() async {
    _flutterP2pConnectionPlugin.sendStringToSocket(msgText.text);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yuborish',style: TextStyle(color: Colors.white,fontFamily: 'GaMaamli-Regular'),),
        centerTitle: true,
        backgroundColor: Colors.blue,
        leading: GestureDetector(
          onTap: ()=>Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios_new_outlined,color: Colors.white,),
        ),
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: peers.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      showCupertinoDialog(
                        context: context,
                        builder: (context) => Center(
                          child: SimpleDialog(
                            title: Text(peers[index].deviceName),
                            children: [
                              TextButton(
                                onPressed: () async {
                                    connectToSocket();
                                  Navigator.of(context).pop();
                                  bool? bo = await _flutterP2pConnectionPlugin
                                      .connect(peers[index].deviceAddress);
                                  if(bo){
                                    snack("Device ulandi");
                                  }else{
                                    snack("Device ulanmadi");

                                  }
                                },
                                child: const Text("Ulanish"),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        tileColor: Colors.blue,
                        shape: const OutlineInputBorder(),
                        title: Text(
                          peers[index].deviceName,
                          style: const TextStyle(color: Colors.white,fontSize: 20,fontFamily: 'GaMaamli-Regular'),
                        ),
                        subtitle: Text(
                          "ip: ${peers[index].deviceAddress}",
                          style: const TextStyle(color: Colors.white,fontSize: 11,fontFamily: 'GaMaamli-Regular'),
                        ),
                        trailing: const Icon(Icons.connect_without_contact,color: Colors.white,),

                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(top: 40,left: 15,right: 15),
                    decoration:  BoxDecoration(
                      color: Colors.teal,
                      borderRadius: const BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20)),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            border:transferData?.filename!=null?Border.all():null,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(transferData?.filename??'',style: const TextStyle(color: Colors.white,fontSize: 18),),
                              Text(transferData?.path??'',style: const TextStyle(color: Colors.white,fontSize: 12),),
                            ],

                          ),
                        ),
                      ],
                    )
                  )
              ),

            ],
          ),
          peers.isEmpty?const Center(child: CircularProgressIndicator(),):const SizedBox.shrink(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration:  BoxDecoration(
                  color: Colors.white54,
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    IconButton(onPressed: (){
                      msgText.clear();
                    },icon:const Icon(Icons.delete)),
                    Expanded(
                      child:  TextField(
                        controller: msgText,
                        decoration: const InputDecoration(
                          hintText: "message",
                          border: InputBorder.none,
                        ),
                      ),),
                    IconButton(onPressed: (){
                      if(msgText.text.isNotEmpty){
                        sendMessage();
                        msgText.clear();
                      }
                    }, icon: const Icon(Icons.send)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
