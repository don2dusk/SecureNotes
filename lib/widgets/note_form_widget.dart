import 'package:flutter/material.dart';
import 'package:secure_notes/screens/add_note.dart';

class NoteFormWidget extends StatelessWidget {
  final String? title;
  final String? body;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedBody;

  const NoteFormWidget({
    Key? key,
    this.title = '',
    this.body = '',
    required this.onChangedTitle,
    required this.onChangedBody,
  }) : super(key: key);

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

  Widget buildTitle() => TextFormField(
        maxLines: 1,
        initialValue: title,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        decoration:
            InputDecoration(border: InputBorder.none, hintText: 'Title'),
        validator: (title) =>
            title != null && title.isEmpty ? 'The title cannot be empty' : null,
        onChanged: onChangedTitle,
      );

  Widget buildDescription() => SingleChildScrollView(
        child: TextFormField(
          initialValue: body,
          style: TextStyle(color: Colors.black, fontSize: 18),
          decoration: InputDecoration(
              border: InputBorder.none, hintText: 'Type something...'),
          validator: (title) => title != null && title.isEmpty
              ? 'The description cannot be empty'
              : null,
          onChanged: onChangedBody,
          maxLines: 25,
        ),
      );
}
