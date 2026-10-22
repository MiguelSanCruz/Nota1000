import 'package:flutter/material.dart';


class LoginPage extends StatefulWidget {
  
  @override
  // ignore: no_logic_in_create_state
  State<LoginPage> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child:SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              TextField(
                onChanged: (text) {
                  username = text;
                },
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 16.0),

              TextField(
                onChanged: (text) {
                  password = text;
                },
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 25.0),

              Row(
                children: [
                  Expanded(                  child: OutlinedButton(
                      onPressed: () {},
                      child: const Text('Cadastrar'),
                    ),
                  ),

                  const SizedBox(width: 20), 

                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if(username == 'miguel' && password == '123'){
                          Navigator.of(context).pushReplacementNamed('/home');
                        } 
                        else {
                        
                        }
                      },
                      child: const Text('Entrar'),
                    ),
                  )
                  ,
                ]
              )
            ],
          ),
        )
      )  
    ));
  }
}