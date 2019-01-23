import 'package:flutter/material.dart';
import 'package:beverage_app/auth/auth_models.dart';
import 'package:beverage_app/auth/reset_container.dart';
import 'package:beverage_app/auth/signup_container.dart';

class LoginForm extends StatefulWidget {
  final Function(UserForm, BuildContext) loginCallback;
  final dynamic error;

  const LoginForm({Key key, this.loginCallback, this.error}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  UserForm userForm = UserForm();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Sign In',
                    style: Theme.of(context).textTheme.display1.copyWith(
                          color: Theme.of(context).primaryColorDark,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 32.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: _inputDecoration('Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) =>
                        Validators.email(value) ? null : "Enter valid email",
                    onSaved: (value) => userForm.email = value,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: _inputDecoration("Password"),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                    },
                    onSaved: (value) => userForm.password = value,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return ResetPageContainer();
                            },
                          ));
                        },
                        child: Text(
                          'Forgot password?',
                          style: Theme.of(context).textTheme.body2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColorDark,
                    Theme.of(context).primaryColor,
                  ],
                ),
              ),
              child: FlatButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    widget.loginCallback(userForm, context);
//                todo: give visual feedback for the click action.
                  }
                },
                child: Center(
                  child: Text(
                    'Sign In',
                    style: Theme.of(context).textTheme.button.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
            ),
            InkWell(
              child: Text("Don't have an account? Create Account."),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return SignUpPageContainer();
                }));
              },
            )
          ]),
        ),
      ),
    );
  }
}

InputDecoration _inputDecoration(final String text) {
  return InputDecoration(
    hintText: text,
    filled: true,
    fillColor: const Color(0x33ffffff),
    border: OutlineInputBorder(),
  );
}
