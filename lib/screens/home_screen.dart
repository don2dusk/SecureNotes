import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:secure_notes/db/database_provider.dart';
import 'package:secure_notes/model/note_model.dart';
import 'package:secure_notes/screens/add_note.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:secure_notes/widgets/note_card_widget.dart';

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
  late NoteModel snote;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNotes();
  }

  @override
  void dispose() {
    SecureNotesDB.instance.close();

    super.dispose();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);
    notes = await SecureNotesDB.instance.readAllNotes();
    //snote = await SecureNotesDB.instance.readNote();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final userName = ModalRoute.of(context)!.settings.arguments as String;
    final searchField = new TextFormField(
      style: TextStyle(
        fontSize: 14,
      ),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 20),
          hintText: "Search notes here",
          prefixIcon: Icon(
            Iconsax.search_normal_1,
            size: 20,
          ),
          hintStyle: TextStyle(
            fontSize: 12,
          ),
          border: InputBorder.none,
          filled: true,
          fillColor: Color.fromARGB(255, 238, 238, 238)),
    );
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          body: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 70, 20, 20),
          child: Column(
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Hey $userName,\n" + customGreeting(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
                child: searchField,
              ),
              TabBar(
                  unselectedLabelColor: Color.fromARGB(255, 41, 41, 41),
                  labelColor: Colors.blue,
                  tabs: [
                    Tab(text: 'All'),
                    Tab(
                      text: 'Folders',
                    )
                  ]),
              Expanded(
                  child: TabBarView(children: [
                Column(
                  children: [
                    isLoading
                        ? Center(child: CircularProgressIndicator())
                        : notes.isEmpty
                            ? Center(
                                child: Text(
                                  'You do not have any notes yet',
                                ),
                              )
                            : Expanded(
                                child: StaggeredGridView.countBuilder(
                                  padding: EdgeInsets.all(8),
                                  itemCount: notes.length,
                                  staggeredTileBuilder: (index) =>
                                      StaggeredTile.fit(2),
                                  crossAxisCount: 4,
                                  mainAxisSpacing: 4,
                                  crossAxisSpacing: 4,
                                  itemBuilder: (context, index) {
                                    final note = notes[index];
                                    return GestureDetector(
                                      onTap: () async {
                                        await Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => AddNote(
                                            noteId: notes[index].id,
                                            note: note,
                                          ),
                                        ));
                                        refreshNotes();
                                      },
                                      child: NoteCardWidget(
                                        note: note,
                                        index: index,
                                      ),
                                    );
                                  },
                                ),
                              ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: FloatingActionButton(
                          onPressed: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => AddNote()),
                            );
                          },
                          child: Icon(Icons.note_add_outlined),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: FloatingActionButton(
                            onPressed: () {},
                            child: Icon(Icons.create_new_folder_outlined)),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ])),
            ],
          ),
        ),
      )),
    );
  }
}
