import 'package:budgeting_app_v2/services/user_data_test_data_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/user_data_notifier.dart';

class GraphsScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataProvider);
    
    return Container(
      //height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/logoPlainDark.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [
          Center(
            child: const Padding(
              padding: EdgeInsets.only(top: 42.0),
              child: Text(
                'Graphs',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                      Shadow(
                        offset: Offset(2.0, 2.0),
                        blurRadius: 3.0,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ],
                ),
              ),
            ),
          ),

          //spacer pushes buttons to the center of the screen
          const Spacer(),
          
            Center(
              child: ElevatedButton(
                onPressed: () {
                  context.go('/graphs/custom_stacked_bar_graph');
                },
                child: const Text('Custom Stacked Bar Graph'),
              ),
            ),

            SizedBox(height: 20), // Space between the two buttons

            Center(
              child: ElevatedButton(
                onPressed: () {
                  context.go('/graphs/pie_graph');
                },
                child: const Text('Pie Graph'),
              ),
            ),

            const Spacer(),
        ],
      ),
    );
  }
}