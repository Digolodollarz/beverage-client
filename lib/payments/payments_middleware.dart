import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:beverage_app/app_state.dart';
import 'package:beverage_app/payments/payments_actions.dart';
import 'package:beverage_app/payments/payments_models.dart';
import 'package:redux/redux.dart';
import 'package:http/http.dart' as http;
import 'package:beverage_app/api_endpoints.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

List<Middleware<AppState>> createPaymentMiddleware() {
  return [
    TypedMiddleware<AppState, GetPayment>(_getPaymentMiddleware()),
    TypedMiddleware<AppState, MakePayment>(_makePaymentMiddleware()),
    TypedMiddleware<AppState, LoadPayments>(_getPaymentsHistoryMiddleware()),
  ];
}

Middleware<AppState> _getPaymentMiddleware() {
  return (Store store, action, NextDispatcher next) async {
    if (action is GetPayment) {}
    next(action);
  };
}

Middleware<AppState> _getPaymentsHistoryMiddleware() {
  return (Store store, action, NextDispatcher next) async {
    if (action is LoadPayments) {
      print("Panoivo");
      var payments = await _getPaymentsHistory(store.state.user.authToken);
      print('Successfully loaded some payments, ');
      store.dispatch(LoadPaymentsSuccessful(payments: payments));
    }
    next(action);
  };
}

Middleware<AppState> _makePaymentMiddleware() {
  return (Store store, action, NextDispatcher next) async {
    if (action is MakePayment) {
      print(action.request.toJson());
      showModalBottomSheet(
          context: action.context,
          builder: (context) {
            return Center(
              child: Column(
                children: <Widget>[
                  CircularProgressIndicator(),
                  Text('Sending Payment'),
                ],
              ),
            );
          });
      try {
        var responseJson = await _requestPayment(action.request);
        Navigator.of(action.context).pop();
        var reference = responseJson['reference'];
        if (reference != null) {
          showModalBottomSheet(
            context: action.context,
            builder: (context) {
              return Center(
                child: StreamBuilder(
                  builder: (context, snapshot) {
                    print('data: ${snapshot.data}');
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        snapshot.data == "PENDING") {
                      if (action.request.method == "ECOCASH") {
                        return Center(
                          child: Column(
                            children: <Widget>[
                              CircularProgressIndicator(),
                              Text(
                                  'Payment Sent. Please check ${action.request.phone} '
                                  'and confirm payment for transaction ref'
                                  ' ${responseJson['reference']}'
                                  '\nInstructions: ${responseJson['instructions']}'),
                            ],
                          ),
                        );
                      } else {
                        return Center(
                          child: Column(
                            children: <Widget>[
                              CircularProgressIndicator(),
                              InkWell(
                                onLongPress: () {
                                  Clipboard.setData(new ClipboardData(
                                      text: '${responseJson["link"]}'));
                                },
                                child: Text(
                                  'Payment created. Please complete your payment via'
                                      '\n${responseJson["link"]}\n'
                                      'and confirm payment for transaction ref'
                                      ' ${responseJson['reference']}'
                                      'Instructions: ${responseJson['instructions']}',
                                ),
                              ),
                              RaisedButton(
                                onPressed: () =>
                                    _launchURL(responseJson["link"]),
                                child: new Text('Open Link and Pay'),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                    if (snapshot.data == "PAID") {
                      return buildPaymentSuccessfulContainer(store, action);
                    } else
                      return Text(
                        "Couldn't complete payment, ${snapshot.data}",
                      );
                  },
                  stream: _paymentStatus(
                    reference,
                    action.request.user.authToken,
                  ),
                ),
              );
            },
          );
        } else {
          showDialog(
            context: action.context,
            builder: (context) {
              return AlertDialog(
                content: Container(
                  child: Text("Failed to initiate transaction"),
                ),
              );
            },
          );
        }
      } catch (e) {
        print(e);
        Navigator.of(action.context).pop();
        showDialog(
          context: action.context,
          builder: (context) {
            return AlertDialog(
              content: Container(
                child: Text("Error initiating transaction $e"),
              ),
            );
          },
        );
      }
    }
    next(action);
  };
}

Container buildPaymentSuccessfulContainer(Store store, MakePayment action) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.0),
        topRight: Radius.circular(16.0),
      ),
    ),
    child: Column(
      children: <Widget>[
        Text(
          "Payment successful",
          style: Theme.of(action.context).textTheme.display1,
        ),
        RaisedButton(
          onPressed: () async {
            store.dispatch(MakePaymentSuccessful(action.request));
            var dispensing = await _requestBeverage(
              action.request.reference,
              store.state.user.authToken,
            );
            if (dispensing) {
              Navigator.of(action.context).pop();
              showModalBottomSheet(
                  context: action.context,
                  builder: (context) {
                    return Container(
                      child: Text("Dispensing"),
                    );
                  });
            }
          },
          child: Text('Dispense'),
        )
      ],
    ),
  );
}

