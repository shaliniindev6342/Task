import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
class DemoPage extends StatefulWidget {
  @override
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _controller = TextEditingController();
  List<String> _dataList = [];
  List<String> _dataList2 = [];
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late Stream<ConnectivityResult> _connectivityStream;
  @override
  void initState() {
    super.initState();
    _loadData();
    _connectivityStream = _connectivity.onConnectivityChanged;
    _connectivityStream.listen((ConnectivityResult result) {
      setState(() {
        _connectionStatus = result;
      });
    });
    _checkInitialConnectivity();
  }

  Future<void> _checkInitialConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      result = ConnectivityResult.none;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _connectionStatus = result;
    });
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var snapshot= await _firestore.collection('lists').snapshots();
    debugPrint("\n\n\n$snapshot \n\n\n");
    setState(() {
      _dataList2 = prefs.getStringList('pdList') ?? [];
    });
  }

  addData(type) async {
    if (_controller.text.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      if( type=="pdList"){
        _dataList2.add(_controller.text);
      await prefs.setStringList('$type', _dataList2);
      }else{
        _dataList.add(_controller.text);
        await  _clearCollection();
        await _firestore.collection('lists').add({
          'items': _dataList
        });
      }
      _controller.clear();
      setState(() {});
    }
  }

  sendData()async{
    if(_dataList2.length>0){
      await _fetchListData();
      _dataList2.forEach((element) async{
        SharedPreferences prefs = await SharedPreferences.getInstance();
        _dataList.add(element);
        _dataList2.remove("$element");
        await prefs.setStringList('pdList', _dataList2);
      });
      await  _clearCollection();
      await _firestore.collection('lists').add({
        'items': _dataList
      });
      _dataList2.clear();
      setState(() {
      });
    }

  }

  Future<void> _fetchListData() async {
    try {
      CollectionReference listsCollection = FirebaseFirestore.instance.collection('lists');
      QuerySnapshot querySnapshot = await listsCollection.get();
      List<String> items = [];
      for (var doc in querySnapshot.docs) {
        List<dynamic> docItems = doc['items'];
        items.addAll(docItems.map((item) => item.toString()));
      }
      setState(() {
        _dataList = items;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }


  Future<void> _clearCollection() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('lists').get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      print('Collection cleared');
    } catch (e) {
      print('Failed to clear collection: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var check = false;
    String statusMessage;
    switch (_connectionStatus) {
      case ConnectivityResult.wifi:
        statusMessage = 'Connected to WiFi';
        check=true;
        sendData();
        break;
      case ConnectivityResult.mobile:
        statusMessage = 'Connected to Mobile Network';
        check=true;
        sendData();
        break;
      case ConnectivityResult.none:
        statusMessage = 'No Internet Connection';
        check=false;
        break;
      default:
        statusMessage = 'Unknown Connection Status';
        check=false;
        break;
    }


    return Scaffold(
      appBar: AppBar(
        title: Text('$statusMessage'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Enter something'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: (){
                addData(check?'upList':'pdList');
              },
              child: Text('Add'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('lists').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final List<DocumentSnapshot> documents = snapshot.data!.docs;

                  return ListView(
                    children: documents.map((doc) {
                      List<dynamic> items = doc['items']; // Extracting the list of strings
                      return ListTile(
                        title: const Text('Uploaded Items'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: items.map((item) => Text(item.toString(),style: TextStyle(color: Colors.green,fontSize: 20,fontWeight: FontWeight.bold),)).toList(),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _dataList2.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_dataList2[index]),
                    trailing: Container(padding: EdgeInsets.only(left: 10,top: 2,bottom: 2,right: 10),color:Colors.red,child: Text("Pending"),),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}