import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WordPage extends StatelessWidget {
  const WordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        spacing: 10.0,
        children: [
          IconButton(
            icon: Icon(Icons.bookmark),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Added to collection.")),
              );
            },
          ),
          Text("直す", style: GoogleFonts.shipporiMincho(fontSize: 65.0)),
          Text(
            "(なおす)",
            style: GoogleFonts.shipporiMincho(
              fontSize: 35.0,
              color: Color.fromARGB(201, 0, 0, 0),
            ),
          ),
        ],
      ),
    );
  }
}