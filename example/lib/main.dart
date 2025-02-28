import 'package:flutter/material.dart';
import 'package:flutter_offline_data_sync/src/local_storage/local_db.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    debugPrint("Initializing LocalDB...");
    await LocalDB.init(); // Ensure LocalDB initializes properly
    debugPrint("LocalDB Initialized Successfully!");
  } catch (e) {
    debugPrint("Error initializing LocalDB: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String storedData = "No Data";
  final TextEditingController _controller = TextEditingController();
  bool isLoading = true; // Track initialization state

  @override
  void initState() {
    super.initState();
    _loadDataOnStart();
  }

  Future<void> _loadDataOnStart() async {
    try {
      debugPrint("Loading stored data...");
      String? value = await LocalDB.getData('example_key');
      setState(() {
        storedData = value ?? "No Data Found";
        isLoading = false;
      });
      debugPrint("Stored data loaded successfully: $storedData");
    } catch (e) {
      debugPrint("Error loading data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _saveData() async {
    try {
      String value = _controller.text;
      debugPrint("Saving data: $value...");
      await LocalDB.saveData('example_key', value);
      setState(() {
        storedData = value;
      });
      debugPrint("Data saved successfully!");
    } catch (e) {
      debugPrint("Error saving data: $e");
    }
  }

  Future<void> _loadData() async {
    try {
      debugPrint("Fetching stored data...");
      String? value = await LocalDB.getData('example_key');
      setState(() {
        storedData = value ?? "No Data Found";
      });
      debugPrint("Data retrieved: $storedData");
    } catch (e) {
      debugPrint("Error retrieving data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Offline Data Sync Example')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isLoading
              ? const Center(child: CircularProgressIndicator()) // Show loading spinner
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _controller,
                      decoration: const InputDecoration(labelText: 'Enter Data'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(onPressed: _saveData, child: const Text('Save Data')),
                    ElevatedButton(onPressed: _loadData, child: const Text('Load Data')),
                    const SizedBox(height: 20),
                    Text('Stored Data: $storedData', style: const TextStyle(fontSize: 16)),
                  ],
                ),
        ),
      ),
    );
  }
}
