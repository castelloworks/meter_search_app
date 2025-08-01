import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MeterSearchApp());
}

class MeterSearchApp extends StatelessWidget {
  const MeterSearchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartMeterLocator',
      theme: ThemeData.dark(), // Sentiasa dark mode
      home: const MeterSearchPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MeterSearchPage extends StatefulWidget {
  const MeterSearchPage({super.key});

  @override
  State<MeterSearchPage> createState() => _MeterSearchPageState();
}

class _MeterSearchPageState extends State<MeterSearchPage> {
  final TextEditingController _controller = TextEditingController();
  Map<String, dynamic>? meterData;
  List<String> history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      history = prefs.getStringList('history') ?? [];
    });
  }

  Future<void> _saveToHistory(String meter) async {
    final prefs = await SharedPreferences.getInstance();
    history.remove(meter); // Elak duplikasi
    history.insert(0, meter); // Masuk paling atas
    if (history.length > 10) history = history.sublist(0, 10);
    await prefs.setStringList('history', history);
    setState(() {});
  }

  Future<void> _clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('history');
    setState(() {
      history.clear();
    });
  }

  Future<void> _searchMeter() async {
    final input = _controller.text.trim().toUpperCase();

    final jsonString = await rootBundle.loadString(
      'assets/lokasi_meter.json',
    ); // <-- Guna semula nama fail asal
    final data = json.decode(jsonString);
    print(data); // Debug: lihat struktur sebenar

    final metersRaw = data['template_meters_exported'];
    final List meters = metersRaw is List
        ? metersRaw
        : (metersRaw is Map ? metersRaw.values.toList() : []);
    print(meters); // Debug: pastikan ini adalah List<Map>
    final result = meters.whereType<Map<String, dynamic>>().firstWhere(
      (item) =>
          item.containsKey('METER') &&
          (item['METER'] as String).toUpperCase() == input,
      orElse: () => <String, dynamic>{}, // Return empty map jika tiada
    );

    setState(() {
      meterData = result.isNotEmpty ? result : null;
    });
    await _saveToHistory(input);
  }

  Future<void> _openInMaps(String lat, String long) async {
    final url = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$lat,$long",
    );
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal buka Google Maps')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartMeterLocator'),
        // Tiada actions (toggle button) lagi
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _controller,
              keyboardType: TextInputType.text, // <-- Tukar dari number ke text
              decoration: InputDecoration(
                labelText: 'Masukkan Nombor Meter',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchMeter,
                ),
              ),
              onSubmitted: (_) => _searchMeter(),
            ),
            const SizedBox(height: 20),
            if (meterData != null) ...[
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nama: ${meterData!['NAME']}'),
                      Text('Latitude: ${meterData!['LAT']}'),
                      Text('Longitude: ${meterData!['LONG']}'),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.map),
                        label: const Text("Buka Lokasi di Google Maps"),
                        onPressed: () =>
                            _openInMaps(meterData!['LAT'], meterData!['LONG']),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
            if (history.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Sejarah Carian:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: _clearHistory,
                    child: const Text("Clear"),
                  ),
                ],
              ),
              ...history.map(
                (meter) => ListTile(
                  title: Text(meter),
                  trailing: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      _controller.text = meter;
                      _searchMeter();
                    },
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
