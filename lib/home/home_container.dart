import 'dart:convert';

import 'package:beverage_app/api_endpoints.dart';
import 'package:beverage_app/external/fluid_slider.dart';
import 'package:beverage_app/payments/payments_actions.dart';
import 'package:beverage_app/payments/payments_models.dart';
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
import 'package:http/http.dart' as http;

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
  final String ecocashPhone;
  final Function(PaymentRequest, BuildContext) makePayment;

  _ViewModel({this.loadChats, this.user, this.ecocashPhone, this.makePayment});

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      loadChats: () => store.dispatch(GetChats()),
      user: store.state.user,
      ecocashPhone: store.state.ecocashPhone,
      makePayment: (_request, _context) =>
          store.dispatch(MakePayment(_request, _context)),
    );
  }
}

class HomePage extends StatefulWidget {
  final _ViewModel vm;

  const HomePage({Key key, this.vm}) : super(key: key);

  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  double beverageAmount = 330;
  TextEditingController _ecoCashNumberController = TextEditingController();
  final _numberFormKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColorLight,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: <Widget>[
            Text('Amount of juice'),
            Text('$beverageAmount ml'),
            FluidSlider(
              value: beverageAmount,
              onChanged: (double newValue) {
                setState(() {
                  beverageAmount = newValue;
                });
              },
              min: 0.0,
              max: 1000.0,
              sliderColor: Theme.of(context).primaryColor,
              thumbColor: Theme.of(context).accentColor,
            ),
            Visibility(
              visible: true,
              child: Form(
                key: _numberFormKey,
                child: TextFormField(
                  controller: _ecoCashNumberController,
                  keyboardType: TextInputType.numberWithOptions(decimal: false),
                  validator: EconetNumberValidator,
                  inputFormatters: [EcoCashNumberTextFormatter()],
                ),
              ),
            ),
            RaisedButton(
              child: Text("Make Payment"),
              onPressed: () {
                if (_numberFormKey.currentState.validate()) {
//                  widget.vm.makePaymentCallback(_paymentRequest);
                  final _paymentRequest = PaymentRequest();
                  _paymentRequest.items = {
                    '${beverageAmount.toInt()}ml Juice':
                        beverageAmount * 5 / 1000
                  };
                  _paymentRequest.reference = DateTime.now().toIso8601String();
                  _paymentRequest.method = "ECOCASH";
                  _paymentRequest.email = widget.vm.user.email.toLowerCase();
                  _paymentRequest.user = widget.vm.user;
                  _paymentRequest.phone = _ecoCashNumberController.text;
                  print('PYMENT rEQASDF');
                  _scaffoldKey.currentState.showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 5),
                      content: Text('Paying $_paymentRequest'),
                    ),
                  );
                  print(_paymentRequest.toJson());
//                  _pay(_paymentRequest);
                  widget.vm.makePayment(_paymentRequest, context);
                }
              },
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

  Future _requestPayment(PaymentRequest request) async {
    try {
      var response = await http.post('$apiUrl/payments',
          body: json.encode(request.toJson()),
          headers: {
            'Content-type': 'application/json',
            'Authorization': 'Bearer ${widget.vm.user.authToken}',
          });
      final Map<String, dynamic> requestPaymentResponse =
          json.decode(response.body);
      print(requestPaymentResponse);

      if (response.statusCode == 401 ||
          requestPaymentResponse['status'] == '401') {
        print(requestPaymentResponse['error']);
        throw "Account error, ${requestPaymentResponse['error']}";
      } else if (response.statusCode == 201 || response.statusCode == 200) {
        return requestPaymentResponse;
      } else {
        throw "Something doesn't feel right \n${requestPaymentResponse['message']}";
      }
    } on Exception catch (error) {
      print(error);
      throw error;
    }
  }

  _pay(PaymentRequest request) {
    showDialog(
      context: context,
      builder: (BuildContext context) => new AlertDialog(
            title: new Text('Processing Payment'),
            content: Container(
              child: FutureBuilder(
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return FutureBuilder(
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return Text("Payment Successfull");
                        } else if (snapshot.hasError) {
                          return Text("You didn't pay did you?");
                        }
                        return Text(
                          'Payment Request sent. Please check ${request.phone} and confirm.',
                        );
                      },
                      future: _waitForPayment(),
                    );
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error);
                  }
                  return CircularProgressIndicator();
                },
                future: _requestPayment(request),
              ),
            ),
          ),
    );
  }

  Future _waitForPayment() async {
    await Future.delayed(Duration(seconds: 22));
    return 'done';
  }
}

_showLoadingDialog(BuildContext context, {text = "Please Wait"}) {
  showDialog(
    context: context,
    builder: (_) => new AlertDialog(
          title: new Text(text),
          content: CircularProgressIndicator(),
        ),
  );
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
