import 'package:flutter/material.dart';
import 'package:flutter_demo/base/util/app_routes.dart';
import 'package:flutter_demo/base/util/media.dart';
import 'package:flutter_demo/base/util/styles/app_styles.dart';
import 'package:flutter_demo/base/widgets/title_and_link_widget.dart';
import 'package:flutter_demo/base/widgets/heading_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      // backgroundColor: AppStyles.bgColor,
      body: ListView(
        // ListView insists to have only Widget
        // type items, so it can be also scrollable
        children: [
          Center(
            child: Text("StrokeMaster",
            style: AppStyles.logoTitleStyle.copyWith(color: theme.primaryColor),),
          ),
          const SizedBox(
            height: 15,
          ),
          // Container is like <div>. You can (should) decorate it
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.sunny, color: theme.primaryColor,),
                        SizedBox(width: 10,),
                        Text("Good morning", style: AppStyles.headlineStyle3),

                      ],
                    ),

                  ],
                ),

                const SizedBox(height: 20),
                TitleAndLinkWidget(
                  title: 'Upcoming Flights',
                  details: 'View all',
                  func: () =>
                      Navigator.pushNamed(context, AppRoutes.loginPage),
                ),
                const SizedBox(height: 20),
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(

                    )),
                const SizedBox(height: 40),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
