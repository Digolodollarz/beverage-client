import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:location/location.dart';
import 'package:redux/redux.dart';
import 'package:beverage_app/app_state.dart';
import 'package:beverage_app/auth/auth_actions.dart';
import 'package:beverage_app/auth/auth_models.dart';
import 'package:beverage_app/auth/login_container.dart';
import 'package:beverage_app/chats/chats_actions.dart';
import 'package:beverage_app/chats/chats_container.dart';
import 'package:beverage_app/home/dashboard_item_widget.dart';
import 'package:beverage_app/location/location_page.dart';
import 'package:beverage_app/payments/payments_container.dart';
import 'package:flutter/services.dart';

class HomeContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (BuildContext context, _ViewModel vm) {
        return vm.user != null ? HomePage(vm: vm) : LoginPageContainer();
      },
    );
  }
}

class _ViewModel {
  final Function loadChats;
  final AppUser user;

  _ViewModel({this.loadChats, this.user});

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      loadChats: () => store.dispatch(GetChats()),
      user: store.state.user,
    );
  }
}

class HomePage extends StatelessWidget {
  final _ViewModel vm;

  const HomePage({Key key, this.vm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Beverage"),
        actions: <Widget>[
//            TODO: Make this thing work!
//            PopupMenuButton(
//              itemBuilder: (BuildContext context) {
//                return <PopupMenuEntry>[
//                  PopupMenuItem(
//                    child: LogoutContainer(),
//                  ),
//                  PopupMenuItem(
//                    child: LogoutContainer(),
//                  )
//                ];
//              },
//            )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: <Widget>[
                  DashboardItem(),
                  DashboardItem(),
                  DashboardItem(),
                  DashboardItem(),
                  DashboardItem(),
                ],
              ),
            ),
            LogoutContainer(),
          ],
        ),
      ),
    );
  }

  Future _getLocation() async {
    var currentLocation = <String, double>{};

    var location = new Location();
    var error;

// Platform messages may fail, so we use a try/catch PlatformException.
    try {
      print("Getting Permishan");
      var _permission = await location.hasPermission();
      currentLocation = await location.getLocation();
      return currentLocation;
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error =
            'Permission denied - please ask the user to enable it from the app settings';
      } else {
        error = e;
        print(e);
      }
      currentLocation = null;
      throw e;
    }
  }
}

class LogoutContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _LogoutViewModel>(
        converter: _LogoutViewModel.fromStore,
        builder: (BuildContext context, _LogoutViewModel vm) {
          return FlatButton(
            onPressed: () {
              vm.logoutCallback();
              print('me');
            },
            child: Text('Log out ${vm.user.email}'),
          );
        });
  }
}

class _LogoutViewModel {
  final AppUser user;
  final logoutCallback;

  _LogoutViewModel({this.user, this.logoutCallback});

  static _LogoutViewModel fromStore(Store<AppState> store) {
    return _LogoutViewModel(
        user: store.state.user, logoutCallback: () => store.dispatch(LogOut()));
  }
}

//InkWell(
//child: Card(
//shape: RoundedRectangleBorder(
//borderRadius: BorderRadius.circular(16.0),
//),
//margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//child: Padding(
//padding: const EdgeInsets.all(32.0),
//child: Center(
//child: Text(
//"Manage payments",
//style: Theme.of(context).textTheme.display1.copyWith(
//color: Theme.of(context).primaryColor,
//fontWeight: FontWeight.bold,
//),
//)),
//),
//),
//onTap: () => Navigator.of(context).push(MaterialPageRoute(
//builder: (context) => PaymentsPageContainer(),
//)),
//),
//InkWell(
//child: Card(
//shape: RoundedRectangleBorder(
//borderRadius: BorderRadius.circular(16.0),
//),
//margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//child: Padding(
//padding: const EdgeInsets.all(32.0),
//child: Center(
//child: Text(
//"Chats sample",
//style: Theme.of(context).textTheme.display1.copyWith(
//color: Theme.of(context).primaryColor,
//fontWeight: FontWeight.bold,
//),
//)),
//),
//),
//onTap: () {
//vm.loadChats();
//Navigator.of(context).push(
//MaterialPageRoute(
//builder: (context) => ChatsPageContainer(),
//),
//);
//},
//),
//InkWell(
//child: Card(
//shape: RoundedRectangleBorder(
//borderRadius: BorderRadius.circular(16.0),
//),
//margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//child: FutureBuilder(
//builder: (context, snapshot) {
//if (snapshot.hasData) {
//return Padding(
//padding: const EdgeInsets.all(32.0),
//child: Center(
//child: Text(
//"${snapshot.data['latitude']}",
//style: Theme.of(context).textTheme.display1.copyWith(
//color: Theme.of(context).primaryColor,
//fontWeight: FontWeight.bold,
//),
//)),
//);
//} else if (snapshot.hasError) {
//PlatformException e = snapshot.error;
//var error;
//if (e.code == 'PERMISSION_DENIED') {
//error = 'Permission denied';
//} else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
//error =
//'Permission denied - please enable it from the app settings';
//}
//return Padding(
//padding: const EdgeInsets.all(32.0),
//child: Center(
//child: Text('Error getting location \n$error'),
//),
//);
//} else
//return Padding(
//padding: const EdgeInsets.all(32.0),
//child: Center(child: CircularProgressIndicator()),
//);
//},
//future: _getLocation(),
//),
//),
//onTap: () {
//vm.loadChats();
//Navigator.of(context).push(
//MaterialPageRoute(
//builder: (context) => LocationPage(),
//),
//);
//},
//),
