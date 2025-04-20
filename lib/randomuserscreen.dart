import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RandomUserScreen extends StatefulWidget {
  const RandomUserScreen({super.key});

  @override
  State<RandomUserScreen> createState() => _RandomUserScreenState();
}

class _RandomUserScreenState extends State<RandomUserScreen> {
  Map<String, dynamic>? user;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchRandomUser();
  }

  Future<void> fetchRandomUser() async {
    setState(() {
      errorMessage = '';
      user = null;
    });

    try {
      final response = await http.get(Uri.parse('https://randomuser.me/api/'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          user = data['results'][0];
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load data.';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 36, 80, 133), // Soft cool background
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: errorMessage.isNotEmpty
                ? Text(errorMessage, style: const TextStyle(color: Colors.red))
                : user == null
                    ? const CircularProgressIndicator()
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Column(
                                children: [
                                  // Top section with image & name
                                  Container(
                                    width: double.infinity,
                                    color: const Color.fromARGB(116, 6, 0, 120),
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 20),
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          radius: 40,
                                          backgroundImage: NetworkImage(
                                              user!['picture']['large']),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          "${user!['name']['title']} ${user!['name']['first']} ${user!['name']['last']} | ${user!['gender']}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Bottom section with details
                                  Container(
                                    width: double.infinity,
                                    color: const Color.fromARGB(255, 147, 194, 255),
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InfoTile(
                                          icon: Icons.email,
                                          label: user!['email'],
                                        ),
                                        const SizedBox(height: 12),
                                        InfoTile(
                                          icon: Icons.phone,
                                          label: user!['phone'],
                                        ),
                                        const SizedBox(height: 12),
                                        InfoTile(
                                          icon: Icons.location_on,
                                          label: user!['location']['country'],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // New User Button
                          ElevatedButton.icon(
                            onPressed: fetchRandomUser,
                            icon: const Icon(Icons.refresh),
                            label: const Text("Load Another User"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 14, 9, 141),
                              foregroundColor: const Color.fromARGB(255, 203, 211, 216),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              textStyle: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
          ),
        ),
      ),
    );
  }
}

// Info tile widget with icon + label
class InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;

  const InfoTile({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 44, 149, 219),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
