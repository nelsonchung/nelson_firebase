import 'package:flutter/material.dart';
//import 'login_google.dart'; // Import the LoginGooglePage

class LoginManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                /*
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginGooglePage()), // Navigate to LoginGooglePage when the button is pressed
                );
                */
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.grey, // Background color
                onPrimary: Colors.white, // Text color
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              child: Text('Google登入'),
            ),
            SizedBox(height: 20), // To provide some space between the buttons
            ElevatedButton(
              onPressed: () {
                // Implement other login logic here
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.grey, // Background color
                onPrimary: Colors.white, // Text color
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              child: Text('其他'),
            ),
          ],
        ),
      ),
    );
  }
}
