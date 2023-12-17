import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vending Machine Inventory',
      home: VendingMachineList(),
    );
  }
}

class VendingMachineList extends StatefulWidget {
  @override
  _VendingMachineListState createState() => _VendingMachineListState();
}

class _VendingMachineListState extends State<VendingMachineList> {
  String? selectedId, selectedLocation, selectedModel;
  final List<String> availableIds = ["TW-000001", "TW-000002", "TW-000003", "TW-000004", "TW-000005", "TW-000006", "TW-000007", "TW-000008", "TW-000009", "TW-000010",
                                "TW-000011", "TW-000012", "TW-000013", "TW-000014", "TW-000015", "TW-000016", "TW-000017", "TW-000018", "TW-000019", "TW-000020"]; // 替換成您的 ID 列表
  final List<String> locationList = ["新光三越百貨-台北信義", "新光三越百貨-台中中港", "新光三越百貨-高雄", "太平洋崇光百貨-台北", "太平洋崇光百貨-台中", "太平洋崇光百貨-高雄",
                                      "遠東百貨-板橋", "遠東百貨-竹北", "Big City遠東巨城購物中心"
                                      ]; // 替換成您的地點列表
  final List<String> modelList = ["type-36", "type-40", "type-42"];

  //List<String> availableIds; // 可用 ID 列表

  //_VendingMachineListState() : availableIds = [...]; // 初始化可用 ID 列表

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vending Machines'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('vending_machine').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          final data = snapshot.data;
          if (data == null) {
            return Text('No data found');
          }
          return ListView(
            children: data.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> vendingMachine = document.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(vendingMachine['model']),
                subtitle: Text('ID: ${vendingMachine['id']} - Location: ${vendingMachine['location']}'),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addVendingMachineDialog(context),
        tooltip: 'Add Vending Machine',
        child: Icon(Icons.add),
      ),
    );
  }

// 這個函數可以放在 _VendingMachineListState 類別中
Future<void> _addVendingMachineDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Add new vending machine'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              DropdownButton<String>(
                value: selectedId,
                hint: Text("Select machine ID"),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedId = newValue!;
                  });
                },
                items: availableIds.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              DropdownButton<String>(
                value: selectedLocation,
                hint: Text("Select machine location"),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedLocation = newValue!;
                  });
                },
                items: locationList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              DropdownButton<String>(
                value: selectedModel,
                hint: Text("Select machine model"),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedModel = newValue!;
                  });
                },
                items: modelList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Add'),
            onPressed: () {
              if (selectedId != null && selectedLocation != null && selectedModel != null) {
                FirebaseFirestore.instance
                    .collection('vending_machine')
                    .doc(selectedId) // 使用 selectedId 作為文檔 ID
                    .set({
                      'id': selectedId,
                      'location': selectedLocation,
                      'model': selectedModel,
                    })
                    .then((value) {
                      setState(() {
                        // 新增成功後，從可用 ID 列表中移除
                        availableIds.remove(selectedId);
                        selectedId = null; // 重置選擇的 ID
                        selectedLocation = null; // 重置選擇的地點
                        selectedModel = null; // 重置選擇的型號
                      });
                      print("Vending Machine Added");
                    })
                    .catchError((error) => print("Failed to add vending machine: $error"));
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      );
    },
  );
}


}