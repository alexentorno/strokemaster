import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stroke_master/base/util/styles/app_styles.dart';
import 'package:stroke_master/base/widgets/show_logo.dart';

class ProgressLogScreen extends StatelessWidget {
  const ProgressLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
        color: theme.scaffoldBackgroundColor,
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 15),
            children: [
              ShowLogo(),
              Text("Logs",
                  style: AppStyles.appBarTitleStyle.copyWith(color: theme.primaryColorLight),
              ),
                
            ],
          ),
        ),
      
    );
  }
}
