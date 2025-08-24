<!-- # budgeting_app_v2

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference. -->
# 🗂️ Flutter State Management with Riverpod + Hive

This project demonstrates a clean design pattern for Flutter state management where a Riverpod provider is integrated with Hive for local data persistence through a dedicated service layer.

## It showcases:

* Using StateNotifierProvider for managing complex state (UserData)

* Synchronizing provider state with Hive for persistence between app runs

* A service class that encapsulates Hive operations (read/write), keeping persistence concerns separate from business logic

* Extensible design for additional domains (e.g., themes with customizable Color schemes stored in Hive)

## 🚀 Why This Pattern?

Typical state management in Flutter apps either:

* Keeps state only in memory (lost on restart), or

* Couples persistence logic tightly into the state manager.

This project introduces a separation of concerns:

* StateNotifier manages business logic & reactive state

* Service handles persistence with Hive

* Together, they ensure state updates are both reactive (for UI rebuilds) and durable (saved locally).

<!-- ## 🧩 Architecture Overview
┌──────────────┐       ┌─────────────┐
│  UI Layer    │◀────▶│ Riverpod     │
│ (Widgets)    │       │ StateNotifier│
└──────────────┘       └───────▲─────┘
                                │
                                ▼
                       ┌────────────────┐
                       │ Hive Service   │
                       │ (UserData, etc)│
                       └────────────────┘ -->

<pre> ``` 
┌──────────────┐        ┌──────────────┐ 
│ UI Layer     │◀────▶ │ Riverpod     │ 
│ (Widgets)    │        │ StateNotifier│ 
└──────────────┘        └───────▲──────┘ 
                                │ 
                                ▼ 
                        ┌────────────────┐ 
                        │ Hive Service   │ 
                        │ (UserData,etc) │ 
                        └────────────────┘ 
``` </pre>


**UI Layer** : Uses HookConsumerWidget to watch providers and rebuild automatically when state changes.

**Provider** (StateNotifier): Encapsulates domain logic (UserDataNotifier) and updates state immutably.

**Service (Hive)**: Reads/writes data from a Hive box (userDataBox) to persist state.

## 🧑‍💻 Example Domain: UserData

## Data Models
```
@HiveType(typeId: 0)
class Transaction {
  @HiveField(0) String id;
  @HiveField(1) String title;
  @HiveField(2) double amount;
  @HiveField(3) List<String> categoryTag;
  @HiveField(4) DateTime date;
}

@HiveType(typeId: 1)
class UserData {
  @HiveField(0) List<Transaction> transactions;
  @HiveField(1) DateTime dateJoined;
  @HiveField(2) String username;
}
```

## Service Layer
```
class UserDataService {
  static const boxName = 'userDataBox';

  Future<UserData?> getUserData() async {
    final box = await Hive.openBox<UserData>(boxName);
    return box.get('userData');
  }

  Future<void> saveUserData(UserData userData) async {
    final box = await Hive.openBox<UserData>(boxName);
    await box.put('userData', userData);
  }
}
```

## Provider Layer
```
final userDataProvider =
  StateNotifierProvider<UserDataNotifier, UserData>((ref) => UserDataNotifier());

class UserDataNotifier extends StateNotifier<UserData> {
  final _service = UserDataService();

  UserDataNotifier() : super(UserData(transactions: [], dateJoined: DateTime.now(), username: '')) {
    _loadUserData();
  }

  void _loadUserData() async {
    final saved = await _service.getUserData();
    if (saved != null) state = saved;
  }

  @override
  set state(UserData value) {
    super.state = value;
    _service.saveUserData(value);
  }

  void updateUsername(String name) =>
      state = state.copyWith(username: name);

  void addTransaction(Transaction tx) =>
      state = state.copyWith(transactions: [...state.transactions, tx]);
}
```

## 🎨 Extending to Themes

The same pattern can be used for color themes:

* Store Color values in Hive as int (Color.value).

* Provide ColorThemeNotifier that syncs provider state + Hive persistence.

* Supports toggling between light/dark/custom themes.

Example ColorTheme model:

```
@HiveType(typeId: 2)
class ColorTheme {
  @HiveField(0) int primaryColor;
  @HiveField(1) int accentColor;
  @HiveField(2) int backgroundColor;

  ThemeData toThemeData() => ThemeData(
    primaryColor: Color(primaryColor),
    colorScheme: ColorScheme.light(
      primary: Color(primaryColor),
      secondary: Color(accentColor),
    ),
    scaffoldBackgroundColor: Color(backgroundColor),
  );
}
```

## 🛠️ Getting Started

Add dependencies in pubspec.yaml:

```
dependencies:
  hooks_riverpod: ^2.5.1
  hive: ^2.2.3
  hive_flutter: ^1.1.0
dev_dependencies:
  hive_generator: ^1.1.1
  build_runner: ^2.2.0
```

Run build runner to generate Hive adapters:

```flutter pub run build_runner build```


Initialize Hive before runApp:

```
void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TransactionAdapter());
  Hive.registerAdapter(UserDataAdapter());
  Hive.registerAdapter(ColorThemeAdapter());
  await Hive.openBox<UserData>('userDataBox');
  await Hive.openBox<ColorTheme>('colorThemeBox');

  runApp(ProviderScope(child: MyApp()));
}
```

## 🌟 Benefits of This Pattern

**Separation of concerns** → Provider = state logic, Service = persistence.

**Scalable** → Add new domains (e.g., themes, settings) by repeating the pattern.

**Persistent & Reactive** → App restarts keep the same state.

**Testable** → Providers can be tested with mock services, Hive stays isolated.