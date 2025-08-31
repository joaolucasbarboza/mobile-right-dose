import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc/models/prescription_notification.dart';
import 'package:tcc/ui/notification/view_models/get_by_id_prescription_notification_view_model.dart';
import 'package:tcc/ui/notification/widgets/show_tap_notification.dart';

class NotificationSheetRoute extends StatefulWidget {
  const NotificationSheetRoute({super.key});

  @override
  State<NotificationSheetRoute> createState() => _NotificationSheetRouteState();
}

class _NotificationSheetRouteState extends State<NotificationSheetRoute> {
  bool _opened = false; // evita abrir o sheet mais de uma vez

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _opened) return;
      _opened = true;

      final arg = ModalRoute.of(context)?.settings.arguments;
      final String idStr = arg is String ? arg : arg.toString();
      _openSheet(idStr);
    });
  }

  Future<void> _openSheet(String notificationIdStr) async {
    final id = int.tryParse(notificationIdStr);
    if (id == null) {
      _failAndClose("ID inválido: $notificationIdStr");
      return;
    }

    try {
      final vm = context.read<GetNotificationByIdViewModel>();
      final PrescriptionNotification? notif = await vm.fetchById(id);

      if (!mounted) return;

      if (notif == null) {
        _failAndClose(vm.error ?? "Não foi possível carregar o lembrete.");
        return;
      }

      await showNotificationBottomSheet(context, notif);
    } catch (e) {
      if (!mounted) return;
      _failAndClose("Erro ao abrir lembrete: $e");
      return;
    }

    if (mounted) Navigator.pop(context);
  }

  void _failAndClose(String msg) {
    final ctx = context;
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.redAccent),
    );
    Navigator.pop(ctx);
  }

  @override
  Widget build(BuildContext context) {
    // Rota transparente; nada visível aqui.
    return const Scaffold(backgroundColor: Colors.transparent);
  }
}