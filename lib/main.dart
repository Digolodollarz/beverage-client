import 'package:flutter/material.dart';
import 'package:beverage_app/app_state.dart';
import 'package:beverage_app/auth/auth_actions.dart';
import 'package:beverage_app/auth/auth_middleware.dart';
import 'package:beverage_app/auth/auth_models.dart';
import 'package:beverage_app/auth/login_container.dart';
import 'package:beverage_app/chat/chat_middleware.dart';
import 'package:beverage_app/chats/chats_actions.dart';
import 'package:beverage_app/chats/chats_container.dart';
import 'package:beverage_app/chats/chats_middleware.dart';
import 'package:beverage_app/home/home_container.dart';
import 'package:beverage_app/location/location_page.dart';
import 'package:beverage_app/payments/payments_container.dart';
import 'package:beverage_app/theme.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:beverage_app/reducers/app_reducer.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';
import 'package:location/location.dart';
import 'dart:async';
import 'package:flutter/services.dart';

void main() async {
  final persistor = Persistor<AppState>(
      storage: FlutterStorage(),
      serializer: JsonSerializer<AppState>(AppState.fromJson),
      debug: true);
  final initialState = await persistor.load() ?? null;
  final store = new Store<AppState>(
    appReducer,
    initialState: initialState ?? new AppState(),
    middleware: [persistor.createMiddleware()]
      ..addAll(createAuthMiddleware())
      ..addAll(createChatsMiddleware())
      ..addAll(createChatMiddleware())
      ..add(new LoggingMiddleware.printer()),
  );
  runApp(MyApp(
    store: store,
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Store<AppState> store;

  const MyApp({Key key, this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        title: 'Beverage Mobile',
        theme: getAppTheme(),
        home: HomeContainer(),
      ),
    );
  }
}
