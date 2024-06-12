import 'dart:math';

import 'package:budgeting_app_v2/models/transaction_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/user_data_notifier.dart';

//service responsible for generating test data for the user data model
class UserDataTestDataService
{
  //generate test data for the user data model
  static void generateTestData(WidgetRef ref)
  {
    Map<String, dynamic> testData = _getTestData();
    _saveTestData(ref, testData);
  }


  //save test data to provider
  static void _saveTestData(WidgetRef ref, Map<String, dynamic> testData)
  {
    //add username
    ref.read(userDataProvider.notifier).updateUsername(testData['username']);

    //add date joined
    ref.read(userDataProvider.notifier).state = ref.read(userDataProvider.notifier).state.copyWith(dateJoined: testData['dateJoined']);

    //add saved category tags
    for (var tag in testData['savedCategoryTags'])
    {
      ref.read(userDataProvider.notifier).addSavedCategoryTag(tag);
    }

    //add transactions
    for (var transaction in testData['transactions'])
    {
      ref.read(userDataProvider.notifier).addTransactionWithCustomDate(transaction['title'], transaction['amount'], transaction['categoryTags'], transaction['date'] as DateTime);
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
        'savedCategoryTags': ['Food', 'Bill', 'Insurance', 'Entertainment', 'Fitness', 'Education', 'Shopping', 'Personal Care', 'Gifts', 'Travel', 'Transportation', 'Automotive', 'Electronics', 'Housing'],
        'transactions': [
          {
            'id': '1',
            'title': 'Groceries',
            'amount': 50.0,
            'categoryTags': ['Food'],
            'date': generateRandomDate(),
          },
          {
            'id': '2',
            'title': 'Electricity Bill',
            'amount': 100.0,
            'categoryTags': ['Bill'],
            'date': generateRandomDate(),
          },
          {
            'id': '3',
            'title': 'Internet Bill',
            'amount': 50.0,
            'categoryTags': ['Bill'],
            'date': generateRandomDate(),
          },
          {
            'id': '4',
            'title': 'Dinner',
            'amount': 20.0,
            'categoryTags': ['Food'],
            'date': generateRandomDate(),
          },
          {
            'id': '5',
            'title': 'Lunch',
            'amount': 10.0,
            'categoryTags': ['Food'],
            'date': generateRandomDate(),
          },
          {
            'id': '6',
            'title': 'Breakfast',
            'amount': 5.0,
            'categoryTags': ['Food'],
            'date': generateRandomDate(),
          },
          {
            'id': '7',
            'title': 'Water Bill',
            'amount': 20.0,
            'categoryTags': ['Bill'],
            'date': generateRandomDate(),
          },
          {
            'id': '8',
            'title': 'Gas Bill',
            'amount': 30.0,
            'categoryTags': ['Bill'],
            'date': generateRandomDate(),
          },
          {
            'id': '9',
            'title': 'Phone Bill',
            'amount': 40.0,
            'categoryTags': ['Bill'],
            'date': generateRandomDate(),
          },
          {
            'id': '10',
            'title': 'Car Insurance',
            'amount': 200.0,
            'categoryTags': ['Insurance'],
            'date': generateRandomDate(),
          },
          {
            'id': '11',
            'title': 'Movie Tickets',
            'amount': 25.0,
            'categoryTags': ['Entertainment'],
            'date': generateRandomDate(),
          },
          {
            'id': '12',
            'title': 'Gym Membership',
            'amount': 50.0,
            'categoryTags': ['Fitness'],
            'date': generateRandomDate(),
          },
          {
            'id': '13',
            'title': 'Coffee',
            'amount': 5.0,
            'categoryTags': ['Food'],
            'date': generateRandomDate(),
          },
          {
            'id': '14',
            'title': 'Books',
            'amount': 30.0,
            'categoryTags': ['Education'],
            'date': generateRandomDate(),
          },
          {
            'id': '15',
            'title': 'Clothes',
            'amount': 100.0,
            'categoryTags': ['Shopping'],
            'date': generateRandomDate(),
          },
          {
            'id': '16',
            'title': 'Haircut',
            'amount': 15.0,
            'categoryTags': ['Personal Care'],
            'date': generateRandomDate(),
          },
          {
            'id': '17',
            'title': 'Gift',
            'amount': 50.0,
            'categoryTags': ['Gifts'],
            'date': generateRandomDate(),
          },
          {
            'id': '18',
            'title': 'Vacation',
            'amount': 500.0,
            'categoryTags': ['Travel'],
            'date': generateRandomDate(),
          },
          {
            'id': '19',
            'title': 'Restaurant',
            'amount': 40.0,
            'categoryTags': ['Food'],
            'date': generateRandomDate(),
          },
          {
            'id': '20',
            'title': 'Gasoline',
            'amount': 30.0,
            'categoryTags': ['Transportation'],
            'date': generateRandomDate(),
          },
          {
            'id': '21',
            'title': 'Concert Tickets',
            'amount': 100.0,
            'categoryTags': ['Entertainment'],
            'date': generateRandomDate(),
          },
          {
            'id': '22',
            'title': 'Rent',
            'amount': 1000.0,
            'categoryTags': ['Housing'],
            'date': generateRandomDate(),
          },
          {
            'id': '23',
            'title': 'Car Repair',
            'amount': 200.0,
            'categoryTags': ['Automotive'],
            'date': generateRandomDate(),
          },
          {
            'id': '24',
            'title': 'Phone Upgrade',
            'amount': 500.0,
            'categoryTags': ['Electronics'],
            'date': generateRandomDate(),
          },
          {
            'id': '25',
            'title': 'Groceries',
            'amount': 50.0,
            'categoryTags': ['Food'],
            'date': generateRandomDate(),
          },
          {
            'id': '26',
            'title': 'Electricity Bill',
            'amount': 100.0,
            'categoryTags': ['Bill'],
            'date': generateRandomDate(),
          },
          {
            'id': '27',
            'title': 'Internet Bill',
            'amount': 50.0,
            'categoryTags': ['Bill'],
            'date': generateRandomDate(),
          },
          {
            'id': '28',
            'title': 'Dinner',
            'amount': 20.0,
            'categoryTags': ['Food'],
            'date': generateRandomDate(),
          },
          {
            'id': '29',
            'title': 'Lunch',
            'amount': 10.0,
            'categoryTags': ['Food'],
            'date': generateRandomDate(),
          },
          {
            'id': '30',
            'title': 'Breakfast',
            'amount': 5.0,
            'categoryTags': ['Food'],
            'date': generateRandomDate(),
          },
          {
            'id': '31',
            'title': 'Water Bill',
            'amount': 20.0,
            'categoryTags': ['Bill'],
            'date': generateRandomDate(),
          },
          {
            'id': '32',
            'title': 'Gas Bill',
            'amount': 30.0,
            'categoryTags': ['Bill'],
            'date': generateRandomDate(),
          },
          {
            'id': '33',
            'title': 'Phone Bill',
            'amount': 40.0,
            'categoryTags': ['Bill'],
            'date': generateRandomDate(),
          },
          {
            'id': '34',
            'title': 'Car Insurance',
            'amount': 200.0,
            'categoryTags': ['Insurance'],
            'date': generateRandomDate(),
          },
          {
            'id': '35',
            'title': 'Movie Tickets',
            'amount': 25.0,
            'categoryTags': ['Entertainment'],
            'date': generateRandomDate(),
          },
          {
            'id': '36',
            'title': 'Gym Membership',
            'amount': 50.0,
            'categoryTags': ['Fitness'],
            'date': generateRandomDate(),
          },
          {
            'id': '37',
            'title': 'Coffee',
            'amount': 5.0,
            'categoryTags': ['Food'],
            'date': generateRandomDate(),
          },
          {
            'id': '38',
            'title': 'Books',
            'amount': 30.0,
            'categoryTags': ['Education'],
            'date': generateRandomDate(),
          },
          {
            'id': '39',
            'title': 'Clothes',
            'amount': 100.0,
            'categoryTags': ['Shopping'],
            'date': generateRandomDate(),
          },
          {
            'id': '40',
            'title': 'Haircut',
            'amount': 15.0,
            'categoryTags': ['Personal Care'],
            'date': generateRandomDate(),
          },
          {
            'id': '41',
            'title': 'Gift',
            'amount': 50.0,
            'categoryTags': ['Gifts'],
            'date': generateRandomDate(),
          },
          {
            'id': '42',
            'title': 'Vacation',
            'amount': 500.0,
            'categoryTags': ['Travel'],
            'date': generateRandomDate(),
          },
          {
            'id': '43',
            'title': 'Restaurant',
            'amount': 40.0,
            'categoryTags': ['Food'],
            'date': generateRandomDate(),
          },
          {
            'id': '44',
            'title': 'Gasoline',
            'amount': 30.0,
            'categoryTags': ['Transportation'],
            'date': generateRandomDate(),
          },
          {
            'id': '45',
            'title': 'Concert Tickets',
            'amount': 100.0,
            'categoryTags': ['Entertainment'],
            'date': generateRandomDate(),
          },
          {
            'id': '46',
            'title': 'Rent',
            'amount': 1000.0,
            'categoryTags': ['Housing'],
            'date': generateRandomDate(),
          },
          {
            'id': '47',
            'title': 'Car Repair',
            'amount': 200.0,
            'categoryTags': ['Automotive'],
            'date': generateRandomDate(),
          },
          {
            'id': '48',
            'title': 'Phone Upgrade',
            'amount': 500.0,
            'categoryTags': ['Electronics'],
            'date': generateRandomDate(),
          },
          {
            'id': '49',
            'title': 'Groceries',
            'amount': 50.0,
            'categoryTags': ['Food'],
            'date': generateRandomDate(),
          },
          {
            'id': '50',
            'title': 'Electricity Bill',
            'amount': 100.0,
            'categoryTags': ['Bill'],
            'date': generateRandomDate(),
          },
          //more entries with generateRandomDateThisYear
          {
            'id': '51',
            'title': 'Internet Bill',
            'amount': 50.0,
            'categoryTags': ['Bill'],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '52',
            'title': 'Dinner',
            'amount': 20.0,
            'categoryTags': ['Food'],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '53',
            'title': 'Lunch',
            'amount': 10.0,
            'categoryTags': ['Food'],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '54',
            'title': 'Breakfast',
            'amount': 5.0,
            'categoryTags': ['Food'],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '55',
            'title': 'Water Bill',
            'amount': 20.0,
            'categoryTags': ['Bill'],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '56',
            'title': 'Gas Bill',
            'amount': 30.0,
            'categoryTags': ['Bill'],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '57',
            'title': 'Phone Bill',
            'amount': 40.0,
            'categoryTags': ['Bill'],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '58',
            'title': 'Car Insurance',
            'amount': 200.0,
            'categoryTags': ['Insurance'],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '59',
            'title': 'Movie Tickets',
            'amount': 25.0,
            'categoryTags': ['Entertainment'],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '60',
            'title': 'Gym Membership',
            'amount': 50.0,
            'categoryTags': ['Fitness'],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '61',
            'title': 'Coffee',
            'amount': 5.0,
            'categoryTags': ['Food'],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '62',
            'title': 'Books',
            'amount': 30.0,
            'categoryTags': ['Education'],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '63',
            'title': 'Clothes',
            'amount': 100.0,
            'categoryTags': ['Shopping'],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '64',
            'title': 'Haircut',
            'amount': 15.0,
            'categoryTags': ['Personal Care'],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '65',
            'title': 'Gift',
            'amount': 50.0,
            'categoryTags': ['Gifts'],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '66',
            'title': 'Vacation',
            'amount': 500.0,
            'categoryTags': ['Travel'],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '67',
            'title': 'Restaurant',
            'amount': 40.0,
            'categoryTags': ['Food'],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '68',
            'title': 'Gasoline',
            'amount': 30.0,
            'categoryTags': ['Transportation'],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '69',
            'title': 'Concert Tickets',
            'amount': 100.0,
            'categoryTags': ['Entertainment'],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '70',
            'title': 'Rent',
            'amount': 1000.0,
            'categoryTags': ['Housing'],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '71',
            'title': 'Car Repair',
            'amount': 200.0,
            'categoryTags': ['Automotive'],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '72',
            'title': 'Phone Upgrade',
            'amount': 500.0,
            'categoryTags': ['Electronics'],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '73',
            'title': 'Groceries',
            'amount': 50.0,
            'categoryTags': ['Food'],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '74',
            'title': 'Electricity Bill',
            'amount': 100.0,
            'categoryTags': ['Bill'],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '75',
            'title': 'Internet Bill',
            'amount': 50.0,
            'categoryTags': ['Bill'],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '76',
            'title': 'Dinner',
            'amount': 20.0,
            'categoryTags': ['Food'],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '77',
            'title': 'Lunch',
            'amount': 10.0,
            'categoryTags': ['Food'],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '78',
            'title': 'Breakfast',
            'amount': 5.0,
            'categoryTags': ['Food'],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '79',
            'title': 'Water Bill',
            'amount': 20.0,
            'categoryTags': ['Bill'],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '80',
            'title': 'Gas Bill',
            'amount': 30.0,
            'categoryTags': ['Bill'],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '81',
            'title': 'Phone Bill',
            'amount': 40.0,
            'categoryTags': ['Bill'],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '82',
            'title': 'Car Insurance',
            'amount': 200.0,
            'categoryTags': ['Insurance'],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '83',
            'title': 'Movie Tickets',
            'amount': 25.0,
            'categoryTags': ['Entertainment'],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '84',
            'title': 'Gym Membership',
            'amount': 50.0,
            'categoryTags': ['Fitness'],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '85',
            'title': 'Coffee',
            'amount': 5.0,
            'categoryTags': ['Food'],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '86',
            'title': 'Books',
            'amount': 30.0,
            'categoryTags': ['Education'],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '87',
            'title': 'Clothes',
            'amount': 100.0,
            'categoryTags': ['Shopping'],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '88',
            'title': 'Haircut',
            'amount': 15.0,
            'categoryTags': ['Personal Care'],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '89',
            'title': 'Gift',
            'amount': 50.0,
            'categoryTags': ['Gifts'],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '90',
            'title': 'Vacation',
            'amount': 500.0,
            'categoryTags': ['Travel'],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '91',
            'title': 'Restaurant',
            'amount': 40.0,
            'categoryTags': ['Food'],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '92',
            'title': 'Gasoline',
            'amount': 30.0,
            'categoryTags': ['Transportation'],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '93',
            'title': 'Concert Tickets',
            'amount': 100.0,
            'categoryTags': ['Entertainment'],
            'date': generateRandomDateThisYear(),
          },
          {
            'id': '94',
            'title': 'Rent',
            'amount': 1000.0,
            'categoryTags': ['Housing'],
            'date': generateRandomDateThisYear(),
          },
        ],
      };

      //100 more entries with generateRandomDateThisYear with random category tags, amounts and titles
      // for (var i = 51; i <= 150; i++)
      //   {
      //     testData['transactions'] ={
      //     'id': i.toString(),
      //     'title': 'Transaction $i',
      //     'amount': Random().nextDouble() * 100,
      //     //random category tags from this list: ['Food', 'Bill', 'Insurance', 'Entertainment', 'Fitness', 'Education', 'Shopping', 'Personal Care', 'Gifts', 'Travel', 'Transportation', 'Automotive', 'Electronics', 'Housing']
      //     'categoryTags': ['Food', 'Bill', 'Insurance', 'Entertainment', 'Fitness', 'Education', 'Shopping', 'Personal Care', 'Gifts', 'Travel', 'Transportation', 'Automotive', 'Electronics', 'Housing'].sublist(Random().nextInt(14)),
      //     'date': generateRandomDateThisYear(),
      //     },
      //   }
  }
}