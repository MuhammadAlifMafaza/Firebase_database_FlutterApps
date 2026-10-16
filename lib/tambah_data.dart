import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TambahData extends StatefulWidget {
  @override
  _TambahDataState createState() => _TambahDataState();
}

class _TambahDataState extends State<TambahData> {
  TextEditingController nimController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController prodiController = TextEditingController();

  Future<void> tambahData() async {
    final nim = nimController.text.trim();
    final nama = namaController.text.trim();
    final prodi = prodiController.text.trim();

    if (nim.isEmpty || nama.isEmpty || prodi.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field wajib diisi.')),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('mahasiswa').doc(nim).set({
      'nim': nim,
      'nama': nama,
      'prodi': prodi,
    });
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
      appBar: AppBar(title: Text('Tambah Data Mahasiswa')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: <Widget>[
            Text(
              "Input Data Mahasiswa",
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
                labelText: 'Program Studi',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 60),
            ElevatedButton(
              onPressed: () async {
                try {
                  await tambahData();
                  if (!mounted) return;
                  if (nimController.text.trim().isNotEmpty &&
                      namaController.text.trim().isNotEmpty &&
                      prodiController.text.trim().isNotEmpty) {
                    Navigator.pop(context);
                  }
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal menyimpan data: $e')),
                  );
                }
              },
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
