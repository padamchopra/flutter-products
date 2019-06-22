import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';

enum AuthMode { Signup, Login }

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
    'acceptTerms': false
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController();
  AuthMode _authMode = AuthMode.Login;

  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
      colorFilter: ColorFilter.mode(
        Colors.black.withOpacity(0.5),
        BlendMode.dstATop,
      ),
      image: AssetImage('assets/background.jpg'),
      fit: BoxFit.cover,
    );
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Email', filled: true, fillColor: Colors.white),
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      validator: (String value) {
        if (value.isEmpty) {
          return "Please provide an email";
        } else if (!RegExp(
                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return "Invalid email";
        }
      },
      onSaved: (String value) {
        _formData['email'] = value;
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Password', filled: true, fillColor: Colors.white),
      obscureText: true,
      autocorrect: false,
      controller: _passwordTextController,
      validator: (String value) {
        if (value.isEmpty) {
          return "Please enter a password";
        } else if (value.length < 6) {
          return "Needs to be 6 characters or more";
        }
      },
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }

  Widget _buildPasswordConfirmTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Confirm Password', filled: true, fillColor: Colors.white),
      obscureText: true,
      autocorrect: false,
      validator: (String value) {
        if (value.isEmpty) {
          return "Please confirm password";
        } else if (_passwordTextController.text != value) {
          return "Passwords do not match";
        }
      },
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }

  Widget _buildAcceptSwitch() {
    return SwitchListTile(
      title: Text("Accept Terms"),
      value: _formData['acceptTerms'],
      onChanged: (bool value) {
        setState(() {
          _formData['acceptTerms'] = value;
        });
      },
    );
  }

  void _submitForm(Function login, Function signup) async {
    if (_formKey.currentState.validate() && _formData['acceptTerms']) {
      _formKey.currentState.save();
      if (_authMode == AuthMode.Login) {
        login(_formData['email'], _formData['password']);
      } else {
        final Map<String, dynamic> successInformation =
            await signup(_formData['email'], _formData['password']);
        if (successInformation['success']) {
          Navigator.pushReplacementNamed(context, '/products');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 768.0 ? 500.0 : deviceWidth * 0.95;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: new Text("Login"),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: _buildBackgroundImage(),
        ),
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: targetWidth,
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    _buildEmailTextField(),
                    SizedBox(
                      height: 10.0,
                    ),
                    _buildPasswordTextField(),
                    SizedBox(
                      height: 10.0,
                    ),
                    _authMode == AuthMode.Signup
                        ? _buildPasswordConfirmTextField()
                        : Container(),
                    _buildAcceptSwitch(),
                    SizedBox(
                      height: 10.0,
                    ),
                    FlatButton(
                      color: Theme.of(context).accentColor,
                      textColor: Colors.white,
                      child: Text(
                          "Switch to ${_authMode == AuthMode.Login ? 'Signup' : 'Login'}"),
                      onPressed: () {
                        setState(() {
                          _authMode = _authMode == AuthMode.Login
                              ? AuthMode.Signup
                              : AuthMode.Login;
                        });
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    ScopedModelDescendant<MainModel>(
                      builder: (BuildContext context, Widget child,
                          MainModel model) {
                        return RaisedButton(
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          onPressed: () =>
                              _submitForm(model.login, model.signUp),
                          child: Text("Login"),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
