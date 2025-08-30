import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:tcc/ui/core/button_secondary_component.dart';

import '../../../models/user.dart';

class ProfileInfoCard extends StatefulWidget {
  final User user;
  const ProfileInfoCard({super.key, required this.user});

  @override
  State<ProfileInfoCard> createState() => _ProfileInfoCardState();
}

class _ProfileInfoCardState extends State<ProfileInfoCard> {
  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;

    return Card(
      color: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: c.outlineVariant.withOpacity(0.6)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: c.primaryContainer,

                  child: Text(
                    widget.user.name.isNotEmpty ? widget.user.name[0].toUpperCase() : '?',
                    style: TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.user.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.user.email,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color
                              ?.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 32, indent: 0,),
            Column(
              spacing: 12,
              children: [
                ButtonSecondaryComponent(icon: LucideIcons.pencil300, text: "Editar perfil", isLoading: false, onPressed: () {}),
                ButtonSecondaryComponent(
                  icon: LucideIcons.logOut,
                  text: "Sair",
                  isLoading: false,
                  isLogout: true,
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, "/login", (_) => false);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}