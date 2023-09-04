import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

var f = NumberFormat('##,###');

class ExpencesListView extends StatefulWidget {
  const ExpencesListView({super.key});

  @override
  State<ExpencesListView> createState() => _ExpencesListViewState();
}

class _ExpencesListViewState extends State<ExpencesListView> {
  final userEmail = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      margin: const EdgeInsets.all(8),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('UserExpencesData')
            .doc(userEmail)
            .snapshots(),
        builder: (context, snapshot) {
          Widget contex = Center(
            child: Text(
              'There is no expences',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          );
          if (snapshot.hasData) {
            List userExpences = snapshot.data!['Current Expences data'];
            contex = ListView.builder(
              itemCount: userExpences.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          userExpences[index]['Budget'].toString(),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(width: 40),
                        Text(
                          '₹ ${f.format(userExpences[index]['Amount']).toString()}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(width: 30),
                        Text(
                          DateFormat.yMMMMd('en_US')
                              .format(userExpences[index]['Date'].toDate())
                              .toString(),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return contex;
        },
      ),
    );
  }
}
