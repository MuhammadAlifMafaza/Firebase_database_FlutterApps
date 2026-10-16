import 'package:flutter/material.dart';

import 'edit_data.dart';

class DetailData extends StatelessWidget {
  final String nim, nama, kelas, prodi;
  const DetailData({
    super.key,
    required this.nim,
    required this.nama,
    required this.kelas,
    required this.prodi,
  });

  String get initials => nama
      .trim()
      .split(RegExp(r'\s+'))
      .where((s) => s.isNotEmpty)
      .take(2)
      .map((s) => s[0].toUpperCase())
      .join();

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF2864F0);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Mahasiswa',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFE8EDF5)),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 42,
                  backgroundColor: const Color(0xFFE5EEFF),
                  child: Text(
                    initials.isEmpty ? '?' : initials,
                    style: const TextStyle(
                      color: blue,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  nama,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF172033),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'NIM $nim',
                  style: const TextStyle(color: Color(0xFF718096)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Informasi Mahasiswa',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          _DetailRow(label: 'NIM', value: nim, icon: Icons.badge_outlined),
          _DetailRow(label: 'Nama', value: nama, icon: Icons.person_outline),
          _DetailRow(label: 'Kelas', value: kelas, icon: Icons.class_outlined),
          _DetailRow(
            label: 'Program Studi',
            value: prodi,
            icon: Icons.school_outlined,
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 50,
            child: FilledButton.icon(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditData(
                      nim: nim,
                      nama: nama,
                      kelas: kelas,
                      prodi: prodi,
                    ),
                  ),
                );
                if (context.mounted) Navigator.pop(context);
              },
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Edit Data'),
              style: FilledButton.styleFrom(
                backgroundColor: blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label, value;
  final IconData icon;
  const _DetailRow({
    required this.label,
    required this.value,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFFE8EDF5)),
    ),
    child: Row(
      children: [
        Icon(icon, color: const Color(0xFF2864F0)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Color(0xFF718096)),
              ),
              const SizedBox(height: 4),
              Text(
                value.isEmpty ? '-' : value,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF172033),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
