import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../exceptions/auth_exception.dart';
import '../models/auth.dart';

enum AuthMode { signup, login }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  AuthMode _authMode = AuthMode.login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  AnimationController? _animationController;
  Animation<Size>? _heightAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _heightAnimation = Tween(
      begin: const Size(double.infinity, 310),
      end: const Size(double.infinity, 400),
    ).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Curves.linear,
      ),
    );

    _heightAnimation?.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    _animationController?.dispose();
  }

  bool _isLogin() => _authMode == AuthMode.login;

  bool _isSignup() => _authMode == AuthMode.signup;

  void _switchAuthMode() {
    setState(() {
      if (_isLogin()) {
        _authMode = AuthMode.signup;
        _animationController?.forward();
      } else {
        _authMode = AuthMode.login;
        _animationController?.reverse();
      }
    });
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Ocorreu um erro'),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    setState(() => _isLoading = true);

    _formKey.currentState?.save();
    Auth auth = Provider.of(context, listen: false);

    try {
      if (_isLogin()) {
        //LOGIN
        await auth.login(_authData['email']!, _authData['password']!);
      } else {
        //REGISTER
        await auth.signUp(_authData['email']!, _authData['password']!);
      }
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog('Ocorreu um erro inesperado!');
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      elevation: 8,
      margin: const EdgeInsets.only(top: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: AnimatedBuilder(
        animation: _heightAnimation!,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (email) => _authData['email'] = email ?? '',
                validator: (value) {
                  final email = value ?? '';

                  if (email.trim().isEmpty || !email.contains('@')) {
                    return 'Informe um e-mail inválido.';
                  }

                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Senha'),
                keyboardType: TextInputType.emailAddress,
                obscureText: true,
                controller: _passwordController,
                onSaved: (password) => _authData['password'] = password ?? '',
                validator: (value) {
                  final password = value ?? '';

                  if (password.isEmpty || password.length < 5) {
                    return 'Informe uma senha inválida';
                  }

                  return null;
                },
              ),
              if (_isSignup())
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Confirmar Senha'),
                  obscureText: true,
                  validator: _isLogin()
                      ? null
                      : (value) {
                          final password = value ?? '';

                          if (password != _passwordController.text) {
                            return 'Senhas informadas não conferem';
                          }

                          return null;
                        },
                ),
              const SizedBox(height: 20),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 8,
                    ),
                  ),
                  child: Text(
                    _authMode == AuthMode.login ? 'ENTRAR' : 'REGISTRAR',
                  ),
                ),
              const Spacer(),
              TextButton(
                onPressed: _switchAuthMode,
                child:
                    Text(_isLogin() ? 'DESEJA REGISTRAR?' : 'JÁ POSSUI CONTA?'),
              ),
            ],
          ),
        ),
        builder: (context, childForm) => Container(
          padding: const EdgeInsets.all(16),
          // height: _isLogin() ? 310 : 400,
          height: _heightAnimation?.value.height ?? (_isLogin() ? 310 : 400),
          width: deviceSize.width * 0.75,
          child: childForm,
        ),
      ),
    );
  }
}
