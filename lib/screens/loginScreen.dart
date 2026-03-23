import 'package:e_commerce_refactor/providers/UserProvider.dart';
import 'package:e_commerce_refactor/theme/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formkey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isPasswordVisible = true;

  Future<void> handleLogin() async{

    if(!_formkey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      bool success = await userProvider.login(_usernameController.text.trim(), _passwordController.text);

      if(!mounted) return;

      if(success){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Login Successfull...")
          )
        );
        await userProvider.refreshUsername();

      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Incorrect Password or Username")
          )
        );
      }
    } catch (e){
      debugPrint("Error : $e");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Connecetion Error.....Check your Internet")
          )
        );
    } finally{
      setState(() => _isLoading = false);
    }
  } 

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    
    return Scaffold(
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.0),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.school, color: colors.secondary, size: 90,),
                  const SizedBox(height: 20,),
                  Text("Campus MarketPlace", style: TextStyle(
                    color: colors.secondary,
                    fontSize: AppTextSizes.mainHeadings,
                    fontWeight: FontWeight.bold
                  ),),
                  const SizedBox(height: 30),

                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: "Username",
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
                      prefixIcon: Icon(Icons.person),
                      filled: true,
                      fillColor: colors.surface,
                    ),
                    validator: (value) => value!.isEmpty ? "Username cannot be empty" : null,
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
                      prefixIcon: Icon(Icons.lock),
                      filled: true,
                      fillColor: colors.surface,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off
                        ),
                        onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible)
                      ),
                    ),
                    validator: (value) => value!.length < 6 ? "Password too short" : null,
                  ),
                  const SizedBox(height: 50,),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary, 
                        padding: EdgeInsets.all(8.0),
                        elevation: 10
                      ),
                      onPressed: _isLoading ? null : handleLogin, 
                      child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white,)
                      : Text("Login", style: text.titleMedium)
                    ),
                  ),
                  const SizedBox(height: 5,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't Have an account? ", style: text.bodyMedium),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/register'), 
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.padded
                        ),
                        child: Text("Register", style: text.labelMedium)
                      )
                    ],
                  )

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

