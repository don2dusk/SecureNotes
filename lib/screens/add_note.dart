// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:secure_notes/db/database_provider.dart';
import 'package:secure_notes/model/note_model.dart';
import 'package:secure_notes/widgets/note_form_widget.dart';

class AddNote extends StatefulWidget {
  final NoteModel? snote;
  const AddNote({
    Key? key,
    //this.noteId,
    this.snote,
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
  var note;
  String? title;
  String? body;
  late TextEditingController ntitle;
  late TextEditingController nbody;

  var dateTime = DateFormat.yMMMMEEEEd().add_Hm().format(DateTime.now());
  bool isLoading = false;

  Future refreshNotes() async {
    setState(() => isLoading = true);
    if (widget.snote != null) {
      note = await SecureNotesDB.instance.readAllNotes();
    }
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();

    if (widget.snote == null) {
      title = '';
      body = '';
    } else {
      body = widget.snote!.body;
      title = widget.snote!.title;
    }
    ntitle = TextEditingController(text: title);
    nbody = TextEditingController(text: body);
    refreshNotes();
  }

  @override
  void dispose() {
    ntitle.dispose();
    nbody.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
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
                        child:
                            Icon(Icons.ios_share_outlined, color: Colors.blue),
                        onPressed: () {}),
                  ),
                  CupertinoButton(
                      child: Text('Done'), onPressed: addorUpdateNote)
                ],
              ),
              NoteFormWidget(
                onChangedTitle: (title) => setState(() => this.title = title),
                onChangedBody: (body) => setState(() => this.body = body),
                titleController: ntitle,
                bodyController: nbody,
                lastEdited: widget.snote == null
                    ? 'Just Now'
                    : widget.snote!.creationDate,
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
      final isUpdating = widget.snote != null;

      if (isUpdating) {
        await updateNote();
      } else {
        await addNote();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateNote() async {
    final note =
        widget.snote!.copy(title: title, body: body, creationDate: dateTime);
    await SecureNotesDB.instance.update(note);
  }

  Future addNote() async {
    final snote = NoteModel(title: title!, body: body!, creationDate: dateTime);

    await SecureNotesDB.instance.create(snote);
  }
}
