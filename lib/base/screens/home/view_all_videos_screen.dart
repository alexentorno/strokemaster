import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewAllVideosScreen extends StatelessWidget {
  const ViewAllVideosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
          title: const Text("Today\'s top exercises"),

      ),
    );
  }
}
