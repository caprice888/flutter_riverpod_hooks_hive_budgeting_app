import 'dart:math';

import 'package:budgeting_app_v2/models/transaction_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/transaction_category_model.dart';
import '../providers/user_data_notifier.dart';

//service responsible for generating test data for the user data model
class UserDataTestDataService
{
  static final List<TransactionCategoryModel> testTransactionCategories = [
    TransactionCategoryModel(name: 'Bills', colour: 0xFFE57373), 
    TransactionCategoryModel(name: 'Groceries', colour: 0xFF81D4FA), 
    TransactionCategoryModel(name: 'Socializing', colour: 0xFFAED581), 
    TransactionCategoryModel(name: 'Take Out Food', colour: 0xFF9575CD), 
    TransactionCategoryModel(name: 'Coffee', colour: 0xFFFFD54F), 
    TransactionCategoryModel(name: 'Shopping', colour: 0xFFFFB74D) 
  ];
 
 
 
  //generate test data for the user data model
  static void generateTestData(WidgetRef ref)
  {
    Map<String, dynamic> testData = _getTestData();
    _saveTestData(ref, testData);
  }


  //save test data to provider
  static void _saveTestData(WidgetRef ref, Map<String, dynamic> testData)
  {
    final userData = ref.watch(userDataProvider);

    //add username
    ref.read(userDataProvider.notifier).updateUsername(testData['username']);

    //add date joined
    ref.read(userDataProvider.notifier).state = ref.read(userDataProvider.notifier).state.copyWith(dateJoined: testData['dateJoined']);

    //add saved category tags
    for (var category in testData['savedTransactionCategories'])
    {
      //print("DEBUG CATEGORY: contains?: ${userData.savedTransactionCategories.contains(category)}"); //doesnt work for some reason
      bool contains = false;

      //check userData.savedTransactionCategories for matching category
      for (var userDataCategory in userData.savedTransactionCategories)
      {
        // if(userDataCategory.name == category.name && userDataCategory.colour == category.colour)
        if(userDataCategory.name == category.name)//only check name as color may have been changed by user
        {
          contains = true;
          break;
        }
      }

      //add category if it doesn't exist
      if(!contains)
      {
        ref.read(userDataProvider.notifier).addSavedCategoryTag(category);
      }
    }

    //add transactions
    for (var transaction in testData['transactions'])
    {
      ref.read(userDataProvider.notifier).addTransactionWithCustomDate(transaction['title'], transaction['amount'], transaction['category'], transaction['date'] as DateTime);
    }
  }

  // Generate a random date within the last week
  static DateTime generateRandomDate() {
    final random = Random();
    final now = DateTime.now();
    final oneWeekAgo = now.subtract(Duration(days: 7));
    final randomDuration = Duration(days: random.nextInt(7));
    return oneWeekAgo.add(randomDuration);
  }

  // Generate a valid random date during this year
  static DateTime generateRandomDateThisYear() {
    final random = Random();
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    final randomDuration = Duration(days: random.nextInt(now.difference(startOfYear).inDays));
    return startOfYear.add(randomDuration);
  }

