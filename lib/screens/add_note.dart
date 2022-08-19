// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:secure_notes/db/database_provider.dart';
import 'package:secure_notes/model/note_model.dart';

class AddNote extends StatefulWidget {
  final int noteId;
  final NoteModel? note;
  const AddNote({
    Key? key,
    required this.noteId,
    this.note,
  }) : super(key: key);
  @override
  State<AddNote> createState() => _AddNoteState();
  Route<dynamic> newnoteroute() {
    return CupertinoPageRoute(builder: (BuildContext context) {
      return AddNote(noteId: noteId);
    });
  }
}

class _AddNoteState extends State<AddNote> {
  final _formKey = GlobalKey<FormState>();
  late NoteModel note;
  late String title;
  late String body;
  late String lastEdited;
  var dateTime = DateFormat.yMMMMEEEEd().add_jm().format(DateTime.now());
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNotes();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);
    note = await SecureNotesDB.instance.readNote(widget.noteId);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 60, 20, 20),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
                child: Row(
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: CupertinoButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.blue,
                          )),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Notes',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: CupertinoButton(
                            onPressed: () {},
                            child: Icon(
                              Icons.ios_share_outlined,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: CupertinoButton(
                        onPressed: addorUpdateNote,
                        child: Text(
                          'Done',
                          style: TextStyle(fontSize: 18, color: Colors.blue),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 30),
              CupertinoTextField.borderless(
                controller: TextEditingController(text: note.title),
                onChanged: (value) {
                  TextEditingController().text += note.title;
                },
                autofocus: true,
                autocorrect: true,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                ),
                placeholder: 'Title',
                placeholderStyle: TextStyle(fontSize: 32, color: Colors.grey),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: Text(
                    dateTime,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: CupertinoTextField.borderless(
                  controller: TextEditingController(text: note.body),
                  onChanged: (value) {
                    TextEditingController().text += note.body;
                  },
                  scribbleEnabled: true,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                  placeholder: 'Enter text here',
                  placeholderStyle: TextStyle(color: Colors.grey, fontSize: 18),
                  maxLines: null,
                  autocorrect: true,
                  enableInteractiveSelection: true,
                  textInputAction: TextInputAction.done,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addorUpdateNote() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.noteId != null;

      if (isUpdating) {
        await updateNote();
      } else {
        await addNote();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateNote() async {
    final note = widget.note!.copy(
        title: title,
        body: body,
        creationDate:
            DateFormat.yMMMMEEEEd(DateTime.now()).add_jm().toString());

    await SecureNotesDB.instance.update(note);
  }

  Future addNote() async {
    final note = NoteModel(
        title: title,
        body: body,
        creationDate:
            DateFormat.yMMMMEEEEd(DateTime.now()).add_jm().toString());

    await SecureNotesDB.instance.create(note);
  }
}
