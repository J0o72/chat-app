import 'package:chat_app/helper/show_snack_bar.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ResigterPage extends StatefulWidget {
  const ResigterPage({super.key});

  @override
  State<ResigterPage> createState() => _ResigterPageState();
}

class _ResigterPageState extends State<ResigterPage> {
  String? email, password;

  GlobalKey<FormState> formKey = GlobalKey();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: const Color(0xff2B475E),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                const SizedBox(
                  height: 80,
                ),
                SizedBox(
                  height: 100,
                  child: Image.asset("assets/images/scholar.png"),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Scholar Chat",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Pacifico"),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 100,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  onChanged: (data) {
                    email = data;
                  },
                  hintText: "Email",
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  obscureText: true,
                  onChanged: (data) {
                    password = data;
                  },
                  hintText: "Password",
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    // Resigter
                    if (formKey.currentState!.validate()) {
                      isLoading = true;
                      setState(() {});
                      try {
                        await registerUser();
                        Navigator.pushNamed(context, 'chatPage',
                            arguments: email);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'email-already-in-use') {
                          showSnackBar(context, "Your Email is already used");
                        }
                      } catch (e) {
                        print(e);
                      }
                      isLoading = false;
                      setState(() {});
                    } else {}
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: 50,
                    width: double.infinity,
                    child: const Center(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xff2B475E),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> registerUser() async {
    UserCredential user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!);
  }
}
