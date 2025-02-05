import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:jewelbook_calculator/ui/dashboard/dashboard.dart';
import 'package:jewelbook_calculator/ui/mobile_scanner/qr_code_scanner.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widget/DefaultTextField.dart';
import 'package:http/http.dart' as http;

class IssueItemScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  const IssueItemScreen({Key? key, required this.data}) : super(key: key);
  @override
  _IssueItemScreenState createState() => _IssueItemScreenState();
}

class _IssueItemScreenState extends State<IssueItemScreen> {
  String t_id = "";
  bool isEdit = true;
  static const platform =
      MethodChannel('com.example.jewelbook_bapa/android_id');
  // Static values
  final String selectedItem = 'Butti';
  late String weight;
  late String less;
  late String touch;
  late String wastage;
  List<String> partySuggestions = [];
  bool isLoading = false;

  final TextEditingController weightTxtController = TextEditingController();
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController lessTxtController = TextEditingController();
  final TextEditingController addTxtController = TextEditingController();
  final TextEditingController touchTxtController = TextEditingController();
  final TextEditingController wastageTxtController = TextEditingController();
  final TextEditingController dateTxtController = TextEditingController();
  final TextEditingController notesTxtController = TextEditingController();
  final TextEditingController partyNameController = TextEditingController();
  // Controllers for net weight and fine
  final TextEditingController netWeightController = TextEditingController();
  final TextEditingController fineController = TextEditingController();

  // final AutofillDataController _autofillDataController = Get.find();

  @override
  void initState() {
    super.initState();
    // Set initial values
    itemNameController.text = selectedItem;
    weight = widget.data["rfid_grwt"].toString();
    less = widget.data["rfid_less"].toString();
    touch = widget.data["rfid_tunch"].toString();
    wastage = widget.data["wastage"].toString();
    weightTxtController.text = weight;
    lessTxtController.text = less;
    touchTxtController.text = touch;
    wastageTxtController.text = wastage;
    dateTxtController.text = _getCurrentDate(); // Default date value

    // Calculate initial net weight and fine
    _updateNetWeight();
    _updateFine();
  }

