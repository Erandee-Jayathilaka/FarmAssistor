import 'package:firebase/Features/User_auth/FirebaseAuthImplementation/FirebaseAuthServices.dart';
import 'package:firebase/Features/User_auth/presentations/Pages/loginPage.dart';
import 'package:firebase/Features/User_auth/presentations/Widgets/FromContainerWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class signUpPage extends StatefulWidget {
  const signUpPage({super.key});

  @override
  State<signUpPage> createState() => _signUpPageState();
}

class _signUpPageState extends State<signUpPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool isSigningUp = false;

  @override
  void dispose() {
    
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade900,
        title: Text("Sign Up",
        style: TextStyle(color: Colors.white,)
        ),
         automaticallyImplyLeading: false, // Removes the back button
      ),
    
    body: Center(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
                "Sign Up",
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                ),
          SizedBox(
                height: 30,
              ),
          
              FormContainerWidget(
                controller: _emailController,
                hintText: "Email",
                isPasswordField: false,
              ),
              SizedBox(
                height: 10,
              ),
              FormContainerWidget(
                controller: _passwordController,
                hintText: "Password",
                isPasswordField: true,
              ),
          SizedBox(
                height: 30,
              ),

          GestureDetector(
            onTap: _signUp,
            child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.green.shade900,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: isSigningUp? CircularProgressIndicator(color: Colors.white,): Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),
                    ),
                  ),
          ),
          ),
          SizedBox(
                height: 20,
              ),
        Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?"),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => loginPage()),
                            (route) => false,
                      );
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.green.shade900,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
        ],
      ),
    ),
    )
    );
  }


  void _signUp() async {

  setState(() {
  isSigningUp = true;
});

  
  String email = _emailController.text;
  String password = _passwordController.text;

  User? user = await _auth.signUpWithEmailAndPassword(email,password);

  setState(() {
  isSigningUp = false;
});

  if (user != null) {
      print( "User is successfully created");
      Navigator.pushNamed(context, "/home");
    } else {
      print("Some error happend");
    }

}


}


