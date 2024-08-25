import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../controller/server_controller.dart';

class Send extends StatefulWidget {
  const Send({super.key});

  @override
  State<Send> createState() => _SendState();
}

class _SendState extends State<Send> with WidgetsBindingObserver {
  var serverController = ServerController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // request location permission
    serverController.init(context);
  }

  @override
  void dispose() {
    serverController.serverClose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state ==AppLifecycleState.detached) {
      serverController.flutterP2pConnectionPlugin.unregister();
    } else if (state == AppLifecycleState.resumed) {
      serverController.flutterP2pConnectionPlugin.register();
    }
  }



  @override
  Widget build(BuildContext context) {
    return GetBuilder<ServerController>(
        init: serverController,
        builder: (controller) => Scaffold(
          appBar: AppBar(
            title: const Text('Yuborish',style: TextStyle(color: Colors.white,fontFamily: 'GaMaamli-Regular'),),
            centerTitle: true,
            backgroundColor: Colors.blue,
            leading: GestureDetector(
              onTap: ()=>Navigator.pop(context),
              child: const Icon(Icons.arrow_back_ios_new_outlined,color: Colors.white,),
            ),
          ),
          body: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              serverController.peers.isNotEmpty
                  ? Expanded(
                child: ListView.builder(
                    itemCount: serverController.peers.length,
                    itemBuilder: (context, index) {
                      // var device = devices.data![index];
                      // print("devices.data ${device.deviceName}");
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text("Dastlab qabul qiluvchi tomonidan ulanish tugmasini bosing,so'ng yuboruvchidan ulanish tugmasini bosing.Qabul qiluvchi ulanganligini tekshirish uchun Qabul qilish tugmasini bosing",style: TextStyle(color: Colors.white60,fontSize: 12),),
                          GestureDetector(
                            onTap: () {
                              // showCupertinoDialog(
                              //   context: context,
                              //   builder: (context) => Center(
                              //     child: SimpleDialog(
                              //       title: Text(serverController
                              //           .peers[index].deviceName),
                              //       children: [
                              //
                              //       ],
                              //     ),
                              //   ),
                              // );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                tileColor: controller.deviceConnected?Colors.blue:Colors.grey,
                                shape: const OutlineInputBorder(),
                                title: Text(
                                  serverController
                                      .peers[index].deviceName,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontFamily: 'GaMaamli-Regular'),
                                ),
                                subtitle: Text(
                                  "Adress: ${serverController.peers[index].deviceAddress}",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontFamily: 'GaMaamli-Regular'),
                                ),
                                trailing:  !serverController.doubleConnect&&!serverController.deviceConnected?TextButton(
                                  onPressed: (){
                                    serverController.startSocket(context);
                                    serverController.startOrStopServer();
                                    setState(() {});
                                  },
                                  child: const Text("Ulanish",style: TextStyle(color: Colors.white54,fontSize: 11),),
                                ):
                                Icon(
                                  Icons.connect_without_contact,
                                  color: controller.deviceConnected?Colors.white:Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
              )
                  : const SizedBox(height: 40,width: 40,child: CircularProgressIndicator(color: Colors.white54,),),
              Expanded(
                flex: 2,
                child: controller.recieverString.isNotEmpty
                    ? Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Divider(),
                    const Text("Tanlangan Xabarlar",style: TextStyle(color: Colors.white60,fontSize: 20),),
                    Expanded(
                      child: ListView.builder(
                          itemCount: controller.recieverString.length,
                          itemBuilder: (context, index) {
                            // var device = devices.data![index];
                            // print("devices.data ${device.deviceName}");
                            return ListTile(
                              title: Text(
                                controller.recieverString[index],
                                style: const TextStyle(color: Colors.white54),
                              ),
                            );
                          }),
                    ),
                  ],
                )
                    : const SizedBox.shrink(),
              ),
      Padding(
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
                  controller.textEditingController.clear();
                },icon:const Icon(Icons.delete)),
                Expanded(
                  child:  TextField(
                    controller: controller.textEditingController,
                    decoration: const InputDecoration(
                      hintText: "xabar",
                      border: InputBorder.none,
                    ),
                  ),),
                IconButton(onPressed: (){
                 FocusScope.of(context).unfocus();
                }, icon: const Icon(Icons.done)),
              ],
            ),
          ),
        ),
              controller.deviceConnected?GestureDetector(
                onTap: () {
                  if(serverController.server!.running&&controller.textEditingController.text.isNotEmpty){
                    //serverController.handleMessage(widget.data);
                    serverController.sendMessage(controller.textEditingController.text,context);
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child:  const Text("Yuborish",
                    style:
                    TextStyle(color: Colors.white54, fontSize: 22),
                  ),
                ),
              ):const SizedBox.shrink(),
            ],
          ),
    ),
    );
  }
}
