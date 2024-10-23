import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MentalHealthCounsellorsView extends StatefulWidget {
  const MentalHealthCounsellorsView({super.key});

  @override
  State<MentalHealthCounsellorsView> createState() =>
      _MentalHealthCounsellorsViewState();
}

class _MentalHealthCounsellorsViewState
    extends State<MentalHealthCounsellorsView> {
  @override
  Widget build(BuildContext context) {
    void launchPhoneDialer(String phoneNumber) async {
      try {
        final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
        if (await canLaunchUrl(phoneUri)) {
          await launchUrl(phoneUri);
        } else {
          throw 'Could not launch phone dialer';
        }
      } catch (e) {
        log('Error while launching call: $e');
      }
    }

    List<MentalHealthCouncellorsModel> list = [
      MentalHealthCouncellorsModel(
        name: 'Wasim Kakroo',
        exp: '10',
        phone: '08825067196',
        address: '21, Mehjoor Nagar Ram Bagh Bund',
      ),
      MentalHealthCouncellorsModel(
        name: 'Mr.Muzzafar Ahmad Ganaii',
        exp: '10',
        phone: '08082093082',
        address:
            '242, Balgarden - Nursing garh Rd, opposite jehlum public school',
      ),
      MentalHealthCouncellorsModel(
        name: 'Mudasir Ahmad',
        exp: '10',
        phone: '08825067196',
        address: 'HMT Playground, HMT, Srinagar, Jammu and Kashmir 190012',
      ),
      MentalHealthCouncellorsModel(
        name: 'Dr.Syed Karrar',
        exp: '10',
        phone: '08899786888',
        address: 'Paramount Polyclinic, Hawal Chowk',
      ),
    ];
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.teal.shade100,
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 70),
            Text(
              '  Counsellors',
              style: TextStyle(
                  fontSize: 36,
                  color: Colors.grey.shade900,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              itemCount: list.length,
              shrinkWrap: true,
              padding: const EdgeInsets.all(0),
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      margin:
                          const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const CircleAvatar(
                          backgroundColor: Colors.teal,
                          backgroundImage: AssetImage('assets/images/sage.png'),
                          radius: 25,
                        ),
                        title: Text(
                          list[index].name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          list[index].address,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: const Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Icon(
                            Icons.call,
                            color: Colors.teal,
                          ),
                        ),
                        onTap: () => launchPhoneDialer(list[index].phone),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MentalHealthCouncellorsModel {
  final String name;
  final String exp;
  final String phone;
  final String address;

  MentalHealthCouncellorsModel(
      {required this.name,
      required this.exp,
      required this.phone,
      required this.address});
}
