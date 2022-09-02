// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:secure_notes/db/database_provider.dart';
import 'package:secure_notes/model/note_model.dart';
import 'package:secure_notes/widgets/note_form_widget.dart';

class AddNote extends StatefulWidget {
  final int? noteId;
  final NoteModel? note;
  const AddNote({
    Key? key,
    this.noteId,
    this.note,
  }) : super(key: key);
  @override
  State<AddNote> createState() => _AddNoteState();
  /*static Route<dynamic> newnoteroute() {
    return CupertinoPageRoute(builder: (BuildContext context) {
      return AddNote(
        noteId: 1,
      );
    }); 
  } */
}

class _AddNoteState extends State<AddNote> {
  final _formKey = GlobalKey<FormState>();
  NoteModel? note;
  String? title;
  String? body;
  var dateTime = DateFormat.yMMMMEEEEd().add_jm().format(DateTime.now());
  bool isLoading = false;

  Future refreshNotes() async {
    setState(() => isLoading = true);
    if (widget.noteId != null) {
      note = await SecureNotesDB.instance.readNote(widget.noteId!);
    }
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();

    title = note?.title ?? '';
    if (widget.noteId == null) {
      body = '';
    } else {
      body = note?.body;
    }
    refreshNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: Text('Hi'),
            )
          : Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CupertinoButton(
                            alignment: Alignment.centerLeft,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.blue,
                            )),
                        Text('Notes',
                            style: TextStyle(fontSize: 18, color: Colors.blue)),
                        Expanded(
                          child: CupertinoButton(
                              alignment: Alignment.centerRight,
                              child: Icon(Icons.ios_share_outlined,
                                  color: Colors.blue),
                              onPressed: () {}),
                        ),
                        CupertinoButton(
                          child: Text('Done'),
                          onPressed: addorUpdateNote,
                        )
                      ],
                    ),
                    NoteFormWidget(
                        onChangedTitle: (title) =>
                            setState(() => this.title = title),
                        onChangedBody: (body) =>
                            setState(() => this.body = body)),
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
        title: title, body: body, creationDate: DateTime.now().toString());
    await SecureNotesDB.instance.update(note);
  }

  Future addNote() async {
    final note = NoteModel(
        title: title!, body: body!, creationDate: DateTime.now().toString());

    await SecureNotesDB.instance.create(note);
  }
}
