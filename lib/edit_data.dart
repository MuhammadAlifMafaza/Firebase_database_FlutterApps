import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';

class EditData extends StatefulWidget {
  final String nim;
  final String nama;
  final String prodi;

  const EditData({required this.nim, required this.nama, required this.prodi});

  @override
  _EditDataState createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {
  TextEditingController nimController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController prodiController = TextEditingController();

  // Initialize the TextEditingController with the values passed from the previous screen
  @override
  void initState() {
    nimController = TextEditingController(text: widget.nim);
    namaController = TextEditingController(text: widget.nama);
    prodiController = TextEditingController(text: widget.prodi);
    super.initState();
  }

  // Function to update data in Firestore
  void editData() {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('mahasiswa')
        .doc(widget.nim);

    Map<String, dynamic> dataMHS = ({
      'nim': nimController.text,
      'nama': namaController.text,
      'prodi': prodiController.text,
    });

    // Update data in Firestore using the document reference and the new data
    documentReference
        .update(dataMHS)
        .whenComplete(() => print('${widget.nim} Data berhasil diupdate'));
  }

  // Function to delete data from Firestore
  void deleteData() {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('mahasiswa')
        .doc(widget.nim);

    // Delete the document from Firestore using the document reference
    documentReference.delete().whenComplete(
      () => print('${widget.nim} Data berhasil dihapus'),
    );
  }

  // Function to show a confirmation dialog before deleting data
  void konfirmasi() {
    AlertDialog alertDialog = AlertDialog(
      content: Text("Apakah anda yakin akan menghapus data '${widget.nama}'"),
      actions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(foregroundColor: Colors.red),
          child: Text("OK DELETE!", style: TextStyle(color: Colors.black)),
          onPressed: () {
            deleteData();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Home()),
              (Route<dynamic> route) => false,
            );
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(foregroundColor: Colors.green),
          child: Text("CANCEL", style: TextStyle(color: Colors.black)),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Data Mahasiswa')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: <Widget>[
            Text(
              "Edit Data Mahasiswa",
              style: TextStyle(
                color: Colors.black,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: nimController,
              decoration: InputDecoration(
                labelText: 'NIM',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: namaController,
              decoration: InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: prodiController,
              decoration: InputDecoration(
                labelText: 'Prodi',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    editData();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: Text("UPDATE"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(foregroundColor: Colors.red),
                  onPressed: () {
                    konfirmasi();
                  },
                  child: Text("DELETE"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
