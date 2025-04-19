import 'package:flutter/material.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentScreen extends StatefulWidget {
  final QueryDocumentSnapshot movie;
  final int ticketCount;

  PaymentScreen({required this.movie, required this.ticketCount});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  PaymentMethod? _paymentMethod;

  void startPayment() {
    StripePayment.paymentRequestWithCardForm(
      CardFormPaymentRequest(),
    ).then((paymentMethod) async {
      setState(() {
        _paymentMethod = paymentMethod;
      });
      await processPayment(paymentMethod);
    }).catchError((e) {
      print("Payment error: $e");
    });
  }

  Future<void> processPayment(PaymentMethod paymentMethod) async {
    try {
      final paymentIntentData = await createPaymentIntent();
      final paymentIntentResult = await StripePayment.confirmPaymentIntent(
        PaymentIntent(
          clientSecret: paymentIntentData['clientSecret'],
          paymentMethodId: paymentMethod.id,
        ),
      );
      if (paymentIntentResult.status == 'succeeded') {
        bookTicket();
      }
    } catch (e) {
      print("Payment confirmation error: $e");
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent() async {
    return {
      'clientSecret': 'your-client-secret-from-backend',
    };
  }

  Future<void> bookTicket() async {
    try {
      await FirebaseFirestore.instance.collection('bookings').add({
        'movie_id': widget.movie.id,
        'user_id': FirebaseAuth.instance.currentUser?.uid,
        'ticket_count': widget.ticketCount,
        'booking_time': Timestamp.now(),
        'status': 'confirmed',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking Successful!')),
      );
      Navigator.pop(context);
    } catch (e) {
      print('Error booking ticket: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error booking ticket')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Payment")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Total: ${widget.ticketCount * 10} USD"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: startPayment,
              child: Text("Pay with Card"),
            ),
          ],
        ),
      ),
    );
  }
}
