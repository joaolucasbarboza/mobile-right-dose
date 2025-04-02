import 'package:flutter/material.dart';

class MedicineCardComponent extends StatefulWidget {
  final String name;
  final String unit;
  final int quantity;
  final VoidCallback? onTap;

  const MedicineCardComponent({
    super.key,
    required this.name,
    required this.unit,
    required this.quantity,
    required this.onTap,
  });

  @override
  State<MedicineCardComponent> createState() => _MedicineCardComponentState();
}

class _MedicineCardComponentState extends State<MedicineCardComponent> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.black12,
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedOpacity(
          opacity: _isPressed ? 0.6 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const SizedBox(width: 4),
                    Text(
                      "${widget.quantity} ${widget.unit} restantes",
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
