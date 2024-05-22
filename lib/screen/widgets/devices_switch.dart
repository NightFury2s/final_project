// import 'dart:convert';

// import 'package:IntelliHome/model/mqtt_model.dart';
import 'package:flutter/material.dart';
import 'package:IntelliHome/constants/app_colors.dart';
import 'package:IntelliHome/model/smart_home_model.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class DeviceSwitch extends StatefulWidget {
   DeviceSwitch({super.key, required this.data,this.client});

  final DeviceInRoom data;
  final MqttServerClient? client;

  @override
  State<DeviceSwitch> createState() => _DeviceSwitchState();
}

class _DeviceSwitchState extends State<DeviceSwitch> {
  late DeviceInRoom data;
  ValueNotifier<bool> statusLightNotifier = ValueNotifier(false);
  ValueNotifier<bool> statusRelayNotifier = ValueNotifier(false);
  bool statusLight() => statusLightNotifier.value;
  bool statusRelay() => statusRelayNotifier.value;
  MqttServerClient? client;

  @override
  void initState(){
    super.initState();
    setState(() {
      data = this.widget.data;
      client = this.widget.client;
    });
    if(data.deviceName == 'Light'){
      if (client?.connectionStatus!.state == MqttConnectionState.connected) {
        print("MQTT client connected");
        client?.updates?.listen((List<MqttReceivedMessage<MqttMessage? >> ? c) {
            final recMess = c![0].payload as MqttPublishMessage;
            final pt =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
            print('topic 123 ${c[0].topic}');
            print('pt ${pt}');
            if(c[0].topic == data.topicLight){
              statusLightNotifier.value = pt == 'true';
                  setState(() {
                    data.deviceStatus = pt == 'true';
                  });
            }else{
              print('WRONG TOPIC!!!');
            }
          });
        // client?.published!.listen((MqttPublishMessage message) {
        //   if (message.variableHeader!.topicName == data.topicLight) {
        //     print('message: ${message.payload.message.toString()}');
        //     setState(() {
        //       data.deviceStatus = !data.deviceStatus;
        //     });
        //     print('value:${message}');
        //   }
        // });
      }
    }
    if(data.deviceName == 'Fan'){
      if (client?.connectionStatus?.state == MqttConnectionState.connected) {
        print("MQTT client connected for Fan");
        client?.updates?.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
          for (final message in c!) {
            final recMess = message.payload as MqttPublishMessage;
            final ft = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
            print('topic: ${message.topic}');
            print('ft: $ft');
            if (message.topic == data.topicRelay) {
              statusRelayNotifier.value = ft == 'true';
              setState(() {
                data.deviceStatus = ft == 'true';
              });
            } else {
              print('WRONG TOPIC!!!');
            }
          }
        });
      }
    }

    // client?.published!.listen((MqttPublishMessage message) {
        //   if (message.variableHeader!.topicName == data.topicLight) {
        //     print('message: ${message.payload.message.toString()}');
        //     setState(() {
        //       data.deviceStatus = !data.deviceStatus;
        //     });
        //     print('value:${message}');
        //   }
        // });
      }
      // xu ly' o day

  void onPressed() {
    if(data.deviceName == 'Light'){
      print(data.topicLight);
      print(client?.connectionStatus!.state);
      if (client?.connectionStatus!.state == MqttConnectionState.connected){
        print('onpress light');
        final builder1 = MqttClientPayloadBuilder();
        builder1.addString('${!data.deviceStatus}');
        client?.publishMessage(data.topicLight!, MqttQos.atLeastOnce, builder1.payload!);
              }
    }else{
      setState(() {
        data.deviceStatus = !data.deviceStatus;
      });
    }
  }
  void onFanPressed() {
    if(data.deviceName == 'Fan'){
      print(data.topicRelay);
      print(client?.connectionStatus!.state);
      if (client?.connectionStatus!.state == MqttConnectionState.connected){
        print('onpress fan');
        final builder2 = MqttClientPayloadBuilder();
        builder2.addString('${!data.deviceStatus}');
        client?.publishMessage(data.topicRelay!, MqttQos.atLeastOnce, builder2.payload!);
      }
    } else {
      setState(() {
        data.deviceStatus = !data.deviceStatus;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final Duration _duration = Duration(milliseconds: 300);
    return GestureDetector(
      onTap: data.deviceName == 'Light' ? onPressed : onFanPressed,
      child: Container(
        // DEVICES SWITCH
        width: size.width * 0.24,
        margin: EdgeInsets.symmetric(
          horizontal: 10
        ),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColor.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(60),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedPositioned(
              top: !data.deviceStatus ? 0 : -size.height * 0.22 / 2,
              duration: _duration,
              child: Column(
                children: [
                  _deviceStatus(data),
                  _deviceName(size, data)
                ],
              ),
            ),

            AnimatedPositioned(
              bottom: data.deviceStatus ? 0 : -size.height * 0.22 / 2,
              duration: _duration,
              child: Column(
                children: [
                  _deviceName(size, data),
                  _deviceStatus(data)
                ],
              ),
            ),
            AnimatedPositioned(
              top: data.deviceStatus ? 0 : (size.height * 0.20 / 2) + 10,
              duration: _duration,
              child: Container(
                padding:  EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(60),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.black.withOpacity(0.2),
                      blurRadius: 20
                    )
                  ]
                ),
                child: Icon(
                  data.deviceStatus ? data.iconOn : data.iconOff,
                  color: AppColor.fgColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // DEVICE NAME
  Container _deviceName(Size size, DeviceInRoom data) {
    return Container(
          margin: EdgeInsets.all(8.0),
          width: size.width * 0.22 - 16,
          child: Text(
            data.deviceName,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(
              color: AppColor.white,
              overflow: TextOverflow.ellipsis,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 1.2
            ),
          ),
        );
  }

  Padding _deviceStatus(DeviceInRoom data) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        data.deviceStatus ? "ON" : "OFF",
        style: TextStyle(
          color: AppColor.white,
          fontWeight: FontWeight.w300
        ),
      ),
    );
  }
}
