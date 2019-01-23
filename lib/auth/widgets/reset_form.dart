import 'package:flutter/material.dart';
import 'package:beverage_app/auth/auth_models.dart';

class ResetForm extends StatefulWidget {
  final dynamic error;
  final Function(UserForm, BuildContext) resetCallback;
  final Function(UserForm, BuildContext) requestResetCallback;

  const ResetForm(
      {Key key, this.error, this.resetCallback, this.requestResetCallback})
      : super(key: key);

  @override
  _ResetFormState createState() => _ResetFormState();
}

class _ResetFormState extends State<ResetForm> {
  final _formKey = GlobalKey<FormState>();
  UserForm userForm = UserForm();
  bool enterKey = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 32.0),
              child: Text(
                'Forgot Password',
                style: Theme.of(context).textTheme.display1.copyWith(
                      color: Theme.of(context).primaryColorDark,
                    ),
                textAlign: TextAlign.start,
              ),
            ),
            enterKey
                ? Container(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            'We just need your registerd email to send the reset'
                                ' token',
                            style: Theme.of(context).textTheme.body2.copyWith(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        TextFormField(
                          decoration: _inputDecoration('E-Mail'),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) => Validators.email(value)
                              ? null
                              : "Enter valid email",
                          onSaved: (value) => userForm.email = value,
                        ),
                      ],
                    ),
                  )
                : Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            'Please enter your email address and token to reset your password',
                            style: Theme.of(context)
                                .textTheme
                                .body2
                                .copyWith(fontSize: 16, color: Colors.grey),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        TextFormField(
                          decoration: _inputDecoration('E-Mail'),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) => Validators.email(value)
                              ? null
                              : "Enter valid email",
                          onSaved: (value) => userForm.email = value,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16.0),
                        ),
                        TextFormField(
                          decoration: _inputDecoration('Token'),
                          keyboardType: TextInputType.number,
                          validator: (value) {},
                          onSaved: (value) => userForm.token = value,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16.0),
                        ),
                        TextFormField(
                          obscureText: true,
                          decoration: _inputDecoration('New Password'),
                          validator: (value) =>
                              value.length > 4 ? null : "Enter password",
                          onSaved: (value) => userForm.password = value,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16.0),
                        ),
                      ],
                    ),
                  ),
            RaisedButton(
              elevation: 8,
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  if (enterKey)
                    widget.requestResetCallback(userForm, context);
                  else
                    widget.resetCallback(userForm, context);
//                todo: give visual feedback for the click action.
                }
              },
              color: Theme.of(context).primaryColorDark,
              textColor: const Color(0xCCFFFFFF),
              child: Center(
                child: Text(
                  enterKey ? 'Request reset' : 'Reset Password',
                  style: Theme.of(context).textTheme.button.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
            InkWell(
              child: Text(enterKey ? 'Have token? Enter' : 'Request new token'),
              onTap: () => this.setState(() => enterKey = !enterKey),
            )
          ],
        ),
      ),
    );
  }
}

InputDecoration _inputDecoration(final String text) {
  return InputDecoration(
    hintText: text,
    border: OutlineInputBorder(),
  );
}
