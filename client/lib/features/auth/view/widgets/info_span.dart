import 'package:client/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class InfoSpan extends StatelessWidget {
  final String message;
  final String routeName;
  const InfoSpan({super.key, required this.message, required this.routeName});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: message,
        style: Theme.of(context).textTheme.titleMedium,
        children: [
          TextSpan(
            text: routeName,
            style: TextStyle(
              color: Pallete.gradient2,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
