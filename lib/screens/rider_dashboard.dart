import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Definisi warna dari tema yang diminta
const Color primaryColor = Color(0xFF33539E);
const Color accentColor1 = Color(0xFF77FAAC);
const Color accentColor2 = Color(0xFFBFB8DA);
const Color accentColor3 = Color(0xFFE8B7D4);
const Color secondaryColor = Color(0xFFA5678E);

// Komponen untuk Rider Dashboard
class RiderDashboard extends StatefulWidget {
  const RiderDashboard({super.key});

  @override
  State<RiderDashboard> createState() => _RiderDashboardState();
}

class _RiderDashboardState extends State<RiderDashboard> {
  // Data dummy
  final String _riderName = 'Firdaus';
  final double _pricePerSurat = 0.50; // RM0.50 per surat
  final TextEditingController _mruController = TextEditingController();
  final TextEditingController _suratController = TextEditingController();
  String? _selectedWeek;

  final List<String> _weeks = [
    'Week 1',
    'Week 2',
    'Week 3',
    'Week 4',
    'Week 5',
  ];

  // Data sejarah MRU dummy
  List<Map<String, dynamic>> _historyData = [
    {'mru_no': 'MRU-001', 'surat': 150, 'gaji': 75.00, 'week': 'Week 1'},
    {'mru_no': 'MRU-002', 'surat': 200, 'gaji': 100.00, 'week': 'Week 1'},
    {'mru_no': 'MRU-003', 'surat': 180, 'gaji': 90.00, 'week': 'Week 2'},
  ];

  // Logik untuk menghantar data MRU baru
  void _submitNewMru() {
    final String mruNo = _mruController.text;
    final int surat = int.tryParse(_suratController.text) ?? 0;

    if (mruNo.isNotEmpty && surat > 0 && _selectedWeek != null) {
      final double gaji = surat * _pricePerSurat;
      setState(() {
        _historyData.add({
          'mru_no': mruNo,
          'surat': surat,
          'gaji': gaji,
          'week': _selectedWeek,
        });
      });
      // Bersihkan input fields
      _mruController.clear();
      _suratController.clear();
      _selectedWeek = null;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data MRU $mruNo telah dihantar!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sila isi semua butiran dengan betul.')),
      );
    }
  }

  // Logik untuk mengedit rekod MRU
  void _editMru(int index) {
    // Logik edit akan dilakukan di sini. Untuk demonstrasi, kita hanya paparkan Snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Mengedit rekod untuk MRU ${_historyData[index]['mru_no']}',
        ),
      ),
    );
  }

  // Logik untuk memadam rekod MRU
  void _deleteMru(int index) {
    setState(() {
      _historyData.removeAt(index);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Rekod telah dipadamkan.')));
  }

  @override
  Widget build(BuildContext context) {
    // Kira gaji terkini
    final double currentGaji = _historyData.fold(
      0.0,
      (sum, item) => sum + (item['gaji'] as double),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard Rider',
          style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false, // Sembunyikan butang "back"
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ringkasan gaji terkini
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: accentColor1,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Gaji Terkini',
                      style: GoogleFonts.ubuntu(
                        fontSize: 18,
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'RM ${currentGaji.toStringAsFixed(2)}',
                      style: GoogleFonts.ubuntu(
                        fontSize: 24,
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24.0),

              // Bahagian untuk hantar data MRU baru
              Text(
                'Hantar Data MRU Baru',
                style: GoogleFonts.ubuntu(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 16.0),
              // Input field untuk Nombor MRU
              TextField(
                controller: _mruController,
                decoration: _inputDecoration('Nombor MRU'),
                style: GoogleFonts.ubuntu(),
              ),
              const SizedBox(height: 16.0),
              // Input field untuk Jumlah Surat
              TextField(
                controller: _suratController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration('Jumlah Surat'),
                style: GoogleFonts.ubuntu(),
              ),
              const SizedBox(height: 16.0),
              // Dropdown untuk Week
              DropdownButtonFormField<String>(
                value: _selectedWeek,
                decoration: _inputDecoration('Pilih Minggu'),
                items: _weeks.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: GoogleFonts.ubuntu()),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedWeek = newValue;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              // Butang Hantar Data Online
              ElevatedButton(
                onPressed: _submitNewMru,
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  textStyle: GoogleFonts.ubuntu(fontWeight: FontWeight.bold),
                ),
                child: const Text('Hantar Data Online'),
              ),
              const SizedBox(height: 24.0),

              // Dropdown untuk fail Excel dan butang muat turun
              Text(
                'Fail Excel dari Admin',
                style: GoogleFonts.ubuntu(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: _inputDecoration('Pilih Fail Excel'),
                      items: const [
                        DropdownMenuItem(
                          value: 'fail_minggu_1',
                          child: Text(
                            'Laporan Minggu 1',
                            style: TextStyle(color: Colors.black87),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'fail_minggu_2',
                          child: Text(
                            'Laporan Minggu 2',
                            style: TextStyle(color: Colors.black87),
                          ),
                        ),
                      ],
                      onChanged: (String? newValue) {
                        // Logik untuk memilih fail
                      },
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Logik untuk muat turun fail...'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      textStyle: GoogleFonts.ubuntu(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Icon(Icons.download),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),

              // Jadual Sejarah MRU
              Text(
                'Sejarah MRU Anda',
                style: GoogleFonts.ubuntu(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 16.0),
              _buildHistoryTable(),
              const SizedBox(height: 24.0),

              // Butang Log Keluar
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Kembali ke skrin login
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    textStyle: GoogleFonts.ubuntu(fontWeight: FontWeight.bold),
                  ),
                  child: const Text('Log Keluar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget bantuan untuk jadual sejarah
  Widget _buildHistoryTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(1.2),
          1: FlexColumnWidth(1),
          2: FlexColumnWidth(1),
          3: FlexColumnWidth(1),
          4: FlexColumnWidth(1.5),
        },
        children: [
          // Header jadual
          TableRow(
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
            ),
            children: [
              _buildTableCell('No. MRU', isHeader: true),
              _buildTableCell('Surat', isHeader: true),
              _buildTableCell('Gaji', isHeader: true),
              _buildTableCell('Minggu', isHeader: true),
              _buildTableCell('Tindakan', isHeader: true),
            ],
          ),
          // Baris data
          ..._historyData.asMap().entries.map((entry) {
            final int index = entry.key;
            final Map<String, dynamic> data = entry.value;
            return TableRow(
              children: [
                _buildTableCell(data['mru_no']),
                _buildTableCell(data['surat'].toString()),
                _buildTableCell('RM ${data['gaji'].toStringAsFixed(2)}'),
                _buildTableCell(data['week']),
                _buildActionButtons(index),
              ],
            );
          }),
        ],
      ),
    );
  }

  // Widget bantuan untuk butang edit dan padam
  Widget _buildActionButtons(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: () => _editMru(index),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _deleteMru(index),
          ),
        ],
      ),
    );
  }

  // Widget bantuan untuk sel jadual
  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        text,
        style: GoogleFonts.ubuntu(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: isHeader ? primaryColor : Colors.black87,
        ),
      ),
    );
  }

  // Widget bantuan untuk membuat input field yang konsisten
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.ubuntu(color: primaryColor),
      filled: true,
      fillColor: accentColor2.withOpacity(0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: primaryColor, width: 2.0),
      ),
    );
  }
}
