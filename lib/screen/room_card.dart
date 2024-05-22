import 'package:flutter/material.dart';
import 'package:IntelliHome/constants/app_colors.dart';
import 'package:IntelliHome/model/smart_home_model.dart';
import 'package:IntelliHome/screen/room_controller.dart';
// import 'package:mqtt_client/mqtt_server_client.dart';

class RoomCard extends StatelessWidget {
   RoomCard({super.key, required this.roomData});

  final SmartHomeModel roomData;
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    
    return InkWell(
      onTap: () {
        Navigator.push(
          context, MaterialPageRoute(
            builder: (context) => RoomController(roomData: roomData)
          )
        );
      },
      child: Container(
        width: size.width * 0.35,
        height: size.height * 0.5,
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(
          horizontal: 5
        ),
        padding: EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: AppColor.fgColor,
          borderRadius: BorderRadius.circular(size.width * 0.07),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              roomData.roomImage
            ),
            colorFilter: ColorFilter.mode(
              AppColor.black.withOpacity(0.2),
              BlendMode.darken
            )
          )
        ),
        child: Text(
          roomData.roomName,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColor.white
          ),
        ),
      ),
    );
  }
}