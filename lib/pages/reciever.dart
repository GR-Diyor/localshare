import 'package:expansion_tile_card/expansion_tile_card.dart';
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
    clientController.init();
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
        title: const Text("Qabul qilish",style: TextStyle(color: Colors.white,fontFamily: 'GaMaamli-Regular'),),
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
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 200),
                        child: controller.peers.isNotEmpty
                            ? ListView.builder(
                            itemCount: controller.peers.length,
                            itemBuilder: (context, index) {
                              // var device = devices.data![index];
                              // print("devices.data ${device.deviceName}");
                              return GestureDetector(
                                onTap: () {
                                  // showCupertinoDialog(
                                  //   context: context,
                                  //   builder: (context) => Center(
                                  //     child: SimpleDialog(
                                  //       title: Text(controller.peers[index].deviceName),
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
                                    tileColor: Colors.blue,
                                    shape: const OutlineInputBorder(),
                                    title: Text(
                                      controller.peers[index].deviceName,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontFamily: 'GaMaamli-Regular'),
                                    ),
                                    subtitle: Text(
                                      "Adress: ${controller.peers[index].deviceAddress}",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontFamily: 'GaMaamli-Regular'),
                                    ),
                                    trailing: !clientController
                                        .doubleConnect
                                        ? TextButton(
                                      onPressed: () {
                                        clientController.connect(
                                            index, context);
                                      },
                                      child: const Text(
                                        "Ulanish",
                                        style: TextStyle(
                                            color: Colors.white54,
                                            fontSize: 11),
                                      ),
                                    )
                                        : const Icon(
                                      Icons.connect_without_contact,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            })
                            : const SizedBox.shrink(),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              clientController
                                  .recieverString.isNotEmpty?const Divider():const SizedBox.shrink(),
                              clientController
                                  .recieverString.isNotEmpty?const Text(
                                "Yuborilgan Xabarlar",
                                style: TextStyle(
                                    color: Colors.white60, fontSize: 20),
                              ):const SizedBox.shrink(),
                              Expanded(
                                  child: ListView.builder(
                                      itemCount: clientController
                                          .recieverString.length,
                                      itemBuilder: (ctx, index) {
                                        return Container(
                                          margin: const EdgeInsets.all(5),
                                          child: ExpansionTileCard(
                                            key: UniqueKey(),
                                            baseColor: Colors.black,
                                            expandedColor: Colors.black87,
                                            animateTrailing: true,
                                            trailing: const Icon(
                                              Icons
                                                  .keyboard_arrow_down_outlined,
                                              color: Colors.white54,
                                            ),
                                            leading: const CircleAvatar(
                                                child: Icon(Icons.info)),
                                            title: Text(
                                              clientController
                                                  .recieverString[index].substring(0,20) ??
                                                  '',
                                              style: const TextStyle(
                                                  color: Colors.white54),
                                            ),
                                            children: [
                                              Text(
                                                clientController
                                                    .recieverString[index] ??
                                                    '',
                                                style: const TextStyle(
                                                    color: Colors.white54),
                                              ),
                                            ],
                                          ),
                                        );
                                      })),
                              controller.isConnect &&
                                  controller.socketConnect == false
                                  ? GestureDetector(
                                onTap: () {
                                  clientController
                                      .connectToSocket(context);
                                },
                                child: Container(
                                  width:
                                  MediaQuery.of(context).size.width,
                                  height: 60,
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius:
                                    BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    "Qabul qilish",
                                    style: TextStyle(
                                        color: Colors.white54,
                                        fontSize: 20),
                                  ),
                                ),
                              )
                                  : const SizedBox.shrink(),
                              !controller.recieverString.isNotEmpty
                                  ? GestureDetector(
                                onTap: () {
                                  //if(!controller.isSave) {

                                  controller.saveSms();
                                  // }
                                },
                                child: Container(
                                  width:
                                  MediaQuery.of(context).size.width,
                                  height: 60,
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius:
                                    BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    "Saqlash",
                                    style: TextStyle(
                                        color: Colors.white54,
                                        fontSize: 20),
                                  ),
                                ),
                              )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                controller.peers.isEmpty
                    ? const Center(
                  child: CircularProgressIndicator(color: Colors.white54,),
                )
                    : const SizedBox.shrink(),
              ],
            );
          }),
    );
  }
}

