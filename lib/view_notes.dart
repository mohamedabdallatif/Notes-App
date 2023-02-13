import 'package:flutter/material.dart';


class ViewNotes extends StatefulWidget {
  const ViewNotes({super.key,required this.list});
final list;
  @override
  State<ViewNotes> createState() => _ViewNotesState();
}

class _ViewNotesState extends State<ViewNotes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  Text('${widget.list['title']}')
      ),
      body: Container(
        child: Column(
          children: [
            Image.network('${widget.list['imageurl']}',
            width: double.infinity,
            height: 300,
            fit: BoxFit.fill,
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('${widget.list['title']}',
              style: const TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.blueAccent),
              ),
            ),
             Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('${widget.list['note']}',
              style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
              ),
            ),

          ],
        ),
      ),
    );
  }
}