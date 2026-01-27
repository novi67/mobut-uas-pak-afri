import 'package:flutter/material.dart';
import '../core/session.dart';

class UserBadge extends StatelessWidget {
  const UserBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: Session.user(),
      builder: (context, snapshot) {
        final data = snapshot.data ?? {};
        final name = data["name"] ?? "";
        final email = data["email"] ?? "";

        if (name.isEmpty && email.isEmpty) {
          return const SizedBox();
        }

        final display = name.isNotEmpty ? name : email;
        final initial = display.isNotEmpty ? display[0].toUpperCase() : "?";

        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                display,
                style: const TextStyle(fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                radius: 14,
                child: Text(
                  initial,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
