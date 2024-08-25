import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';

typedef Unit8ListCallback = Function(Uint8List data);
typedef DynamicCallback = Function(Uint8List data);


class Server{
  Unit8ListCallback? onData;
  DynamicCallback? onError;

  Server(this.onData,this.onError);

  ServerSocket? server;
  bool running = false;
  List<Socket> socketList= [];

  Future<void> start(String? ip)async{
    runZoned(()async{
      debugPrint(ip);
      server = await ServerSocket.bind(ip ??"192.168.49.1", 4000,shared: true);///agar ip misol uchun yozilgan
      ///bo'lsa, ishlmaydi,aniq, qurilma local ip yozilishi kerak
      running = true;
      debugPrint("server running");
      server?.listen(onRequest);
      //String message = "Server listening ${server?.address.address??192.168}";
      //onData!(Uint8List.fromList(message.codeUnits));
    },
        onError: onError
    );
  }

  void onRequest(Socket socket){
    if(!socketList.contains(socket)){
      socketList.add(socket);
    }
    socket.listen((event){
      onData!(event);
    });

  }
  Future<void> close()async{
    debugPrint("server close");
    server = null;
    running = false;
  }


  void boardCast(String data)async{
    //onData!(Uint8List.fromList("Me :  $data".codeUnits));
    String jsonData = data.toString();
    for(final socket in socketList){
      // for(var item in data) {
      socket.write(jsonData);
      // socket.write(json.encode(item.toJson()));
      //   await socket.flush(); // qachonki ishlatish kerak, ikkita bir xil xabar bo'lganda

      // }
    }
  }
}
