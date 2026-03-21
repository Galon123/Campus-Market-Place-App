import 'package:e_commerce_refactor/constants.dart';
import 'package:flutter/material.dart';

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

  bool _isPassVisible = true;
  bool _isConfirmPassVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 35),
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.account_circle, size: 100,color: AppColors.textComplemtaryColor,),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text("Create Account", style: TextStyle(
                  fontSize: AppTextSizes.largeText,
                  fontWeight: FontWeight.w700
                ),),
              ),
              const SizedBox(height: 30,),
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
                              fillColor: AppColors.textColorDefault
                            ),
                            validator: (value)  {
                              value!.isEmpty ? "Required" : null;
                              value.length < 3 ? "Too Short" : null;
                            },
                          ),
                          const SizedBox(height: 30,),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.mail),
                              labelText: "E-Mail",
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                              filled: true,
                              fillColor: AppColors.textColorDefault
                            ),
                            validator: (value)  {
                              value!.isEmpty ? "Required" : null;
                              !value.toLowerCase().endsWith("@gectcr.ac.in") ? "Must be a Valid College E-mail" : null;
                            },
                          ),
                          const SizedBox(height: 30,),
                          TextFormField(
                            controller: _phoneNoController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.phone),
                              labelText: "Phone Number",
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                              filled: true,
                              fillColor: AppColors.textColorDefault
                            ),
                            validator: (value)  {
                              value!.isEmpty ? "Required" : null;
                              value.length != 10 ? "Invalid Phone number" : null;
                            },
                          ),
                          const SizedBox(height: 30,),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPassVisible,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              labelText: "Password",
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                              filled: true,
                              fillColor: AppColors.textColorDefault,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPassVisible ? Icons.visibility : Icons.visibility_off
                                ),
                                onPressed: () => setState(() => _isPassVisible = !_isPassVisible),
                              )
                            ),
                            validator: (value)  {
                              value!.isEmpty ? "Required" : null;
                              !value.contains(RegExp(r'[A-Z]')) ? "One UpperCase Character Required" : null;
                              !value.contains(RegExp(r'[a-z]')) ? "One LowerCase Character Required" : null;
                              !value.contains(RegExp(r'[0-9]')) ? "One Number Required" : null;
                            },
                          ),
                          const SizedBox(height: 30,),
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: !_isConfirmPassVisible,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              labelText: "Confirm Password",
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                              filled: true,
                              fillColor: AppColors.textColorDefault,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isConfirmPassVisible ? Icons.visibility : Icons.visibility_off
                                ),
                                onPressed: () => setState(() => _isConfirmPassVisible = !_isConfirmPassVisible),
                              )
                            ),
                            validator: (value)  {
                              value!.isEmpty ? "Required" : null;
                              value != _passwordController.text ? "Must Be Same as Password" : null;
                            },
                          ),
                          const SizedBox(height: 40,),
                          
                          SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor, elevation: 4),
                              onPressed: () => {}, 
                              child: Text("Register", style: TextStyle(
                                fontSize: AppTextSizes.subHeadings,
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                              ),)
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Already Have an Account ? ", style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: AppTextSizes.mediumText
                              ),),
                              TextButton(
                                onPressed: () {Navigator.of(context).popUntil((route)=>route.isFirst);}, 
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size(0, 0),
                                  tapTargetSize: MaterialTapTargetSize.padded
                                ),
                                child: Text("Login", style: TextStyle(
                                  color: Colors.blue,
                                  fontStyle: FontStyle.italic,
                                  decoration: TextDecoration.underline
                                ),)
                              )
                            ],
                          )

                        ],
                      )
                    )
                  ],
                )
              )
            ],
          ),
        ),
      ),
    );
  }

  // Future<void> _handleRegister(){

  // }


}