  //get test data for the user data model
  static Map<String, dynamic> _getTestData()
  {
    return {
        'username': 'John Doe',
        'dateJoined': generateRandomDate().subtract(Duration(days: 8)),
        'savedTransactionCategories': testTransactionCategories,
        // 'transactions': [
        //   {
        //     'id': '1',
        //     'title': 'Electricity',
        //     'amount': 200.0,
        //     'category': testTransactionCategories[0],
        //     'date': generateRandomDateThisYear(),
        //   },
        //   {
        //     'id': '2',
        //     'title': 'Groceries',
        //     'amount': 50.0,
        //     'category': testTransactionCategories[1],
        //     'date': generateRandomDateThisYear(),
        //   },
        //   {
        //     'id': '3',
        //     'title': 'Coffee with friends',
        //     'amount': 10.0,
        //     'category': testTransactionCategories[2],
        //     'date': generateRandomDateThisYear(),
        //   },
        //   {
        //     'id': '4',
        //     'title': 'Take out food',
        //     'amount': 15.0,
        //     'category': testTransactionCategories[3],
        //     'date': generateRandomDateThisYear(),
        //   },
        //   {
        //     'id': '5',
        //     'title': 'Coffee',
        //     'amount': 5.0,
        //     'category': testTransactionCategories[4],
        //     'date': generateRandomDateThisYear(),
        //   },
        //   {
        //     'id': '6',
        //     'title': 'New shoes',
        //     'amount': 100.0,
        //     'category': testTransactionCategories[5],
        //     'date': generateRandomDateThisYear(),
        //   },
        //   {
        //     'id': '7',
        //     'title': 'Electricity',
        //     'amount': 200.0,
        //     'category': testTransactionCategories[0],
        //     'date': generateRandomDateThisYear(),
        //   },
        //   {
        //     'id': '8',
        //     'title': 'Groceries',
        //     'amount': 50.0,
        //     'category': testTransactionCategories[1],
        //     'date': generateRandomDateThisYear(),
        //   },
        //   {
        //     'id': '9',
        //     'title': 'Coffee with friends',
        //     'amount': 10.0,
        //     'category': testTransactionCategories[2],
        //     'date': generateRandomDateThisYear(),
        //   },
        //   {
        //     'id': '10',
        //     'title': 'Take out food',
        //     'amount': 15.0,
        //     'category': testTransactionCategories[3],
        //     'date': generateRandomDateThisYear(),
        //   },
        //   {
        //     'id': '11',
        //     'title': 'Coffee',
        //     'amount': 5.0,
        //     'category': testTransactionCategories[4],
        //     'date': generateRandomDateThisYear(),
        //   },
        //   {
        //     'id': '12',
        //     'title': 'New shoes',
        //     'amount': 100.0,
        //     'category': testTransactionCategories[5],
        //     'date': generateRandomDateThisYear(),
        //   },
        //   {
        //     'id': '13',
        //     'title': 'Electricity',
        //     'amount': 200.0,
        //     'category': testTransactionCategories[0],
        //     'date': generateRandomDateThisYear(),
        //   },
        //   {
        //     'id': '14',
        //     'title': 'Groceries',
        //     'amount': 50.0,
        //     'category': testTransactionCategories[1],
        //     'date': generateRandomDateThisYear(),
        //   },
        //   {
        //     'id': '15',
        //     'title': 'Coffee with friends',
        //     'amount': 10.0,
        //     'category': testTransactionCategories[2],
        //     'date': generateRandomDateThisYear(),
        //   },
        //   {
        //     'id': '16',
        //     'title': 'Take out food',
        //     'amount': 15.0,
        //     'category': testTransactionCategories[3],
        //     'date': generateRandomDateThisYear(),
        //   },
        //   {
        //     'id': '17',
        //     'title': 'Coffee',
        //     'amount': 5.0,
        //     'category': testTransactionCategories[4],
        //     'date': generateRandomDateThisYear(),
        //   },
        //   {
        //     'id': '18',
        //     'title': 'New shoes',
        //     'amount': 100.0,
        //     'category': testTransactionCategories[5],
        //     'date': generateRandomDateThisYear(),
        //   },
        //   {
        //     'id': '19',
        //     'title': 'Electricity',
        //     'amount': 200.0,
        //     'category': testTransactionCategories[0],
        //     'date': generateRandomDateThisYear(),
        //   },
        //   {
        //     'id': '20',
        //     'title': 'Groceries',
        //     'amount': 50.0,
        //     'category': testTransactionCategories[1],
        //     'date': generateRandomDateThisYear(),
        //   },
        //   {
        //     'id': '21',
        //     'title': 'Coffee with friends',
        //     'amount': 10.0,
        //     'category': testTransactionCategories[2],
        //     'date': generateRandomDateThisYear(),
        //   },
        //   {
        //     'id': '22',
        //     'title': 'Take out food',
        //     'amount': 15.0,
        //     'category': testTransactionCategories[3],
        //     'date': generateRandomDateThisYear(),
        //   },
        //   {
        //     'id': '23',
        //     'title': 'Coffee',
        //     'amount': 5.0,
        //     'category': testTransactionCategories[4],
        //     'date': generateRandomDateThisYear(),
        //   },
        //   {
        //     'id': '24',
        //     'title': 'New shoes',
        //     'amount': 100.0,
        //     'category': testTransactionCategories[5],
        //     'date': generateRandomDateThisYear(),
        //   },
        //   {
        //     'id': '25',
        //     'title': 'Electricity',
        //     'amount': 200.0,
        //     'category': testTransactionCategories[0],
        //     'date': generateRandomDateThisYear(),
        //   },
        //   {
        //     'id': '26',
        //     'title': 'Groceries',
        //     'amount': 50.0,
        //     'category': testTransactionCategories[1],
        //     'date': generateRandomDateThisYear(),
        //   },
        //   {
        //     'id': '27',
        //     'title': 'Coffee with friends',
        //     'amount': 10.0,
        //     'category': testTransactionCategories[2],
        //     'date': generateRandomDateThisYear(),
        //   },
        //   {
        //     'id': '28',
        //     'title': 'Take out food',
        //     'amount': 15.0,
        //     'category': testTransactionCategories[3],
        //     'date': generateRandomDateThisYear(),
        //   },
        //   {
        //     'id': '29',
        //     'title': 'Coffee',
        //     'amount': 5.0,
        //     'category': testTransactionCategories[4],
        //     'date': generateRandomDateThisYear(),
        //   },
        //   {
        //     'id': '30',
        //     'title': 'New shoes',
        //     'amount': 100.0,
        //     'category': testTransactionCategories[5],
        //     'date': generateRandomDateThisYear(),
        //   },
        //   {
        //     'id': '31',
        //     'title': 'Electricity',
        //     'amount': 200.0,
        //     'category': testTransactionCategories[0],
        //     'date': generateRandomDateThisYear(),
        //   },
        //   {
        //     'id': '32',
        //     'title': 'Groceries',
        //     'amount': 50.0,
        //     'category': testTransactionCategories[1],
        //     'date': generateRandomDateThisYear(),
        //   },
        //   {
        //     'id': '33',
        //     'title': 'Coffee with friends',
        //     'amount': 10.0,
        //     'category': testTransactionCategories[2],
        //     'date': generateRandomDateThisYear(),
        //   },
        //   {
        //     'id': '34',
        //     'title': 'Take out food',
        //     'amount': 15.0,
        //     'category': testTransactionCategories[3],
        //     'date': generateRandomDateThisYear(),
        //   },
        //   {
        //     'id': '35',
        //     'title': 'Coffee',
        //     'amount': 5.0,
        //     'category': testTransactionCategories[4],
        //     'date': generateRandomDateThisYear(),
        //   },
        //   {
        //     'id': '36',
        //     'title': 'New shoes',
        //     'amount': 100.0,
        //     'category': testTransactionCategories[5],
        //     'date': generateRandomDateThisYear(),
        //   },
        //   {
        //     'id': '37',
        //     'title': 'Electricity',
        //     'amount': 200.0,
        //     'category': testTransactionCategories[0],
        //     'date': generateRandomDateThisYear(),
        //   },
        //   {
        //     'id': '38',
        //     'title': 'Groceries',
        //     'amount': 50.0,
        //     'category': testTransactionCategories[1],
        //     'date': generateRandomDateThisYear(),
        //   },
        //   {
        //     'id': '39',
        //     'title': 'Coffee with friends',
        //     'amount': 10.0,
        //     'category': testTransactionCategories[2],
        //     'date': generateRandomDateThisYear(),
        //   },
        //   {
        //     'id': '40',
        //     'title': 'Take out food',
        //     'amount': 15.0,
        //     'category': testTransactionCategories[3],
        //     'date': generateRandomDateThisYear(),
        //   },
        //   {
        //     'id': '41',
        //     'title': 'Coffee',
        //     'amount': 5.0,
        //     'category': testTransactionCategories[4],
        //     'date': generateRandomDateThisYear(),
        //   },
        //   {
        //     'id': '42',
        //     'title': 'New shoes',
        //     'amount': 100.0,
        //     'category': testTransactionCategories[5],
        //     'date': generateRandomDateThisYear(),
        //   },
        //   {
        //     'id': '43',
        //     'title': 'Electricity',
        //     'amount': 200.0,
        //     'category': testTransactionCategories[0],
        //     'date': generateRandomDateThisYear(),
        //   },
        //   {
        //     'id': '44',
        //     'title': 'Groceries',
        //     'amount': 50.0,
        //     'category': testTransactionCategories[1],
        //     'date': generateRandomDateThisYear(),
        //   },
        //   {
        //     'id': '45',
        //     'title': 'Coffee with friends',
        //     'amount': 10.0,
        //     'category': testTransactionCategories[2],
        //     'date': generateRandomDateThisYear(),
        //   },
        //   {
        //     'id': '46',
        //     'title': 'Take out food',
        //     'amount': 15.0,
        //     'category': testTransactionCategories[3],
        //     'date': generateRandomDateThisYear(),
        //   },
        //   {
        //     'id': '47',
        //     'title': 'Coffee',
        //     'amount': 5.0,
        //     'category': testTransactionCategories[4],
        //     'date': generateRandomDateThisYear(),
        //   },
        //   {
        //     'id': '48',
        //     'title': 'New shoes',
        //     'amount': 100.0,
        //     'category': testTransactionCategories[5],
        //     'date': generateRandomDateThisYear(),
        //   },


        // ],
        'transactions': [
          {
            'id': '1',
            'title': 'Electricity',
            'amount': 200.0,
            'category': testTransactionCategories[0],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '2',
            'title': 'Groceries',
            'amount': 50.0,
            'category': testTransactionCategories[1],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '3',
            'title': 'Coffee with friends',
            'amount': 10.0,
            'category': testTransactionCategories[4],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '4',
            'title': 'Take out food',
            'amount': 15.0,
            'category': testTransactionCategories[3],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '5',
            'title': 'Dinner at a restaurant',
            'amount': 70.0,
            'category': testTransactionCategories[3],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '6',
            'title': 'Monthly Internet Bill',
            'amount': 60.0,
            'category': testTransactionCategories[0],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '7',
            'title': 'Weekend groceries',
            'amount': 85.0,
            'category': testTransactionCategories[1],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '8',
            'title': 'Movie night',
            'amount': 25.0,
            'category': testTransactionCategories[2],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '9',
            'title': 'New shoes',
            'amount': 120.0,
            'category': testTransactionCategories[5],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '10',
            'title': 'Brunch',
            'amount': 30.0,
            'category': testTransactionCategories[3],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '11',
            'title': 'Gym membership',
            'amount': 45.0,
            'category': testTransactionCategories[2],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '12',
            'title': 'Weekly coffee',
            'amount': 15.0,
            'category': testTransactionCategories[4],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '13',
            'title': 'Online shopping',
            'amount': 75.0,
            'category': testTransactionCategories[5],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '14',
            'title': 'Gas bill',
            'amount': 40.0,
            'category': testTransactionCategories[0],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '15',
            'title': 'Party snacks',
            'amount': 35.0,
            'category': testTransactionCategories[2],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '16',
            'title': 'Lunch with coworkers',
            'amount': 25.0,
            'category': testTransactionCategories[3],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '17',
            'title': 'New phone',
            'amount': 800.0,
            'category': testTransactionCategories[5],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '18',
            'title': 'Grocery shopping',
            'amount': 120.0,
            'category': testTransactionCategories[1],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '19',
            'title': 'Weekend getaway',
            'amount': 300.0,
            'category': testTransactionCategories[2],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '20',
            'title': 'Bakery treats',
            'amount': 15.0,
            'category': testTransactionCategories[4],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '21',
            'title': 'Books',
            'amount': 45.0,
            'category': testTransactionCategories[5],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '22',
            'title': 'Utility bill',
            'amount': 150.0,
            'category': testTransactionCategories[0],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '23',
            'title': 'Fitness class',
            'amount': 20.0,
            'category': testTransactionCategories[2],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '24',
            'title': 'Home decor',
            'amount': 200.0,
            'category': testTransactionCategories[5],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '25',
            'title': 'Concert tickets',
            'amount': 100.0,
            'category': testTransactionCategories[2],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '26',
            'title': 'Dinner date',
            'amount': 60.0,
            'category': testTransactionCategories[3],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '27',
            'title': 'Car maintenance',
            'amount': 250.0,
            'category': testTransactionCategories[0],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '28',
            'title': 'Café breakfast',
            'amount': 20.0,
            'category': testTransactionCategories[4],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '29',
            'title': 'Work lunch',
            'amount': 12.0,
            'category': testTransactionCategories[3],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '30',
            'title': 'Pet supplies',
            'amount': 60.0,
            'category': testTransactionCategories[5],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '31',
            'title': 'Monthly gym fee',
            'amount': 50.0,
            'category': testTransactionCategories[2],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '32',
            'title': 'Groceries for the week',
            'amount': 90.0,
            'category': testTransactionCategories[1],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '33',
            'title': 'Birthday gift',
            'amount': 75.0,
            'category': testTransactionCategories[5],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '34',
            'title': 'Water bill',
            'amount': 30.0,
            'category': testTransactionCategories[0],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '35',
            'title': 'Coffee beans',
            'amount': 20.0,
            'category': testTransactionCategories[4],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '36',
            'title': 'Lunch out',
            'amount': 18.0,
            'category': testTransactionCategories[3],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '37',
            'title': 'Concert merchandise',
            'amount': 50.0,
            'category': testTransactionCategories[2],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '38',
            'title': 'Online course',
            'amount': 200.0,
            'category': testTransactionCategories[5],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '39',
            'title': 'Dining out',
            'amount': 55.0,
            'category': testTransactionCategories[3],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '40',
            'title': 'Streaming subscription',
            'amount': 15.0,
            'category': testTransactionCategories[0],
            'date': generateRandomDate(),
          },
          {
            'id': '41',
            'title': 'Weekend getaway',
            'amount': 350.0,
            'category': testTransactionCategories[2],
            'date': generateRandomDate(),
          },
          {
            'id': '42',
            'title': 'Groceries - organic',
            'amount': 120.0,
            'category': testTransactionCategories[1],
            'date': generateRandomDate(),
          },
          {
            'id': '43',
            'title': 'Coffee maker',
            'amount': 75.0,
            'category': testTransactionCategories[4],
            'date': generateRandomDate(),
          },
          {
            'id': '44',
            'title': 'Lunch with family',
            'amount': 60.0,
            'category': testTransactionCategories[3],
            'date': generateRandomDate(),
          },
          {
            'id': '45',
            'title': 'Fitness equipment',
            'amount': 150.0,
            'category': testTransactionCategories[5],
            'date': generateRandomDate(),
          },
          {
            'id': '46',
            'title': 'Electricity bill',
            'amount': 180.0,
            'category': testTransactionCategories[0],
            'date': generateRandomDate(),
          },
          {
            'id': '47',
            'title': 'Specialty coffee',
            'amount': 12.0,
            'category': testTransactionCategories[4],
            'date': generateRandomDate(),
          },
          {
            'id': '48',
            'title': 'Outdoor dining',
            'amount': 40.0,
            'category': testTransactionCategories[3],
            'date': generateRandomDate(),
          },
          {
            'id': '49',
            'title': 'Concert ticket',
            'amount': 120.0,
            'category': testTransactionCategories[2],
            'date': generateRandomDate(),
          },
          {
            'id': '50',
            'title': 'New clothing',
            'amount': 200.0,
            'category': testTransactionCategories[5],
            'date': generateRandomDate(),
          }
        ],

      };
  }
}