import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Thông báo'),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.local_fire_department_outlined), text: 'Cảnh báo cháy'),
              Tab(icon: Icon(Icons.beach_access), text: 'Cảnh báo mưa'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FireAlertTab(),
            RainAlertTab(),
          ],
        ),
      ),
    );
  }
}

class FireAlertTab extends StatelessWidget {
  final List<Map<String, String>> fireAlerts = [
    {
      'title': 'Cháy ở phòng khách',
      'description': 'Có khói phát hiện ở phòng khách.',
      'time': '10:30 AM'
    },
    {
      'title': 'Cháy ở nhà bếp',
      'description': 'Có khói phát hiện ở nhà bếp.',
      'time': '11:00 AM'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return fireAlerts.isEmpty
        ? Center(child: Text('Không có thông báo nào'))
        : ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: fireAlerts.length,
            itemBuilder: (context, index) {
              final alert = fireAlerts[index];
              return Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  title: Text(alert['title']!, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(alert['description']!),
                  trailing: Text(alert['time']!),
                ),
              );
            },
          );
  }
}

class RainAlertTab extends StatelessWidget {
  final List<Map<String, String>> rainAlerts = [
    {
      'title': 'Mưa lớn sắp tới',
      'description': 'Dự báo có mưa lớn trong khu vực.',
      'time': '1:00 PM'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return rainAlerts.isEmpty
        ? Center(child: Text('Không có thông báo nào'))
        : ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: rainAlerts.length,
            itemBuilder: (context, index) {
              final alert = rainAlerts[index];
              return Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  title: Text(alert['title']!, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(alert['description']!),
                  trailing: Text(alert['time']!),
                ),
              );
            },
          );
  }
}
