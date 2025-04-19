import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MovieItem extends StatelessWidget {
  final QueryDocumentSnapshot movie;
  final VoidCallback onTap;

  MovieItem({required this.movie, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        title: Text(
          movie['title'],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Genre: ${movie['genre']}'),
        leading: Image.network(movie['poster'], width: 50, height: 75),
        onTap: onTap,
      ),
    );
  }
}
