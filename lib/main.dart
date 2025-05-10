import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Flutter Demo Home Page'),
          ),
          body: const Center(
            child: ElevatedButton(
              onPressed: openStripeCheckout,
              child: Text('Open Stripe Checkout'),
            ),
          ),
        ));
  }
}

void openStripeCheckout() async {
  const url = 'https://buy.stripe.com/test_7sY8wR7ISbYogDv9Zu9fW02';
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url, mode: LaunchMode.externalApplication);
  } else {
    throw 'Nie można otworzyć linku: $url';
  }
}
