import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:beverage_app/app_state.dart';
import 'package:beverage_app/payments/payments_actions.dart';
import 'package:beverage_app/payments/payments_models.dart';
import 'package:redux/redux.dart';

class PaymentsPageContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (BuildContext context, _ViewModel vm) {
        return PaymentsPage(vm: vm);
      },
    );
  }
}

class PaymentsPage extends StatefulWidget {
  final _ViewModel vm;

  const PaymentsPage({Key key, this.vm}) : super(key: key);

  @override
  PaymentsPageState createState() {
    return new PaymentsPageState();
  }
}

class PaymentsPageState extends State<PaymentsPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _ecoCashNumberController = TextEditingController();
  final _amountFormKey = GlobalKey<FormState>();
  final PaymentRequest _paymentRequest =
      PaymentRequest(items: Map<String, double>());
  Map<String, double> newItem = Map();

  int _paymentRadioValue = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Payments'),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text("Fake Item Name"),
                          Expanded(
                            child: TextFormField(
                              controller: _nameController,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text("Test Amount"),
                          Expanded(
                            child: TextFormField(
                              controller: _amountController,
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment(1, 0),
                        child: RaisedButton(
                          child: Text("Add"),
                          onPressed: () {
                            if (_nameController.value.text.trim().length > 0 &&
                                _amountController.value.text.trim().length > 0)
                              setState(() {
                                _paymentRequest
                                        .items[_nameController.value.text] =
                                    double.parse(_amountController.value.text);
                                _nameController.clear();
                                _amountController.clear();
                              });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var item =
                              _paymentRequest.items.keys.elementAt(index);
                          var price = _paymentRequest.items[item];
                          return Text('$item \$$price');
                        },
                        itemCount: _paymentRequest.items.length,
                      ),
                      Text('Total: ${_getTotal()}'),
                    ],
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                child: Column(
                  children: <Widget>[
                    new Row(
                      children: <Widget>[
                        new Radio(
                          value: 0,
                          groupValue: _paymentRadioValue,
                          onChanged: _handleRadioValueChange1,
                        ),
                        new Text(
                          'EcoCash',
                          style: new TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        new Radio(
                          value: 1,
                          groupValue: _paymentRadioValue,
                          onChanged: _handleRadioValueChange1,
                        ),
                        new Text(
                          'TeleCash',
                          style: new TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        new Radio(
                          value: 2,
                          groupValue: _paymentRadioValue,
                          onChanged: _handleRadioValueChange1,
                        ),
                        new Text(
                          'PayNow',
                          style: new TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: _paymentRadioValue == 0,
                      child: Form(
                        key: _amountFormKey,
                        child: TextFormField(
                          controller: _ecoCashNumberController,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: false),
                          validator: EconetNumberValidator,
                          inputFormatters: [EcoCashNumberTextFormatter()],
                        ),
                      ),
                    ),
                    RaisedButton(
                      child: Text("Make Payment"),
                      onPressed: () {
                        if (_paymentRadioValue == 0) {
                          _amountFormKey.currentState.validate();
                        }
                        print(_paymentRequest.toJson());
//                  widget.vm.makePaymentCallback(_paymentRequest);
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _getTotal() {
    double total = 0.0;
    this._paymentRequest.items.forEach((item, price) => total += price);
    return total;
  }

  _handleRadioValueChange1(value) {
    setState(() {
      this._paymentRadioValue = value;
    });
  }
}

class _ViewModel {
  final Payment payment;
  final List<Payment> currentPayments;
  final Function(PaymentRequest, BuildContext) makePaymentCallback;

  _ViewModel({this.payment, this.makePaymentCallback, this.currentPayments});

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      payment: store.state.currentPayment,
      currentPayments: store.state.currentPayments,
      makePaymentCallback: (PaymentRequest request, context) =>
          store.dispatch(MakePayment(request, context)),
    );
  }
}

class EcoCashNumberTextFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length == 0) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      int selectionIndexFromTheRight =
          newValue.text.length - newValue.selection.end;

      String newString = newValue.text
          .toString()
          .replaceFirst(r"+263", "0")
          .replaceAll(" ", "");
      if (newString.startsWith('7')) {
        newString = '0$newString';
      }
      return new TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(
            offset: newString.length - selectionIndexFromTheRight),
      );
    } else {
      return newValue;
    }
  }
}

String EconetNumberValidator(String value) {
  if (value.isEmpty) return 'Empty';
  var exp = new RegExp(r"07(7|8)\d{7}");
  if (exp.hasMatch(value)) return null;
  return 'Invalid number';
}
