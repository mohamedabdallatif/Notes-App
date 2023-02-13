import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/edit_note.dart';
import 'package:firebase/view_notes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  getUser(){
    var user = FirebaseAuth.instance.currentUser;
    print(user?.email);
  }
  List notes=[
    {
      'note':'this is my first note',
      'image':'logo.png'
    }
  ];
  var fbm = FirebaseMessaging.instance;
 Future intialMessage()async{
     RemoteMessage? message= await FirebaseMessaging.instance.getInitialMessage();
     if(message!=null){
      Navigator.of(context).pushNamed('add_note');
     }
  }
  @override
  void initState() {
    intialMessage();   // notification in case app is terminited
    fbm.getToken().then((token){
      print(token);
      print('===========');
    });
    FirebaseMessaging.onMessage.listen((event){
    //  print('=====================');
    //  print('${event.notification?.body}');
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message){ //notification in case app is in back ground
      Navigator.of(context).pushNamed('add_note');
    });
    getUser();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    CollectionReference notesref = FirebaseFirestore.instance.collection('notes');
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
        Navigator.of(context).pushNamed('add_note');
      },
      ),
      appBar: AppBar(
        title: const Text('home page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
           onPressed: () async{ 
            await FirebaseAuth.instance.signOut();
            Navigator.of(context).pushReplacementNamed('sign_in');
            },
            )
        ],
      ),
      body: Container(
        child: FutureBuilder(
          future:notesref.where('userid',
          isEqualTo: FirebaseAuth.instance.currentUser?.uid
          ).get() ,
          builder:(context,snapshot){
            if(snapshot.hasData){
              return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context,i){
                  return Dismissible
                  (key: UniqueKey(),
                  onDismissed: (direction)async {
                   await notesref.doc(snapshot.data?.docs[i].id).delete();
                    //to delete image from firestorage
                   await FirebaseStorage.instance.refFromURL(snapshot.data?.docs[i]['imageurl']).delete();
                   
                  },
                  child: ListNotes(
                    notes: snapshot.data?.docs[i],
                    docid: snapshot.data?.docs[i].id,)
                    );
                });
            }
            return const Center(child: CircularProgressIndicator(),
            );
          } ,
        ),
      )
    );
  }
}
class ListNotes extends StatelessWidget {
      final notes;
      final docid;
   const ListNotes({super.key,required this.notes,required this.docid});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context,
         MaterialPageRoute(builder:(context){
          return ViewNotes(list: notes);
         } )
         );
      },
      child: Card(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child:Image.network('${notes['imageurl']}',
              fit: BoxFit.fill,
              height: 80,
              ),
               ),
                Expanded(
                flex: 3,
                child: ListTile(
                  title:  Text('${notes['title']}'),
                  subtitle: Text('${notes['note']}'),
                  trailing: IconButton(
                    icon:const Icon(Icons.edit) ,
                    onPressed: (){
                      Navigator.push(context,
                       MaterialPageRoute(builder: (context){
                        return EditNotes(docid: docid,list: notes,);
                       })
                       );
                    },
                  ),
                )
                )
          ],
        ),
      ),
    );
  }
}