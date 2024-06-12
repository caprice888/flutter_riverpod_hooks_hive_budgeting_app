import 'package:budgeting_app_v2/services/user_data_test_data_service.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/user_data_notifier.dart';

class SettingsScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataProvider);
    
    return Container(
      //height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/logoDark.jpg'),
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
                'Settings',
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
                  UserDataTestDataService.generateTestData(ref);
                },
                child: const Text('Generate Test Data (For Testing)'),
              ),
            ),

            SizedBox(height: 20), // Space between the two buttons

            Center(
              child: ElevatedButton(
                onPressed: () {
                  ref.read(userDataProvider.notifier).deleteUserData();
                },
                child: const Text('Delete All User Data (Permanent)'),
              ),
            ),

            const Spacer(),
        ],
      ),
      
      // ListView(
      //   children: [
      //     ListTile(
      //       title: Text('Generate Test Data (For Testing)'),
      //       onTap: () {
      //         UserDataTestDataService.generateTestData(ref);
      //       },
      //     ),
      //     ListTile(
      //       title: Text('Delete All User Data (Permanent)'),
      //       onTap: () {
      //         // Handle delete all user data tap
      //         ref.read(userDataProvider.notifier).deleteUserData();

      //       },
      //     ),
      //     // Add more list tiles for additional options
      //   ],
      // ),
    );
  }
}