  Future<void> fetchPartyNames(String query) async {
    if (query.isEmpty) {
      setState(() {
        partySuggestions = [];
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token == null) {
      print("Token not found!");
      return;
    }

    final String url = 'http://20.244.92.124/bapaapi/public/api/party_list';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token', // Replace with your token
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print(data);
      if (data['status'] == 1) {
        setState(() {
          partySuggestions = List<String>.from(
            data['records']['data'].map((party) => party['account_name']),
          );
        });
      }
    } else {
      // Handle error
      setState(() {
        partySuggestions = [];
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchAndWhatsappPdf() async {
    final String apiUrl = "http://20.244.92.124/bapaapi/public/api/get_pdf";

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      if (token == null) {
        print("Token not found!");
        return;
      }

      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      request.fields['sell_id'] = '125';

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print("API Response: $data");

        if (data.containsKey('pdf')) {
          String pdfUrl = data['pdf']; // Get PDF URL from the API response.

          // Download the PDF and save it locally.
          final tempDir = await getTemporaryDirectory();
          final String pdfPath = '${tempDir.path}/dynamic_bill.pdf';

          var pdfResponse = await http.get(Uri.parse(pdfUrl));
          if (pdfResponse.statusCode == 200) {
            final file = File(pdfPath);
            await file.writeAsBytes(pdfResponse.bodyBytes);

            // Share the PDF to WhatsApp using the native method.
            try {
              await platform.invokeMethod(
                'shareToWhatsApp',
                {'pdfPath': pdfPath},
              );
            } on PlatformException catch (e) {
              print("Failed to share PDF to WhatsApp: ${e.message}");
            }
          } else {
            print("Failed to download the PDF: ${pdfResponse.statusCode}");
          }
        } else {
          print("PDF URL not found in response!");
        }
      } else {
        print("API Error: ${response.statusCode}, ${response.body}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  Future<String?> fetchAndSharePdf() async {
    final String apiUrl = "http://20.244.92.124/bapaapi/public/api/get_pdf";

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      if (token == null) {
        print("Token not found!");
        return null;
      }

      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      request.fields['sell_id'] = '125';

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print("API Response: $data");

        if (data.containsKey('pdf')) {
          String pdfUrl = data['pdf']; // PDF URL from API response
          return await downloadAndSharePdf(pdfUrl);
        } else {
          print("PDF URL not found in response!");
        }
      } else {
        print("API Error: ${response.statusCode}, ${response.body}");
      }
    } catch (e) {
      print("Exception: $e");
    }
    return null;
  }

  Future<String?> downloadAndSharePdf(String pdfUrl) async {
    try {
      final response = await http.get(Uri.parse(pdfUrl));

      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = "${directory.path}/downloaded.pdf";
        File pdfFile = File(filePath);
        await pdfFile.writeAsBytes(response.bodyBytes);

        print("PDF Downloaded at: $filePath");

        // Share the PDF file
        await Share.shareXFiles([XFile(filePath)],
            text: 'Here is your PDF file.');

        return filePath;
      } else {
        print("Failed to download PDF: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception while downloading PDF: $e");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: _appBar(context),
        body: _body(context),
      ),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      elevation: 10.0,
      backgroundColor: Colors.white,
      titleSpacing: 0,
      leading: Builder(
        builder: (context) {
          return InkWell(
            onTap: () {},
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 25,
            ),
          );
        },
      ),
      title: const Text(
        'Issue Item',
        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
      ),
    );
  }

  Widget _body(BuildContext context) {
    weightTxtController.addListener(() {
      _updateNetWeight();
    });

    lessTxtController.addListener(() {
      _updateNetWeight();
    });

    addTxtController.addListener(() {
      _updateNetWeight();
    });

    touchTxtController.addListener(() {
      _updateFine();
    });

    wastageTxtController.addListener(() {
      _updateFine();
    });

    return SingleChildScrollView(
      child: Column(
        children: [
          TextFormField(
            controller: partyNameController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: "Party Name",
              hintText: "Enter Party Name",
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              fetchPartyNames(value);
            },
          ),
          if (isLoading) Center(child: CircularProgressIndicator()),
          if (partySuggestions.isNotEmpty)
            Container(
              constraints:
                  BoxConstraints(maxHeight: 200), // List ka height limit
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 4)],
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: partySuggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(partySuggestions[index]),
                    onTap: () {
                      setState(() {
                        partyNameController.text = partySuggestions[index];
                        partySuggestions.clear(); // Suggestions ko clear karna
                      });
                    },
                  );
                },
              ),
            ),
          DefaultTextField(
              hint_txt: "Enter Item",
              label_txt: "Item",
              keyboard_type: TextInputType.text,
              txtController: itemNameController,
              textInputAction: TextInputAction.next),
          DefaultTextField(
              hint_txt: "Enter Weight",
              label_txt: "Weight",
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}'))
              ],
              keyboard_type: TextInputType.number,
              txtController: weightTxtController,
              textInputAction: TextInputAction.next),
          DefaultTextField(
              hint_txt: "Enter Less",
              label_txt: "Less",
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}'))
              ],
              keyboard_type: TextInputType.number,
              txtController: lessTxtController,
              textInputAction: TextInputAction.next),
          DefaultTextField(
              hint_txt: "Enter Add",
              label_txt: "Add",
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}'))
              ],
              keyboard_type: TextInputType.number,
              txtController: addTxtController,
              textInputAction: TextInputAction.next),
          DefaultTextField(
              hint_txt: "Net Wt.",
              label_txt: "Net Wt.",
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}'))
              ],
              keyboard_type: TextInputType.number,
              txtController: netWeightController,
              enabled: false,
              textInputAction: TextInputAction.next),
          DefaultTextField(
              hint_txt: "Enter Touch",
              label_txt: "Touch",
              keyboard_type: TextInputType.text,
              txtController: touchTxtController,
              textInputAction: TextInputAction.next),
          DefaultTextField(
              hint_txt: "Enter Wastage",
              label_txt: "Wastage",
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
              ],
              keyboard_type: TextInputType.number,
              txtController: wastageTxtController,
              textInputAction: TextInputAction.next),
          DefaultTextField(
              hint_txt: "Fine",
              label_txt: "Fine",
              keyboard_type: TextInputType.number,
              txtController: fineController,
              enabled: false,
              textInputAction: TextInputAction.next),
          InkWell(
            onTap: () => _selectDate(context),
            child: IgnorePointer(
              child: DefaultTextField(
                hint_txt: "Date",
                label_txt: "Date",
                keyboard_type: TextInputType.number,
                txtController: dateTxtController,
              ),
            ),
          ),
          DefaultTextField(
              hint_txt: "Enter Notes",
              label_txt: "Notes",
              keyboard_type: TextInputType.text,
              txtController: notesTxtController,
              textInputAction: TextInputAction.next),
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Dashboard(),
                      ),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange.shade900,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(
                    Icons.save,
                    color: Colors.white,
                  ),
                  label: const Text("Save"),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () async {
                    await fetchAndWhatsappPdf();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange.shade900,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(
                    Icons.print,
                    color: Colors.white,
                  ),
                  label: const Text("Save & Send to Whatsapp"),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () async {
                    await fetchAndSharePdf();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange.shade900,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(
                    Icons.print,
                    color: Colors.white,
                  ),
                  label: const Text("Save & Share"),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  void _updateNetWeight() {
    double weight = double.tryParse(weightTxtController.text) ?? 0.0;
    double less = double.tryParse(lessTxtController.text) ?? 0.0;
    double add = double.tryParse(addTxtController.text) ?? 0.0;

    double netWeight = weight - less + add;

    netWeightController.text =
        netWeight.toStringAsFixed(3); // Update the net weight controller
    _updateFine(); // Update fine whenever net weight changes
  }

  void _updateFine() {
    double netWeight = double.tryParse(netWeightController.text) ?? 0.0;
    double touch = double.tryParse(touchTxtController.text) ?? 0.0;
    double wastage = double.tryParse(wastageTxtController.text) ?? 0.0;

    double fine = netWeight * (touch + wastage) / 100;

    fineController.text = fine.toStringAsFixed(3); // Update the fine controller
  }

  // Method to get the current date in DD-MM-YYYY format
  String _getCurrentDate() {
    DateTime now = DateTime.now();
    return DateFormat('dd-MM-yyyy')
        .format(now); // Format the date as DD-MM-YYYY
  }

  // Method to select a date and display it in DD-MM-YYYY format
  Future<void> _selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (selectedDate != null) {
      dateTxtController.text = DateFormat('dd-MM-yyyy').format(selectedDate);
    }
  }
}
