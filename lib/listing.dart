import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:random_string/random_string.dart';
import 'package:task1/Service/database.dart';

import 'crud_page.dart';

class Listing extends StatefulWidget {
  const Listing({super.key});

  @override
  State<Listing> createState() => _ListingState();
}

class _ListingState extends State<Listing> {

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  Stream? EmployeeStream;

  getontheload()async{
    EmployeeStream= await DatabaseMethods().getEmployeeDetails();
    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getontheload();
    super.initState();
  }

  Widget allEmployeeDetails(){
    return StreamBuilder(builder: (context, AsyncSnapshot snapshot){
      return snapshot.hasData? ListView.builder(
        itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index){
          DocumentSnapshot ds = snapshot.data.docs[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Name: '+ds["Name"],style: TextStyle(color: Colors.black),),
                        Spacer(),
                        GestureDetector(
                          onTap: (){
                            nameController.text=ds["Name"];
                            ageController.text=ds["Age"];
                            locationController.text=ds["Location"];
                            EditEmployeeDetails(ds["Id"]);
                          },
                            child: Icon(Icons.edit,color: Colors.orange,)),
                        SizedBox(width: 5.0,),
                        GestureDetector(
                          onTap: () async{
                            await DatabaseMethods().deleteEmployeeDetails(ds["Id"]);
                          },
                            child: Icon(Icons.delete,color: Colors.red,))
                      ],
                    ),
                    Text('Age: '+ds["Age"],style: TextStyle(color: Colors.black),),
                    Text('Location: '+ds["Location"],style: TextStyle(color: Colors.black),),
                  ],
                ),
              ),
            ),
          );
          }):Container();
    }, stream: EmployeeStream,);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CrudPage()),
          );
        },
        child: Icon(Icons.add,color: Colors.white,),
      ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Employee Details', style: TextStyle(color: Colors.white),),
        leading: InkWell(
          onTap: (){
            Get.back();
          },
            child: Icon(Icons.arrow_back,color: Colors.white,)),
      ),
      body: Column(
        children: [
          Expanded(
            child:allEmployeeDetails()
          ),
        ],
      ),

    );
  }

  Future EditEmployeeDetails(String id) => showDialog(context: context, builder: (context)=> AlertDialog(
    content: Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                  child: Icon(Icons.cancel)),
              SizedBox(height: 50,),
              Text('Edit Details', style: TextStyle(color: Colors.black,),),
            ],
          ),
              Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.deny(RegExp(r'\s')
                      ),
                    ],
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: ('Enter your name'),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide: BorderSide(color: Colors.black, width: 1)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide: BorderSide(color: Colors.black, width: 1)),
                      border: OutlineInputBorder(
                        // borderSide:BorderSide(color: green,width: 1),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      contentPadding: EdgeInsets.all(8),
                      suffixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    controller: ageController,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.deny(RegExp(r'\s')
                      ),
                    ],
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: ('Enter your age'),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide: BorderSide(color: Colors.black, width: 1)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide: BorderSide(color: Colors.black, width: 1)),
                      border: OutlineInputBorder(
                        // borderSide:BorderSide(color: green,width: 1),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      contentPadding: EdgeInsets.all(8),
                      suffixIcon: Icon(Icons.lock),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your age';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    controller: locationController,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.deny(RegExp(r'\s')
                      ),
                    ],
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: ('Enter your location'),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide: BorderSide(color: Colors.black, width: 1)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide: BorderSide(color: Colors.black, width: 1)),
                      border: OutlineInputBorder(
                        // borderSide:BorderSide(color: green,width: 1),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      contentPadding: EdgeInsets.all(8),
                      suffixIcon: Icon(Icons.lock),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your location';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20,),
                  InkWell(
                    onTap: () async{
                      String Id = randomAlphaNumeric(10);
                      Map<String, dynamic>updateInfo={
                        "Name": nameController.text,
                        "Age": ageController.text,
                        "Id": Id,
                        "Location": locationController.text
                      };
                      await DatabaseMethods().updateEmployeeDetails(id, updateInfo).then((value) {
                        Navigator.pop(context);
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),

                      width: double.infinity,
                      height: 40,
                      child: Center(child: Text('Update',style: TextStyle(color: Colors.white),)),
                    ),
                  )
                ],
              ),

        ],
      ),
    ),
  ));
  }

