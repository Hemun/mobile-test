import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:last_exam/provider/authProvider.dart';
import 'package:last_exam/model/LanguagePreferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _selectedLanguageCode = '';

  @override
  void initState() {
    super.initState();
    _loadLanguagePreferences();
  }

  // Load saved language preferences
  Future<void> _loadLanguagePreferences() async {
    final languageCode = await LanguagePreferences.getLanguageCode();
    setState(() {
      _selectedLanguageCode = languageCode ?? 'en'; // Default language code
    });
  }

  // Save language preferences and update the UI
  Future<void> _saveLanguagePreferences(String languageCode) async {
    await LanguagePreferences.setLanguageCode(languageCode);
    setState(() {
      _selectedLanguageCode = languageCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Language:'),
            DropdownButton<String>(
              value: _selectedLanguageCode,
              onChanged: (String? newValue) {
                _saveLanguagePreferences(newValue!);
              },
              items: <String>['en', 'mn'] // Add more languages as needed
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const Text(
              'Name:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${user?.name.firstname} ${user?.name.lastname}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Email:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${user?.email}',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Phone:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${user?.phone}',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Address:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'City: ${user?.address.city}',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  'Street: ${user?.address.street}',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  'Number: ${user?.address.number}',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  'Zipcode: ${user?.address.zipcode}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
