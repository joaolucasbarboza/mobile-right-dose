import 'package:flutter/material.dart';

class DetailsMedicine extends StatefulWidget {
  const DetailsMedicine({super.key});

  @override
  State<DetailsMedicine> createState() => _DetailsMedicineState();
}

class _DetailsMedicineState extends State<DetailsMedicine> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("Detalhes medicamento"),
      ),
    );
  }
}
