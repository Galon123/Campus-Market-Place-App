import 'package:e_commerce_refactor/theme/AppTheme.dart';
import 'package:e_commerce_refactor/theme/constants.dart';
import 'package:e_commerce_refactor/providers/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final _formkey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNoController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _isPassVisible = true;
  bool _isConfirmPassVisible = false;


  @override
  Widget build(BuildContext context) {
    
    Future<void> handleRegister() async{

      if(!_formkey.currentState!.validate()) return;

      setState(() => _isLoading=true);

      try{
        final userProvider = Provider.of<UserProvider>(context, listen: false);

        bool success = await userProvider.register(_usernameController.text.trim(), _emailController.text, _phoneNoController.text, _passwordController.text);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: success ? Text("Registered Successfully, Please Login....") : Text("Username or Email or Phone Number already registered")));
        Navigator.of(context).popUntil((route)=>route.isFirst);

      } catch(e) {
        debugPrint("Error in Registering : $e");
      } finally {
        setState(() => _isLoading = false);
      }
    }

    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 35),
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.account_circle, size: 80,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Create Account", style: text.titleLarge),
              ),
              Expanded(
                child: ListView(
                  children: [
                    Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.account_circle),
                              labelText: "Username",
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                              filled: true,
                              fillColor: colors.surface
                            ),
                            validator: (value)  {
                              if(value!.isEmpty) return "Required";
                              if(value.length < 3 || value.length > 20) return "Username has to be between 3 ans 20 characters";
                              return null;
                            },
                          ),
                          const SizedBox(height: 15,),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.mail),
                              labelText: "E-Mail",
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                              filled: true,
                              fillColor: colors.surface
                            ),
                            validator: (value)  {
                              if(value!.isEmpty) return "Required";
                              if(!value.toLowerCase().endsWith("@gectcr.ac.in")) return "Must be a College registered E-mail";
                              return null;
                            },
                          ),
                          const SizedBox(height: 15,),
                          TextFormField(
                            controller: _phoneNoController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.phone),
                              labelText: "Phone Number",
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                              filled: true,
                              fillColor: colors.surface
                            ),
                            validator: (value)  {
                              if(value!.isEmpty) return "Required";
                              if(value.length != 10) return "Invalid Phone Number";
                              return null;
                            },
                          ),
                          const SizedBox(height: 15,),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPassVisible,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              labelText: "Password",
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                              filled: true,
                              fillColor: colors.surface,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPassVisible ? Icons.visibility : Icons.visibility_off
                                ),
                                onPressed: () => setState(() => _isPassVisible = !_isPassVisible),
                              )
                            ),
                            validator: (value)  {
                              if(value!.isEmpty) return "Required";
                              if(!value.contains(RegExp(r'[A-Z]'))) return "Must have an UpperCase character";
                              if(!value.contains(RegExp(r'[a-z]'))) return "Must have a LowerCase character";
                              if(!value.contains(RegExp(r'[0-9]'))) return "Must have a Number";
                              return null;
                            },
                          ),
                          const SizedBox(height: 15,),
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: !_isConfirmPassVisible,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              labelText: "Confirm Password",
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                              filled: true,
                              fillColor: colors.surface,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isConfirmPassVisible ? Icons.visibility : Icons.visibility_off
                                ),
                                onPressed: () => setState(() => _isConfirmPassVisible = !_isConfirmPassVisible),
                              )
                            ),
                            validator: (value)  {
                              if(value!.isEmpty) return "Required";
                              if(value != _passwordController.text) return "Must be the same as Password";
                              return null;
                            },
                          ),
                          const SizedBox(height: 15,),
                          
                        ],
                      )
                    ),
                  ],
                )
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: colors.primary, elevation: 4),
                  onPressed: _isLoading ? null : handleRegister, 
                  child: _isLoading  
                  ? CircularProgressIndicator(color: Colors.white,)
                  : Text("Register", style: context.buttonText)
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already Have an Account ?", style: text.bodyMedium),
                  TextButton(
                    onPressed: () {Navigator.of(context).popUntil((route)=>route.isFirst);}, 
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.padded
                    ),
                    child: Text("Login", style: TextStyle(
                      color: Colors.blueAccent.shade400,
                      fontStyle: FontStyle.italic,
                      fontSize: AppTextSizes.smallText,
                      decoration: TextDecoration.underline
                    ),)
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}