import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stroke_master/base/widgets/show_logo.dart';
import 'package:stroke_master/state/auth/providers/user_id_provider.dart';
import '/base/util/styles/app_styles.dart';
import '/base/widgets/title_and_link_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(userIdProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      // backgroundColor: AppStyles.bgColor,
      body: ListView(
        // ListView insists to have only Widget
        // type items, so it can be also scrollable
        children: [
          const ShowLogo(),
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
                        const SizedBox(width: 10,),
                        Text("Good morning", style: AppStyles.headlineStyle3),

                      ],
                    ),

                  ],
                ),

                const SizedBox(height: 20),
                TitleAndLinkWidget(
                  title: 'Upcoming Flights',
                  details: 'View all',
                  func: () => context.go("/view_todays_top_exercises"),
                ),
                const SizedBox(height: 20),
                const SingleChildScrollView(
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
