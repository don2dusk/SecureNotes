import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:secure_notes/db/database_provider.dart';
import 'package:secure_notes/model/note_model.dart';
import 'package:secure_notes/screens/add_note.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:secure_notes/widgets/note_card_widget.dart';
import 'package:sqflite/sqflite.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

String customGreeting() {
  var timeNow = DateTime.now().hour;
  if (timeNow > 5 && timeNow < 12) {
    return "Good morning";
  } else if ((timeNow >= 12) && (timeNow < 16)) {
    return "Good afternoon";
  } else {
    return "Good evening";
  }
}

class _HomeScreenState extends State<HomeScreen> {
  late List<NoteModel> notes;
  var notesel;
  bool isLoading = false;

  @override
  void initState() {
    refreshNotes();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);
    notes = await SecureNotesDB.instance.readAllNotes();
    setState(() => isLoading = false);
  }

  /*@override
  void dispose() {
    SecureNotesDB.instance.close();

    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    final userName = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: MediaQuery.of(context).size.height * 0.1,
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Hey $userName,\n" + customGreeting(),
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            //Expanded(child: searchField),
            SizedBox(
              height: 20,
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : notes.isEmpty
                  ? Center(
                      child: Text(
                        'You do not have any notes yet',
                      ),
                    )
                  : StaggeredGridView.countBuilder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      addAutomaticKeepAlives: true,
                      padding: EdgeInsets.fromLTRB(30, 8, 30, 8),
                      itemCount: notes.length,
                      staggeredTileBuilder: (index) => StaggeredTile.fit(2),
                      crossAxisCount: 4,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      itemBuilder: (context, index) {
                        final note = notes[index];
                        notesel = note;
                        return CupertinoContextMenu(
                          actions: [
                            CupertinoContextMenuAction(
                              child: Text('Share'),
                              trailingIcon: CupertinoIcons.share,
                            ),
                            CupertinoContextMenuAction(
                              isDestructiveAction: true,
                              child: Text('Delete'),
                              trailingIcon: CupertinoIcons.delete,
                              onPressed: deleteNote,
                            )
                          ],
                          child: GestureDetector(
                            onTap: () async {
                              await Navigator.of(context)
                                  .push(MaterialPageRoute(
                                builder: (context) => AddNote(
                                  snote: note,
                                ),
                              ));
                              initState();
                            },
                            child: NoteCardWidget(
                              note: note,
                              index: index,
                            ),
                          ),
                        );
                      },
                    ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddNote()),
            );
            initState();
          },
          child: Icon(Icons.note_add_outlined),
        ));
  }

  void deleteNote() async {
    await SecureNotesDB.instance.delete(notesel.id!);
    Navigator.pop(context);
    initState();
  }
}
