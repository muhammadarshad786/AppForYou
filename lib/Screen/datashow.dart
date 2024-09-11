import 'dart:async';
import 'package:appforyou/serverSide.dart/crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DataShowDataBase extends StatefulWidget {
  const DataShowDataBase({super.key});

  @override
  State<DataShowDataBase> createState() => _DataShowDataBaseState();
}

class _DataShowDataBaseState extends State<DataShowDataBase> {

  Stream<DocumentSnapshot>? employeeStream;

  Future<void> getLoad() async {
    employeeStream = InfoStore().infoEmpGet('353011111123');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getLoad();
  }

  Widget fetchData() {
  return StreamBuilder<DocumentSnapshot>(
    stream: employeeStream,
    builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (!snapshot.hasData || snapshot.data == null || !snapshot.data!.exists) {
        return Center(child: Text('No Data Found'));
      } else {
        DocumentSnapshot ds = snapshot.data!;
      
        String age = ds['Age'] ?? 'Unknown';
        String country = ds['Country'] ?? 'Unknown';
        String name = ds['Name'] ?? 'Unknown';
        
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Age: $age'),
              Text('Country: $country'),
              Text('Name: $name'),
            ],
          ),
        );
      }
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text('Data Show')),
      body: Column(
        children: [
          Expanded(
            child: fetchData(),
          ),
        ],
      ),
    );
  }
}
