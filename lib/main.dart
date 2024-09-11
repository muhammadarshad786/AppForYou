import 'package:appforyou/Screen/datashow.dart';
import 'package:appforyou/Screen/imageshow.dart';
import 'package:appforyou/serverSide.dart/crud.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  ImageScreen(),//title: 'Home Page'
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
final TextEditingController _name = TextEditingController();
final TextEditingController _age = TextEditingController();
final TextEditingController _country = TextEditingController();

final firebase=FirebaseFirestore.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20,),
          TextFormField(
            controller: _name,
            decoration: const InputDecoration(
              hintText: 'Name',
              
              border: OutlineInputBorder()
            ),
            onTap: (){},
          ),
          const SizedBox(height: 20,),
           TextFormField(
            controller:_age ,
            decoration:const InputDecoration(
              hintText: 'age',
              
              border: OutlineInputBorder()
            ),
            onTap: (){},
          ),
          const SizedBox(height: 20,),
              TextFormField(
            controller:_country ,
            decoration:const InputDecoration(
              hintText: 'country',
              
              border: OutlineInputBorder()
            ),
            onTap: (){},
          ),
          const SizedBox(height: 20,),

          ElevatedButton(onPressed: () async{

            Map<String ,dynamic> emploeeeeSuoooo=
            {
              'Name':_name.text,
              'Age':_age.text,
              "Country":_country.text

            };

            await InfoStore().infoEmpADD(emploeeeeSuoooo, '353011111123');
            SnackBarShow();

           Navigator.push(context, MaterialPageRoute(builder: (context)=>const DataShowDataBase()));
        
              

          }, child: const Text('Save'))
        ],
      )
    );
  }

  void SnackBarShow()
  {
    final snack=SnackBar(
      
      content: const Text('Your data is Inserted'),
       
      action: SnackBarAction(label: 'Add Data', onPressed: (){
      }),

      
      );
      ScaffoldMessenger.of(context).showSnackBar(snack);
      

  }
}