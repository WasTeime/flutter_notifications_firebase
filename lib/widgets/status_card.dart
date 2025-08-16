import 'package:flutter/material.dart';

class StatusCard extends StatelessWidget {
  final bool hasPermission;

  const StatusCard({super.key, required this.hasPermission});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final iconColor = hasPermission ? colorScheme.primary : colorScheme.error;
    final backgroundColor = hasPermission
        ? colorScheme.primaryContainer
        : colorScheme.errorContainer;
    final textColor = hasPermission
        ? colorScheme.onPrimaryContainer
        : colorScheme.onErrorContainer;
    final title = hasPermission ? 'Уведомления включены' : 'Нет разрешений';
    final subtitle = hasPermission
        ? 'Готов к получению уведомлений'
        : 'Разрешите уведомления в настройках';
    final iconData = hasPermission
        ? Icons.notifications_active
        : Icons.notifications_off;

    return Card(
      elevation: 0,
      color: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(iconData, color: colorScheme.onPrimary, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: textColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
