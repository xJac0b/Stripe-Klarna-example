import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:url_launcher/url_launcher_string.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Stripe.publishableKey =
      'pk_test_51RNB9KP6yyc4ZYhBv3QEUbSe1xuYWbwVsuVBN2gbDld1CJmwTm1PKAy1GDRjTY2fy1Kcj1asKEvxWQeUm0IWMGj000xscQK7Vs';
  await Stripe.instance.applySettings();
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
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ElevatedButton(
                onPressed: openStripeCheckout,
                child: Text('Open Stripe Checkout'),
              ),
              ElevatedButton(
                onPressed: () async => startKlarnaPayment(
                    amount: 10, currency: 'pln', email: 'maciek@o2.pl'),
                child: const Text('Start Klarna Payment'),
              ),
            ],
          ),
        ));
  }
}

Future<void> startKlarnaPayment({
  required int amount,
  required String currency,
  required String email,
}) async {
  final HttpsCallable callable =
      FirebaseFunctions.instance.httpsCallable('createKlarnaPaymentIntent');
  final response = await callable.call({
    'amount': amount,
    'currency': currency,
    'email': email,
  });

  final clientSecret = response.data['clientSecret'];

  await Stripe.instance.initPaymentSheet(
    paymentSheetParameters: SetupPaymentSheetParameters(
      paymentIntentClientSecret: clientSecret,
      merchantDisplayName: 'Twoja Firma',
      style: ThemeMode.system,
      customFlow: false,
    ),
  );

  await Stripe.instance.presentPaymentSheet();
}

void openStripeCheckout() async {
  const url = 'https://buy.stripe.com/test_7sY8wR7ISbYogDv9Zu9fW02';
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url, mode: LaunchMode.externalApplication);
  } else {
    throw 'Nie można otworzyć linku: $url';
  }
}
