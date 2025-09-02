import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jeuEducatif/Dashboards/Admin/admin.dart';
import 'package:jeuEducatif/Dashboards/Apprenant/apprenant.dart';
import 'package:jeuEducatif/Dashboards/Educateur/educateur.dart';
import 'package:lottie/lottie.dart';

import '../services/AuthentificationService.dart';
import 'register.dart';
import 'package:jeuEducatif/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              return _buildLargeScreen(size);
            } else {
              return _buildSmallScreen(size);
            }
          },
        ),
      ),
    );
  }

  /// Large screen layout
  Widget _buildLargeScreen(Size size) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: RotatedBox(
            quarterTurns: 3,
            child: Lottie.asset(
              'assets/coin.json',
              height: size.height * 0.3,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
          ),
        ),
        SizedBox(width: size.width * 0.06),
        Expanded(
          flex: 5,
          child: _buildMainBody(size),
        ),
      ],
    );
  }

  /// Small screen layout
  Widget _buildSmallScreen(Size size) {
    return Center(
      child: _buildMainBody(size),
    );
  }

  /// Main login form
  Widget _buildMainBody(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
      size.width > 600 ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        if (size.width <= 600)
          Lottie.asset(
            'assets/wave.json',
            height: size.height * 0.2,
            width: size.width,
            fit: BoxFit.fill,
          ),
        SizedBox(height: size.height * 0.03),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text('Login', style: kLoginTitleStyle(size)),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text('BIENVENUE A VOUS Veuillez vous connecter', style: kLoginSubtitleStyle(size)),
        ),
        SizedBox(height: size.height * 0.03),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                /// Username or Gmail
                TextFormField(
                  style: kTextFormFieldStyle(),
                  controller: emailController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    hintText: 'Gmail',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'svp remplissez votre email';
                    } else if (value.length < 7) {
                      return 'At least 4 characters';
                    } else if (value.length > 20) {
                      return 'Maximum 23 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: size.height * 0.02),

                /// Password
                TextFormField(
                  style: kTextFormFieldStyle(),
                  controller: passwordController,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_open),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                    hintText: 'Password',
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    } else if (value.length < 8) {
                      return 'At least 8 characters';
                    } else if (value.length > 13) {
                      return 'Maximum 80 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: size.height * 0.01),
                Text(
                  'Creating an account means you\'re okay with our Terms of Services and our Privacy Policy',
                  style: kLoginTermsAndPrivacyStyle(size),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: size.height * 0.02),

                /// Login Button
                _loginButton(),

                SizedBox(height: size.height * 0.03),

                /// Navigate to Register
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (ctx) => const Register()),
                    );
                    emailController.clear();
                    passwordController.clear();
                    _formKey.currentState?.reset();
                    setState(() {
                      _isObscure = true;
                    });
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'As tu un compte ?',
                      style: kHaveAnAccountStyle(size),
                      children: [
                        TextSpan(
                          text: " Se connecter",
                          style: kLoginOrSignUpTextStyle(size),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Login Button
  Widget _loginButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.deepPurpleAccent),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // TODO: Connect to API or navigate to home
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Login successful')),
            );

          }

          login();
        },
        child: const Text('Login'),
      ),
    );
  }

  void login() async {
    try {
      final authService = AuthService();
      final user = await authService.login(emailController.text, passwordController.text);

      if (user != null && user.role != null) {
        final role = user.role.toString().toUpperCase();

        switch (role) {
          case 'EDUCATEUR':
            Navigator.push(context, MaterialPageRoute(builder: (_) => EDUCATEURDashboard( user: {
              "nomPrenom": user.nomPrenom,
              "email": user.email,
              "role": user.role.toString(),

            },)));
            break;
          case 'ADMIN':
            Navigator.push(context, MaterialPageRoute(builder: (_) => AdminDashboard(user:  {
              "nomPrenom": "makon",
              "email": "yvette@example.com",
              "role": "ADMIN",
            },)));

            break;
          case 'APPRENANT':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => APPRENANTDashboard(
                  user: {
                    "nomPrenom": user.nomPrenom,
                    "email": user.email,
                    "role": user.role.toString(),

                  },
                ),
              ),
            );
            break;

            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Rôle inconnu.')),
            );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Échec de la connexion ou rôle manquant.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    }
  }


}

