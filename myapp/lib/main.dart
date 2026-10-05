import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const BiodataApp());
}

class BiodataApp extends StatelessWidget {
  const BiodataApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Biodata System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.blue,
              width: 2,
            ),
          ),
        ),
      ),
      home: const BiodataPage(),
    );
  }
}

class BiodataPage extends StatefulWidget {
  const BiodataPage({super.key});

  @override
  State<BiodataPage> createState() => _BiodataPageState();
}

class _BiodataPageState extends State<BiodataPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController fullNameController =
      TextEditingController();

  final TextEditingController ageController =
      TextEditingController();

  final TextEditingController birthDateController =
      TextEditingController();

  final TextEditingController genderController =
      TextEditingController();

  final TextEditingController addressController =
      TextEditingController();

  final TextEditingController contactController =
      TextEditingController();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController nationalityController =
      TextEditingController();

  final TextEditingController civilStatusController =
      TextEditingController();

  final TextEditingController occupationController =
      TextEditingController();

  bool isSaving = false;

  // SAVE BIODATA TO FIREBASE
  Future<void> saveBiodata() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await FirebaseFirestore.instance.collection('biodata').add({
        'fullName': fullNameController.text.trim(),
        'age': ageController.text.trim(),
        'birthDate': birthDateController.text.trim(),
        'gender': genderController.text.trim(),
        'address': addressController.text.trim(),
        'contactNumber': contactController.text.trim(),
        'email': emailController.text.trim(),
        'nationality': nationalityController.text.trim(),
        'civilStatus': civilStatusController.text.trim(),
        'occupation': occupationController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      clearFields();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Biodata saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving biodata: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  // CLEAR ALL INPUTS
  void clearFields() {
    fullNameController.clear();
    ageController.clear();
    birthDateController.clear();
    genderController.clear();
    addressController.clear();
    contactController.clear();
    emailController.clear();
    nationalityController.clear();
    civilStatusController.clear();
    occupationController.clear();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    ageController.dispose();
    birthDateController.dispose();
    genderController.dispose();
    addressController.dispose();
    contactController.dispose();
    emailController.dispose();
    nationalityController.dispose();
    civilStatusController.dispose();
    occupationController.dispose();

    super.dispose();
  }

  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
    bool requiredField = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != null ? Icon(icon) : null,
        ),
        validator: requiredField
            ? (value) {
                if (value == null || value.trim().isEmpty) {
                  return '$label is required';
                }
                return null;
              }
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BIODATA FORM',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // HEADER
              const Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.person,
                      size: 70,
                      color: Colors.blue,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Personal Information',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Please fill out the information below.',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // FULL NAME
              buildTextField(
                label: 'Full Name',
                controller: fullNameController,
                icon: Icons.person,
              ),

              // AGE
              buildTextField(
                label: 'Age',
                controller: ageController,
                icon: Icons.cake,
                keyboardType: TextInputType.number,
              ),

              // DATE OF BIRTH
              buildTextField(
                label: 'Date of Birth',
                controller: birthDateController,
                icon: Icons.calendar_today,
              ),

              // GENDER
              buildTextField(
                label: 'Gender',
                controller: genderController,
                icon: Icons.wc,
              ),

              // ADDRESS
              buildTextField(
                label: 'Address',
                controller: addressController,
                icon: Icons.home,
              ),

              // CONTACT
              buildTextField(
                label: 'Contact Number',
                controller: contactController,
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),

              // EMAIL
              buildTextField(
                label: 'Email Address',
                controller: emailController,
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),

              // NATIONALITY
              buildTextField(
                label: 'Nationality',
                controller: nationalityController,
                icon: Icons.flag,
              ),

              // CIVIL STATUS
              buildTextField(
                label: 'Civil Status',
                controller: civilStatusController,
                icon: Icons.favorite,
              ),

              // OCCUPATION
              buildTextField(
                label: 'Occupation',
                controller: occupationController,
                icon: Icons.work,
              ),

              const SizedBox(height: 10),

              // SAVE BUTTON
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: isSaving ? null : saveBiodata,
                  icon: isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save),
                  label: Text(
                    isSaving ? 'Saving...' : 'SAVE BIODATA',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // CLEAR BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: clearFields,
                  icon: const Icon(Icons.clear),
                  label: const Text(
                    'CLEAR',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // FIREBASE STATUS
              const Divider(),

              const SizedBox(height: 10),

              const Center(
                child: Text(
                  'Firebase Cloud Firestore Connected',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}