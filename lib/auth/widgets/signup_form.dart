import 'package:flutter/material.dart';
import 'package:beverage_app/auth/auth_models.dart';

class SignupForm extends StatefulWidget {
  final dynamic error;
  final Function(UserForm, BuildContext) signupCallback;

  const SignupForm({Key key, this.error, this.signupCallback})
      : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  UserForm userForm = UserForm();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Sign Up',
                      style: Theme.of(context).textTheme.display1.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  TextFormField(
                    decoration: _inputDecoration("Name"),
                    validator: (value) => value != null && value.length > 2
                        ? null
                        : "Enter first name",
                    onSaved: (value) => userForm.firstName = value,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                  ),
                  TextFormField(
                    decoration: _inputDecoration("Last name"),
                    validator: (value) => value != null && value.length > 2
                        ? null
                        : "Enter last name",
                    onSaved: (value) => userForm.lastName = value,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                  ),
                  TextFormField(
                    decoration: _inputDecoration("Email"),
                    validator: (value) =>
                        Validators.email(value) ? null : "Enter valid email",
                    onSaved: (value) => userForm.email = value,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                  ),
                  TextFormField(
                    // The validator receives the text the user has typed in
                    obscureText: true,
                    decoration: _inputDecoration("Password"),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a password';
                      }
                    },
                    onSaved: (value) => userForm.password = value,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                  ),
                  TextFormField(
                    // The validator receives the text the user has typed in
                    obscureText: true,
                    decoration: _inputDecoration("Confirm password"),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please confirm password';
                      }
                    },
                    onEditingComplete: () {},
                    onSaved: (value) => userForm.confirmPassword = value,
                  ),
                ],
              ),
              RaisedButton(
                elevation: 8,
                onPressed: () {
                  // Validate will return true if the form is valid, or false if
                  // the form is invalid.
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    widget.signupCallback(userForm, context);
                  }
                },
                color: Theme.of(context).primaryColor,
                textColor: const Color(0xCCFFFFFF),
                child: Center(child: Text('Register')),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0)),
              ),
              InkWell(
                child: Text("Already have an account? Log In."),
                onTap: () {
                  Navigator.of(context).pop();
                },
              )
            ]),
          ),
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