Future<bool> _requestBeverage(reference, authToken) async {
  try {
    var response =
        await http.post('$apiUrl/beverage/dispense', body: reference, headers: {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $authToken',
    });
    final Map<String, dynamic> requestPaymentResponse =
        json.decode(response.body);
    if (response.statusCode == 401 ||
        requestPaymentResponse['status'] == '401') {
      print(requestPaymentResponse['error']);
      throw "Account error, ${requestPaymentResponse['error']}";
    } else if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    } else {
      throw "Something doesn't feel right \n${requestPaymentResponse['message']}";
    }
  } on Exception catch (error) {
    print(error);
    throw error;
  }
}

Stream<int> _dispenseStatus(reference, authToken) async* {
  int count = 0;
  while (count < 120) {
    try {
      var response = await http
          .post('$apiUrl/beverage/dispense/status', body: reference, headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $authToken',
      });
      final Map<String, dynamic> requestPaymentResponse =
          json.decode(response.body);
      if (response.statusCode == 401 ||
          requestPaymentResponse['status'] == '401') {
        print(requestPaymentResponse['error']);
        throw "Account error, ${requestPaymentResponse['error']}";
      } else if (response.statusCode == 201 || response.statusCode == 200) {
        yield requestPaymentResponse["poured"];
        if (requestPaymentResponse["status"] != "POURING") break;
      } else {
        throw "Something doesn't feel right \n${requestPaymentResponse['message']}";
      }
      await Future.delayed(const Duration(seconds: 1));
    } on Exception catch (error) {
      print(error);
      throw error;
    }
  }
}

Stream<String> _paymentStatus(String reference, authToken) async* {
  int count = 0;
  while (count < 120) {
    try {
      var response = await http
          .post('$apiUrl/payments/confirm', body: reference, headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $authToken',
      });
      final Map<String, dynamic> requestPaymentResponse =
          json.decode(response.body);
      if (response.statusCode == 401 ||
          requestPaymentResponse['status'] == '401') {
        print(requestPaymentResponse['error']);
        throw "Account error, ${requestPaymentResponse['error']}";
      } else if (response.statusCode == 201 || response.statusCode == 200) {
        yield requestPaymentResponse["status"];
        if (requestPaymentResponse["status"] != "PENDING") break;
      } else {
        throw "Something doesn't feel right \n${requestPaymentResponse['message']}";
      }
      await Future.delayed(const Duration(seconds: 1));
    } on Exception catch (error) {
      print(error);
      throw error;
    }
  }
}

Future _requestPayment(PaymentRequest request) async {
  try {
    var response = await http.post('$apiUrl/payments',
        body: json.encode(request.toJson()),
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer ${request.user.authToken}',
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

_launchURL(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Future<List<Payment>> _getPaymentsHistory(authToken) async {
  try {
    var response = await http.get('$apiUrl/payments', headers: {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $authToken',
    });
    final List<dynamic> getPaymentsResponse = json.decode(response.body);
    if (response.statusCode == 401) {
//      print(getPaymentsResponse['error']);
      throw "Account error, ${getPaymentsResponse}";
    } else if (response.statusCode == 201 || response.statusCode == 200) {
      final List<Payment> paymentsList = getPaymentsResponse
          .map((payment) => Payment.fromJson(payment))
          .toList();
      return paymentsList;
    } else {
      throw "Something doesn't feel right \n${getPaymentsResponse}";
    }
  } on Exception catch (error) {
    print(error);
    throw error;
  }
}

Future _waitForPayment(String reference, authToken) async {
  bool done = false;

  while (!done) {
    try {
      var response = await http
          .post('$apiUrl/payments/confirm', body: reference, headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer ${authToken}',
      });
      final Map<String, dynamic> requestPaymentResponse =
          json.decode(response.body);
      print(requestPaymentResponse);

      if (response.statusCode == 401 ||
          requestPaymentResponse['status'] == '401') {
        print(requestPaymentResponse['error']);
        done = true;
        throw "Account error, ${requestPaymentResponse['error']}";
      } else if (response.statusCode == 201 || response.statusCode == 200) {
        print(requestPaymentResponse);
        done = true;
        return requestPaymentResponse;
      } else {
        done = true;
        throw "Something doesn't feel right \n${requestPaymentResponse['message']}";
      }
    } on Exception catch (error) {
      print(error);
      done = true;
      throw error;
    }
  }
}

//Future _requestPayment(PaymentRequest request) async {
//  try {
//    var response = await http.post('$apiUrl/payments',
//        body: json.encode(request.toJson()),
//        headers: {
//          'Content-type': 'application/json',
//          'Authorization': 'Bearer ${request.user.authToken}',
//        });
//    final Map<String, dynamic> requestPaymentResponse =
//    json.decode(response.body);
//    print(requestPaymentResponse);
//
//    if (response.statusCode == 401 ||
//        requestPaymentResponse['status'] == '401') {
//      print(requestPaymentResponse['error']);
//      throw "Account error, ${requestPaymentResponse['error']}";
//    } else if (response.statusCode == 201 || response.statusCode == 200) {
//      return requestPaymentResponse;
//    } else {
//      throw "Something doesn't feel right \n${requestPaymentResponse['message']}";
//    }
//  } on Exception catch (error) {
//    print(error);
//    throw error;
//  }
//}
