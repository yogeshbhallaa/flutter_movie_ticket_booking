import 'package:flutter/material.dart';
import 'payment_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingScreen extends StatefulWidget {
  final QueryDocumentSnapshot movie;

  BookingScreen({required this.movie});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int ticketCount = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.movie['title'])),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(widget.movie['poster'], height: 250),
            SizedBox(height: 10),
            Text(
              'Genre: ${widget.movie['genre']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Description: ${widget.movie['description']}',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text('Tickets: ', style: TextStyle(fontSize: 18)),
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: ticketCount > 1
                      ? () {
                          setState(() {
                            ticketCount--;
                          });
                        }
                      : null,
                ),
                Text('$ticketCount', style: TextStyle(fontSize: 18)),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      ticketCount++;
                    });
                  },
                ),
              ],
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Proceed to payment screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PaymentScreen(
                        movie: widget.movie,
                        ticketCount: ticketCount,
                      ),
                    ),
                  );
                },
                child: Text('Proceed to Payment'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
