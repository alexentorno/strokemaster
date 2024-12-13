import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/base/util/media.dart';
import 'package:flutter_demo/base/util/styles/app_styles.dart';
import 'package:flutter_demo/base/widgets/heading_text.dart';
import 'package:flutter_demo/theme/theme.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("Your profile",
        style: AppStyles.appBarTitleStyle.copyWith(color: theme.primaryColorLight),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          const Padding(padding: EdgeInsets.only(top: 15)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // showing user avatar
              Container(
                margin: const EdgeInsets.only(right: 10),
                width: 85,
                height: 85,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image:
                      const DecorationImage(image: AssetImage(AppMedia.defaultProfile)),
                ),
              ),
              // showing column text next to avatar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeadingText(
                    text: "Alexander Pekhenko", //TODO! Users first and last name
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                   Text("alexpekhenko@gmail.com", //TODO! Users email
                    style: TextStyle(
                      color: theme.primaryColorLight,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 3, vertical: 3),
                    decoration: BoxDecoration(
                      // color: AppStyles.profileStatusColor,
                      borderRadius: BorderRadius.circular(100),
                    ),

                  )
                ],
              ),
              Expanded(child: Container()),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Icon(FluentSystemIcons.ic_fluent_settings_regular, color: theme.primaryColorLight,),
              )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Divider(
            color: Colors.grey.shade300,
          ),
          const SizedBox(
            height: 8,
          ),
          Consumer<ThemeProvider>(
              builder: (context, ThemeProvider notifier, child) {
                return Column(
                  children: [
                    ListTile(
                      leading: notifier.isDark? Icon(Icons.dark_mode) : Icon(Icons.light_mode),
                      title: Text("Toggle dark/light mode"),
                      trailing: Switch(
                          value: notifier.isDark,
                          onChanged: (value){
                            notifier.changeTheme();
                          }),
                    )
                  ],
                );
              }
          ),
          // award box
          const SizedBox(
            height: 25,
          ),

        ],
      ),
    );
  }
}
