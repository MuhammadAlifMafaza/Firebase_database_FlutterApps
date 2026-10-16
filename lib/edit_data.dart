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
  Future<void> editData() async {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('mahasiswa')
        .doc(widget.nim);

    final dataMHS = <String, dynamic>{
      // Keep the original NIM as the Firestore document ID.
      'nim': widget.nim,
      'nama': namaController.text.trim(),
      'prodi': prodiController.text.trim(),
    };

    await documentReference.update(dataMHS);
  }

  // Function to delete data from Firestore
  Future<void> deleteData() async {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('mahasiswa')
        .doc(widget.nim);

    // Delete the document from Firestore using the document reference
    await documentReference.delete();
  }

  // Function to show a confirmation dialog before deleting data
  void konfirmasi() {
    AlertDialog alertDialog = AlertDialog(
      content: Text("Apakah anda yakin akan menghapus data '${widget.nama}'"),
      actions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(foregroundColor: Colors.red),
          child: Text("OK DELETE!", style: TextStyle(color: Colors.black)),
          onPressed: () async {
            try {
              await deleteData();
              if (!context.mounted) return;
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            } catch (e) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Gagal menghapus data: $e')),
              );
            }
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
  void dispose() {
    nimController.dispose();
    namaController.dispose();
    prodiController.dispose();
    super.dispose();
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
              readOnly: true,
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
                  onPressed: () async {
                    if (namaController.text.trim().isEmpty ||
                        prodiController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Nama dan program studi wajib diisi.'),
                        ),
                      );
                      return;
                    }
                    try {
                      await editData();
                      if (!context.mounted) return;
                      Navigator.pop(context);
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Gagal mengubah data: $e')),
                      );
                    }
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
