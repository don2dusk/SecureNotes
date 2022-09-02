import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:secure_notes/screens/add_note.dart';

class NoteFormWidget extends StatelessWidget {
  final String? title;
  final String? body;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedBody;
  final TextEditingController titleController;
  final TextEditingController bodyController;
  final String lastEdited;

  const NoteFormWidget(
      {Key? key,
      this.title = '',
      this.body = '',
      this.lastEdited = '',
      required this.onChangedTitle,
      required this.onChangedBody,
      required this.titleController,
      required this.bodyController})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTitle(),
              SizedBox(height: 8),
              buildDescription(),
              SizedBox(height: 16),
            ],
          ),
        ),
      );

  Widget buildTitle() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CupertinoTextField(
            controller: titleController,
            maxLines: 1,
            placeholder: 'Title',
            //initialValue: title,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
            decoration: BoxDecoration(),
            // validator: (title) =>
            //     title != null && title.isEmpty ? 'The title cannot be empty' : null,
            onChanged: onChangedTitle,
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
            child: Text(
              'Last Edited: ' + lastEdited,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      );
  Widget buildDescription() => CupertinoTextField(
        controller: bodyController,
        //initialValue: body,
        style: TextStyle(color: Colors.black, fontSize: 18),
        placeholder: 'Type something...',
        decoration: BoxDecoration(),
        // validator: (title) => title != null && title.isEmpty
        //     ? 'The body cannot be empty'
        //     : null,
        onChanged: onChangedBody,
        maxLines: null,
      );
}
