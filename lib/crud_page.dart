import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';
import 'package:task1/Service/database.dart';

import 'listing.dart';

class CrudPage extends StatefulWidget {
  const CrudPage({super.key});

  @override
  State<CrudPage> createState() => _CrudPageState();
}

class _CrudPageState extends State<CrudPage> {
  
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Employee Form',style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Column(
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
                    // suffixIcon: Icon(Icons.email),
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
                    // suffixIcon: Icon(Icons.lock),
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
                    // suffixIcon: Icon(Icons.lock),
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
                   Map<String, dynamic> employeeInfoMap={
                     "Name": nameController.text,
                     "Age": ageController.text,
                     "Id": Id,
                     "Location": locationController.text
                   };
                   await DatabaseMethods().addEmployeeDetails(employeeInfoMap, Id).then((value) {
                     nameController.clear();
                     ageController.clear();
                     locationController.clear();
                     Fluttertoast.showToast(
                         msg: "Employee details has been uploaded successfully.",
                         toastLength: Toast.LENGTH_SHORT,
                         gravity: ToastGravity.CENTER,
                         timeInSecForIosWeb: 1,
                         backgroundColor: Colors.green,
                         textColor: Colors.white,
                         fontSize: 16.0
                     );
                     Navigator.push(
                       context,
                       MaterialPageRoute(builder: (context) => Listing()),
                     );
                   });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),

                    width: double.infinity,
                    height: 40,
                    child: Center(child: Text('Submit',style: TextStyle(color: Colors.white),)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
