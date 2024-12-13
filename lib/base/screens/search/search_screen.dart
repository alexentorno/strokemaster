import 'package:flutter/material.dart';
import 'package:flutter_demo/base/screens/search/widgets/find_button.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Scaffold(
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            children: const [

              SizedBox(
                height: 25,
              ),
              SearchButton(),
              SizedBox(
                height: 25,
              ),


            ],
          ),
        ),
      ),
    );
  }
}
