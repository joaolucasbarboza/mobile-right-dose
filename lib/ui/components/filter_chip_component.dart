import 'package:flutter/material.dart';

class FilterChipComponent extends StatefulWidget {
  final String label;
  final bool selected;

  const FilterChipComponent(
      {super.key, required this.label, this.selected = false});

  @override
  State<FilterChipComponent> createState() => _FilterChipComponentState();
}

class _FilterChipComponentState extends State<FilterChipComponent> {
  bool _selected = false;

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      elevation: 0,
      label: Text(widget.label),
      selected: _selected,
      selectedColor: Colors.green[300],
      backgroundColor: Colors.transparent,
      checkmarkColor: Colors.black,
      onSelected: (bool value) {
        setState(() {
          _selected = value;
        });
      },
    );
  }
}
