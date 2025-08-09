import 'package:flutter/widgets.dart';
import 'package:tcc/utils/custom_text_style.dart';

class HistoryNotifications extends StatefulWidget {
  const HistoryNotifications({super.key});

  @override
  State<HistoryNotifications> createState() => _HistoryNotificationsState();
}

class _HistoryNotificationsState extends State<HistoryNotifications> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Histórico de lembretes",
          style: customTextLabelPrimary(),
        )
      ],
    );
  }
}
