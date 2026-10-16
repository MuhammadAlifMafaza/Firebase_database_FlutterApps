import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'tambah_data.dart';
import 'detail_data.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();
  String _search = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.school_rounded, color: Color(0xFF4F46E5), size: 27),
            SizedBox(width: 10),
            Text('StudentHub', style: TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 18),
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.people_alt_outlined,
              color: Color(0xFF4F46E5),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TambahData()),
        ),
        backgroundColor: const Color(0xFF2864F0),
        foregroundColor: Colors.white,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add_rounded, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: Colors.white,
        child: SizedBox(
          height: 58,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {},
                tooltip: 'Home',
                icon: const Icon(Icons.home_rounded, color: Color(0xFF2864F0)),
              ),
              const SizedBox(width: 48),
              IconButton(
                onPressed: null,
                tooltip: 'Profil (segera hadir)',
                icon: const Icon(Icons.person_outline_rounded),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('mahasiswa')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return _StateMessage(
                icon: Icons.cloud_off_rounded,
                title: 'Data tidak dapat dimuat',
                message:
                    'Periksa koneksi dan konfigurasi Firebase Anda.\n${snapshot.error}',
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final allDocs = snapshot.data?.docs ?? [];
            final docs =
                allDocs.where((doc) {
                  final data = doc.data();
                  final query = _search.toLowerCase();
                  return ['nim', 'nama', 'kelas', 'prodi'].any(
                    (key) => (data[key] ?? '')
                        .toString()
                        .toLowerCase()
                        .contains(query),
                  );
                }).toList()..sort(
                  (a, b) => (a.data()['nama'] ?? '').toString().compareTo(
                    (b.data()['nama'] ?? '').toString(),
                  ),
                );

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
              children: [
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2864F0), Color(0xFF4B83F5)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2864F0).withValues(alpha: .20),
                        blurRadius: 22,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Data Mahasiswa',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 7),
                            Text(
                              'Kelola informasi mahasiswa dengan mudah.',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: .82),
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 13,
                                vertical: 9,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: .17),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.groups_rounded,
                                    color: Colors.white,
                                    size: 19,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${allDocs.length} mahasiswa terdaftar',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.auto_awesome_rounded,
                        size: 62,
                        color: Colors.white.withValues(alpha: .88),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Direktori mahasiswa',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF172033),
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Pilih kartu untuk melihat atau mengubah data.',
                  style: TextStyle(color: Color(0xFF7B8498)),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _search = value.trim()),
                  decoration: InputDecoration(
                    hintText: 'Cari nama, NIM, kelas, atau prodi...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _search.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Hapus pencarian',
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _search = '');
                            },
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                if (docs.isEmpty)
                  _StateMessage(
                    icon: _search.isEmpty
                        ? Icons.person_search_rounded
                        : Icons.search_off_rounded,
                    title: _search.isEmpty
                        ? 'Belum ada mahasiswa'
                        : 'Data tidak ditemukan',
                    message: _search.isEmpty
                        ? 'Tambahkan data mahasiswa pertama melalui tombol di bawah.'
                        : 'Coba gunakan kata kunci lain.',
                  )
                else
                  ...docs.map((doc) {
                    final data = doc.data();
                    final nim = (data['nim'] ?? doc.id).toString();
                    final nama = (data['nama'] ?? 'Tanpa nama').toString();
                    final kelas = (data['kelas'] ?? '-').toString();
                    final prodi = (data['prodi'] ?? '-').toString();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailData(
                                nim: nim,
                                nama: nama,
                                kelas: kelas,
                                prodi: prodi,
                              ),
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFFE9ECF4),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _StudentAvatar(name: nama),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        nama,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFF202940),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'NIM  $nim',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF737D92),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Wrap(
                                        spacing: 7,
                                        runSpacing: 7,
                                        children: [
                                          _InfoChip(
                                            icon: Icons.class_rounded,
                                            text: 'Kelas $kelas',
                                          ),
                                          _InfoChip(
                                            icon: Icons.school_outlined,
                                            text: prodi,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 3),
                                  child: Icon(
                                    Icons.chevron_right_rounded,
                                    color: Color(0xFF9AA3B5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _StudentAvatar extends StatelessWidget {
  final String name;
  const _StudentAvatar({required this.name});

  @override
  Widget build(BuildContext context) {
    final colors = [
      const Color(0xFF2864F0),
      const Color(0xFF0891B2),
      const Color(0xFF059669),
      const Color(0xFFDB2777),
      const Color(0xFFD97706),
    ];
    final color = colors[name.isEmpty ? 0 : name.codeUnitAt(0) % colors.length];
    final initials = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0].toUpperCase())
        .join();
    return CircleAvatar(
      radius: 27,
      backgroundColor: color.withValues(alpha: .12),
      child: Text(
        initials.isEmpty ? '?' : initials,
        style: TextStyle(
          color: color,
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
    decoration: BoxDecoration(
      color: const Color(0xFFF2F4FA),
      borderRadius: BorderRadius.circular(9),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: const Color(0xFF68738A)),
        const SizedBox(width: 5),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 160),
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF58647A),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}

class _StateMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  const _StateMessage({
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFF2864F0).withValues(alpha: .08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 34, color: const Color(0xFF2864F0)),
        ),
        const SizedBox(height: 14),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 17,
            color: Color(0xFF202940),
          ),
        ),
        const SizedBox(height: 7),
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(height: 1.5, color: Color(0xFF7B8498)),
        ),
      ],
    ),
  );
}
