import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';
import 'package:localshare/core/config/color.dart';

import '../core/config/string.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final TextEditingController msgText = TextEditingController();
  final _flutterP2pConnectionPlugin = FlutterP2pConnection();
  List<DiscoveredPeers> peers = [];
  WifiP2PInfo? wifiP2PInfo;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _flutterP2pConnectionPlugin.unregister();
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipPath(
              clipper: MultiplePointedEdgeClipper(),
              child: Container(
                height: 150,
                width: double.maxFinite,
                color: AppColor.primaryBackgroundColor,
              ),
            ),

            const SizedBox(height: 50,),
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 200,
              width: double.maxFinite,
              child: Stack(
                children: [
                  Column(
                    children: [
                      ClipPath(
                        clipper: WaveClipperTwo(flip: true,reverse: true),
                        child: Container(
                          height: 100,
                          width: double.maxFinite,
                          color: AppColor.primaryBackgroundColor,
                        ),
                      ),
                      ClipPath(
                        clipper: WaveClipperTwo(),
                        child: Container(
                          height: 100,
                          width: double.maxFinite,
                          color: AppColor.primaryBackgroundColor,
                        ),
                      )
                    ],
                  ),

                  Container(
                    height: 200,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 10,right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipPath(
                          clipper: OctagonalClipper(),
                          child: MaterialButton(
                            onPressed: (){},
                            color: AppColor.primaryColor,
                            child: Text(AppString.recieve),
                          ),
                        ),
                        ClipPath(
                          clipper: OctagonalClipper(),
                          child: MaterialButton(
                            onPressed: (){},
                            color: AppColor.primaryColor,
                            child: Text(AppString.send),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),

          ],
        ),
      ),
    );
  }
}
