import 'dart:io';
import 'package:flutter/material.dart';
import 'package:localshare/model/server.dart';

class ClientModel extends ChangeNotifier{
  String? hostName;
  int? port;
  Unit8ListCallback? onData;
  DynamicCallback? onError;
  ClientModel({required this.onData,this.onError,this.hostName,this.port});

  bool isConnected = false;
  Socket? socket;
  bool recieved = false;

  Future<void> connect()async{
    try {
      debugPrint(hostName);
      debugPrint(port!.toString());
      socket = await Socket.connect(hostName, port!);
      socket!.listen(onData, onError: onError, onDone: () async {
        disconnect();
        isConnected = false;
        recieved = true;
      });
      //change connect
      isConnected = true;
      notifyListeners();
    }catch(e){
      debugPrint(e.toString());
    }
  }

  void write(String message)async{
    if(socket!=null) {
      socket!.write(message);
    }
  }
  void disconnect(){
    if(socket!=null){
      socket!.destroy();
      isConnected = false;
    }
  }
}