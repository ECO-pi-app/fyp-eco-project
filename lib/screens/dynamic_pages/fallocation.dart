import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DynamicAllocation extends StatefulWidget {
  const DynamicAllocation({super.key});

  @override
  State<DynamicAllocation> createState() => _DynamicAllocationState();
}

class _DynamicAllocationState extends State<DynamicAllocation> {
  final TextEditingController powerController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController efController = TextEditingController();

  String? result;
  List<dynamic> tableData = [];

  static const String apiBaseUrl = "http://127.0.0.1:8000/calculate/material_emission";

  Future<void> calculateAndSend() async {
    final url = Uri.parse("$apiBaseUrl");

    final data = {
      "country": "Belgium",
      "material": "Steel",
      "mass_kg": 20,
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      setState(() => result = json["calculated_emission"].toString());
    }
  }

  Future<void> fetchTableData() async {
    final url = Uri.parse("$apiBaseUrl");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() => tableData = jsonDecode(response.body));
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Emissions Calculator")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: powerController,
              decoration: const InputDecoration(labelText: "Power (kW)"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: timeController,
              decoration: const InputDecoration(labelText: "Time (hours)"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: efController,
              decoration: const InputDecoration(labelText: "Emission Factor"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: calculateAndSend,
              child: const Text("Calculate & Save"),
            ),
            const SizedBox(height: 20),
            if (result != null)
              Text("Latest Emissions: $result kg CO₂e",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: tableData.length,
                itemBuilder: (context, index) {
                  final row = tableData[index];
                  return ListTile(
                    title: Text(
                      "Power: ${row["power_kW"]}, Time: ${row["time_hr"]}",
                    ),
                    subtitle: Text(
                        "EF: ${row["emission_factor"]}, Emissions: ${row["emissions"]}"),
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
