import 'package:flutter/material.dart';
import 'package:korpomap/services/auth_service.dart';
import 'package:korpomap/screens/auth/register_screen.dart';

/// Login screen with email and password fields
class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{
  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loading = false;

  /// Attempts to sign in and shows a SnackBar on error.
  Future<void> _handleLogin() async{
    setState(()=> _loading=true);

    try {
      await _authService.signIn(
          _emailController.text.trim(),
          _passwordController.text.trim(),
      );
    } catch (e) {
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error logging in: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading= false);
    }
  }// handleLogin

  /// Releases text controllers when the widget is removed from the tree.
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person, size: 80, color: Color(0xff8b5cf6)),
              const SizedBox(height: 8),
              const Text(
                'KorpoMap',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock_outlined),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                    onPressed: _loading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff8b5cf6),
                      foregroundColor: Colors.white,
                    ),
                  child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Log in'),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ),
                  );
                },
                child: const Text('Do not have account? Sign up'),
              ),
            ],
          ),
        ),
      ),
    );
  }//build




} //LoginScreen