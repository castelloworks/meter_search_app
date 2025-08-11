import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import untuk fungsi pick file
import 'package:file_picker/file_picker.dart';

// Definisi warna dari tema yang diminta
const Color primaryColor = Color(0xFF33539E);
const Color accentColor1 = Color(0xFF77FAAC);
const Color accentColor2 = Color(0xFFBFB8DA);
const Color accentColor3 = Color(0xFFE8B7D4);
const Color secondaryColor = Color(0xFFA5678E);

// Komponen untuk Admin Dashboard
class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  // Data dummy untuk semua rider
  final List<Map<String, dynamic>> _allMruData = [
    {'rider': 'Firdaus', 'mru_no': 'MRU-001', 'surat': 150, 'gaji': 75.00},
    {'rider': 'Fitri', 'mru_no': 'MRU-002', 'surat': 200, 'gaji': 100.00},
    {'rider': 'Firdaus', 'mru_no': 'MRU-003', 'surat': 180, 'gaji': 90.00},
    {'rider': 'Fitri', 'mru_no': 'MRU-004', 'surat': 220, 'gaji': 110.00},
  ];

  // Status muat naik fail
  String _uploadStatus = '';
  String _selectedFileName = 'Pilih Fail Excel';

  // Logik untuk muat naik fail excel
  void _uploadExcelFile() {
    // Logik muat naik fail akan berada di sini.
    // Buat masa ini, kita hanya simulasi dengan Snackbar.
    if (_selectedFileName != 'Pilih Fail Excel') {
      setState(() {
        _uploadStatus = 'Fail $_selectedFileName berjaya dimuat naik!';
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_uploadStatus)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sila pilih fail terlebih dahulu.')),
      );
    }
  }

  // Logik untuk memilih fail dari lokal
  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result != null) {
      setState(() {
        _selectedFileName = result.files.single.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Kira jumlah surat dan gaji terkini dari data dummy
    final int totalSuratFirdaus = _allMruData
        .where((data) => data['rider'] == 'Firdaus')
        .fold(0, (sum, item) => sum + (item['surat'] as int));
    final double totalGajiFirdaus = _allMruData
        .where((data) => data['rider'] == 'Firdaus')
        .fold(0.0, (sum, item) => sum + (item['gaji'] as double));

    final int totalSuratFitri = _allMruData
        .where((data) => data['rider'] == 'Fitri')
        .fold(0, (sum, item) => sum + (item['surat'] as int));
    final double totalGajiFitri = _allMruData
        .where((data) => data['rider'] == 'Fitri')
        .fold(0.0, (sum, item) => sum + (item['gaji'] as double));

    // Pisahkan data mengikut rider
    final List<Map<String, dynamic>> firdausData = _allMruData
        .where((data) => data['rider'] == 'Firdaus')
        .toList();
    final List<Map<String, dynamic>> fitriData = _allMruData
        .where((data) => data['rider'] == 'Fitri')
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Dashboard',
          style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ringkasan Jumlah Surat dan Gaji Rider Firdaus
              Text(
                'Ringkasan untuk Firdaus',
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
                    child: _buildSummaryCard(
                      'Jumlah Surat',
                      totalSuratFirdaus.toString(),
                      accentColor1,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSummaryCard(
                      'Jumlah Gaji',
                      'RM ${totalGajiFirdaus.toStringAsFixed(2)}',
                      accentColor1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),

              // Ringkasan Jumlah Surat dan Gaji Rider Fitri
              Text(
                'Ringkasan untuk Fitri',
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
                    child: _buildSummaryCard(
                      'Jumlah Surat',
                      totalSuratFitri.toString(),
                      accentColor1,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSummaryCard(
                      'Jumlah Gaji',
                      'RM ${totalGajiFitri.toStringAsFixed(2)}',
                      accentColor1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),

              // Bahagian Butang Laporan
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12.0,
                  runSpacing: 12.0,
                  children: [
                    _buildReportButton('Cipta Laporan', secondaryColor),
                    _buildReportButton('Eksport PDF', secondaryColor),
                    _buildReportButton('Eksport CSV', secondaryColor),
                    _buildReportButton('Cetak Laporan', secondaryColor),
                  ],
                ),
              ),
              const SizedBox(height: 24.0),

              // Bahagian Muat Naik Fail Excel
              Text(
                'Muat Naik Fail Excel',
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
                    child: ElevatedButton(
                      onPressed: _pickFile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor2.withOpacity(0.5),
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: Text(
                        _selectedFileName,
                        style: GoogleFonts.ubuntu(color: primaryColor),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  ElevatedButton(
                    onPressed: _uploadExcelFile,
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
                    child: const Text('Muat Naik'),
                  ),
                ],
              ),
              if (_uploadStatus.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    _uploadStatus,
                    style: GoogleFonts.ubuntu(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(height: 24.0),

              // Jadual untuk Rider Firdaus
              Text(
                'Senarai MRU (Rider Firdaus)',
                style: GoogleFonts.ubuntu(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 16.0),
              _buildMruTable(firdausData),
              const SizedBox(height: 24.0),

              // Jadual untuk Rider Fitri
              Text(
                'Senarai MRU (Rider Fitri)',
                style: GoogleFonts.ubuntu(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 16.0),
              _buildMruTable(fitriData),
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

  // Widget bantuan untuk kad ringkasan
  Widget _buildSummaryCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: color,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.ubuntu(
              fontSize: 16,
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.ubuntu(
              fontSize: 20,
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Widget bantuan untuk butang laporan
  Widget _buildReportButton(String text, Color color) {
    return ElevatedButton(
      onPressed: () {
        // Logik untuk setiap butang
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Butang $text ditekan.')));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: GoogleFonts.ubuntu(fontWeight: FontWeight.bold),
      ),
      child: Text(text),
    );
  }

  // Widget bantuan untuk jadual MRU
  Widget _buildMruTable(List<Map<String, dynamic>> data) {
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
            ],
          ),
          // Baris data
          ...data.map((item) {
            return TableRow(
              children: [
                _buildTableCell(item['mru_no']),
                _buildTableCell(item['surat'].toString()),
                _buildTableCell('RM ${item['gaji'].toStringAsFixed(2)}'),
              ],
            );
          }),
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
}
