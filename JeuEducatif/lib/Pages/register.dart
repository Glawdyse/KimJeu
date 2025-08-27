import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../services/AuthentificationService.dart';
import 'login.dart';
import 'package:jeuEducatif/constants.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isObscure = true;
  String? selectedRole;

  final List<String> roles = ['APPRENANT', 'EDUCATEUR'];

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  void register() async {
    final authService = AuthService();

    final result = await authService.register(
      nameController.text,
      emailController.text,
      passwordController.text,
      selectedRole!,
    );

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Inscription réussie. Connectez-vous.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushNamed(context, 'login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Échec de l’inscription.'),
          backgroundColor: Colors.red,
        ),
      );
    }
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

  Widget _buildLargeScreen(Size size) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: RotatedBox(
            quarterTurns: 3,
            child: Lottie.asset(
              'assets/wave.json',
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

  Widget _buildSmallScreen(Size size) {
    return Center(
      child: _buildMainBody(size),
    );
  }

  Widget _buildMainBody(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
      size.width > 600 ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        if (size.width <= 600)
          Lottie.asset(
            'assets/coin.json',
            height: size.height * 0.2,
            width: size.width,
            fit: BoxFit.fill,
          ),
        SizedBox(height: size.height * 0.03),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text('Inscription', style: kLoginTitleStyle(size)),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text('Créez votre compte pour commencer', style: kLoginSubtitleStyle(size)),
        ),
        SizedBox(height: size.height * 0.03),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                ///ROLE
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person_outline),
                    hintText: 'Sélectionnez votre rôle',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  items: roles.map((role) {
                    return DropdownMenuItem(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedRole = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez sélectionner un rôle';
                    }
                    return null;
                  },
                ),
                SizedBox(height: size.height * 0.02),

                /// Username
                TextFormField(
                  style: kTextFormFieldStyle(),
                  controller: nameController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    hintText: 'nomPrenom',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre nom';
                    } else if (value.length < 4) {
                      return 'Minimum 4 caractères';
                    } else if (value.length > 80) {
                      return 'Maximum 80 caractères';
                    }
                    return null;
                  },
                ),
                SizedBox(height: size.height * 0.02),

                /// Email
                TextFormField(
                  style: kTextFormFieldStyle(),
                  controller: emailController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre email';
                    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Email invalide';
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
                    prefixIcon: const Icon(Icons.lock),
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
                    hintText: 'motdepasse',
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un mot de passe';
                    } else if (value.length < 8) {
                      return 'Minimum 8 caractères';
                    } else if (value.length > 80) {
                      return 'Maximum 80 caractères';
                    }
                    return null;
                  },
                ),
                SizedBox(height: size.height * 0.02),



                Text(
                  'En créant un compte, vous acceptez nos Conditions d’utilisation et notre Politique de confidentialité.',
                  style: kLoginTermsAndPrivacyStyle(size),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: size.height * 0.02),

                /// Register Button
                _registerButton(),

                SizedBox(height: size.height * 0.03),

                /// Navigate to Login
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (ctx) => const LoginPage()),
                    );
                    nameController.clear();
                    emailController.clear();
                    passwordController.clear();
                    selectedRole = null;
                    _formKey.currentState?.reset();
                    setState(() {
                      _isObscure = true;
                    });
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Déjà un compte ?',
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

  Widget _registerButton() {
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Inscription réussie en tant que $selectedRole')),
            );
            // TODO: Envoyer les données à l’API ou stocker localement
            register();
          }
        },
        child: const Text('S’inscrire'),
      ),
    );
  }
}
