import 'package:flutter/material.dart';
import '../../Helper/HttpException.dart';
import '../../repositories/authentication.dart';
import '../../widgets/logo_widget/login_widget.dart';
import 'package:provider/provider.dart';

enum AuthMode { Signup, Login }

class LogoScreen extends StatefulWidget {
  static const routeName = '/LogoScreen';

  @override
  _LogoScreenState createState() => _LogoScreenState();
}

class _LogoScreenState extends State<LogoScreen>
    with SingleTickerProviderStateMixin {
  AuthMode _authMode = AuthMode.Login;
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey();
  AnimationController _animationController;
  Animation<double> _opacity;
  Animation<Offset> _slideAnimation;
  TextEditingController _passwordEditingController;

  @override
  void initState() {
    super.initState();
    _passwordEditingController = TextEditingController();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 320),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -4),
      end: Offset(0, 0.01),
    ).animate(
      CurvedAnimation(
          parent: _animationController, curve: Curves.fastLinearToSlowEaseIn),
    );

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
    _passwordEditingController.dispose();
  }

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  Future<void> _showErrorDialog(String errorMessage) {
    return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('An Error Eccured!'),
              content: Text(errorMessage),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(ctx).pop(), child: Text('Ok'))
              ],
            ));
  }

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Authentication>(context, listen: false)
            .signIn(email: _authData['email'], password: _authData['password']);
      } else {
        await Provider.of<Authentication>(context, listen: false)
            .signUp(email: _authData['email'], password: _authData['password']);
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a validemail address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      var errorMessage = 'Authentication failed';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [Color(0xff4e48ff), Color(0xff5478ff), Color(0xff5cb7ff)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      )),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        _authMode == AuthMode.Login
                            ? 'WELCOME BACK'
                            : 'WELCOME',
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 320),
                        curve: Curves.fastOutSlowIn,
                        height: _authMode == AuthMode.Login ? 400 : 460,
                        child: Stack(alignment: Alignment.center, children: [
                          AnimatedContainer(
                            duration: Duration(milliseconds: 320),
                            curve: Curves.fastOutSlowIn,
                            height: _authMode == AuthMode.Login ? 320 : 380,
                            width: 320,
                            child: Card(
                                // margin: EdgeInsets.symmetric(horizontal: 30),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                elevation: 5.0,
                                child: Column(children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 10),
                                    child: Row(
                                      children: [
                                        TextButton(
                                            onPressed: () => setState(() {
                                                  _authMode = AuthMode.Login;
                                                  _animationController
                                                      .reverse();
                                                }),
                                            child: Column(
                                              children: [
                                                Text('Login',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                        color: _authMode ==
                                                                AuthMode.Login
                                                            ? Colors.blue
                                                            : Colors.grey)),
                                                Text(
                                                  ' ______',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: _authMode ==
                                                              AuthMode.Login
                                                          ? Colors.blue.shade300
                                                          : Colors.white,
                                                      fontSize: 17),
                                                )
                                              ],
                                            )), //0xff5478ff
                                        SizedBox(
                                          width: 80,
                                        ),
                                        TextButton(
                                            onPressed: () => setState(() {
                                                  _authMode = AuthMode.Signup;
                                                  _animationController
                                                      .forward();
                                                }),
                                            child: Column(
                                              children: [
                                                Text('Signup',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                        color: _authMode ==
                                                                AuthMode.Signup
                                                            ? Colors.blue
                                                            : Colors.grey)),
                                                Text(
                                                  '______',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: _authMode ==
                                                              AuthMode.Signup
                                                          ? Colors.blue.shade300
                                                          : Colors.white,
                                                      fontSize: 17),
                                                )
                                              ],
                                            )), //0xff5478ff
                                      ],
                                    ),
                                  ),
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        TextContainer(
                                            textInputType:
                                                TextInputType.emailAddress,
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return "Enter Your Email!";
                                              } else if (!value.contains('@')) {
                                                return "Invalid Email";
                                              }
                                              return null;
                                            },
                                            hintText: 'Email',
                                            prefixIcon: Icons.email,
                                            onSaved: (value) {
                                              _authData['email'] = value;
                                            }),
                                            SizedBox(height: 10.0,),
                                        TextContainer(
                                            isObscured: true,
                                            textEditingController:
                                                _passwordEditingController,
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return "Enter Your Password!";
                                              } else if (value.length < 6) {
                                                return "Too Short Password";
                                              }
                                              return null;
                                            },
                                            hintText: 'Password',
                                            prefixIcon: Icons.lock,
                                            onSaved: (value) {
                                              _authData['password'] = value;
                                            }),
                                        // if (state == InorupSignUP())
                                        if(_authMode == AuthMode.Signup)
                                            SizedBox(height: 10.0,),
                                        
                                        AnimatedContainer(
                                          constraints: BoxConstraints(
                                            minHeight:
                                                _authMode == AuthMode.Login
                                                    ? 0
                                                    : 60,
                                            maxHeight:
                                                _authMode == AuthMode.Login
                                                    ? 0
                                                    : 150,
                                          ),
                                          duration: Duration(milliseconds: 320),
                                          curve: Curves.easeIn,
                                          child: FadeTransition(
                                            opacity: _opacity,
                                            child: SlideTransition(
                                              position: _slideAnimation,
                                              child: TextContainer(
                                                isObscured: true,
                                                validator:
                                                    _authMode == AuthMode.Signup
                                                        ? (value) {
                                                            if (value !=
                                                                _passwordEditingController
                                                                    .text) {
                                                              return "Password do not match";
                                                            }
                                                            return null;
                                                          }
                                                        : null,
                                                isEnabled: _authMode ==
                                                    AuthMode.Signup,
                                                hintText: 'Confirm Password',
                                                prefixIcon: Icons.lock,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ])),
                          ),
                          Align(
                              alignment: Alignment.bottomCenter,
                              child: _isLoading ? CircularProgressIndicator(color: Colors.white,):
                              InkWell(
                                highlightColor: Colors.transparent,
                                overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                onTap: (){
                                  _submit();
                                },
                                child: logoButton()))
                        ]),
                      ),
                      // buildCircleUpDown(
                      //     showShadow: false,
                      //     isLoading: _isLoading,
                      //     submit: _submit),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget logoButton() => CircleAvatar(
        radius: 43.0,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          backgroundColor: Colors.blue.shade700,
          radius: 40.0,
          child: Icon(
            Icons.arrow_forward,
            color: Colors.white,
            size: 30.0,
          ),
        ),
      );
}
