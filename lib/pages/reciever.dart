import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../controller/client_controller.dart';

class Reciever extends StatefulWidget {
  const Reciever({super.key});

  @override
  State<Reciever> createState() => _RecieverState();
}

class _RecieverState extends State<Reciever> with WidgetsBindingObserver{

  ClientController clientController = Get.put(ClientController());

  @override
  void initState() {
    clientController.getIpAdress();
    super.initState();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      clientController.flutterP2pConnectionPlugin.unregister();
    } else if (state == AppLifecycleState.resumed) {
      clientController.flutterP2pConnectionPlugin.register();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Qabul qilish",style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.blue,
        leading: GestureDetector(
          onTap: ()=>Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios_new_outlined,color: Colors.white,),
        ),
      ),
      body: GetBuilder(
          init: clientController,
          builder: (controller) {
            return Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                          itemCount: controller.peers.length,
                          itemBuilder: (ctx, index) {
                            return GestureDetector(
                              onTap: (){
                                controller.connect(index, context);
                              },
                              child: ListTile(
                                  title: Text(
                                    controller.peers[index].deviceName,
                                    style: const TextStyle(color: Colors.white54),
                                  ),
                                subtitle: Text(
                                  controller.peers[index].deviceAddress,
                                  style: const TextStyle(color: Colors.white54),
                                ),
                                trailing: const Icon(Icons.connect_without_contact,color: Colors.blue,),
                              ),
                            );
                          }),
                    ),
                    Expanded(child: ListView.builder(
                        itemBuilder: (ctx,index){
                          return Padding(
                              padding: EdgeInsets.all(10),
                            child: Text(""),
                          );
                        }
                    )
                    )
                  ],
                ),
                clientController.peers.isEmpty?const Center(child: CircularProgressIndicator(),):const SizedBox.shrink(),
              ],
            );
          }),
    );
  }
}

