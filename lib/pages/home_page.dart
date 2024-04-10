import 'package:flutter/material.dart';
import 'package:flutter_hive_database_demo/model/data_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

const String dataBoxName = "data";

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum DataFilter { ALL, COMPLETED, PROGRESS }

class _MyHomePageState extends State<MyHomePage> {
  late Box<DataModel> dataBox;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DataFilter filter = DataFilter.ALL;

  @override
  void initState() {
    super.initState();
    dataBox = Hive.box<DataModel>(dataBoxName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: Text(
          "Hive Todo",
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            color: Colors.white,
            iconColor: Colors.white,
            onSelected: (value) {
              if (value.compareTo("All") == 0) {
                setState(() {
                  filter = DataFilter.ALL;
                });
              } else if (value.compareTo("Completed") == 0) {
                setState(() {
                  filter = DataFilter.COMPLETED;
                });
              } else {
                setState(() {
                  filter = DataFilter.PROGRESS;
                });
              }
            },
            itemBuilder: (BuildContext context) {
              return ["All", "Completed", "Progress"].map((option) {
                return PopupMenuItem(
                  value: option,
                  child: Text(option),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          ValueListenableBuilder(
            valueListenable: dataBox.listenable(),
            builder: (context, Box<DataModel> items, _) {
              List<int> keys;

              if (filter == DataFilter.ALL) {
                keys = items.keys.cast<int>().toList();
              } else if (filter == DataFilter.COMPLETED) {
                keys = items.keys
                    .cast<int>()
                    .where((key) => items.get(key)!.complete)
                    .toList();
              } else {
                keys = items.keys
                    .cast<int>()
                    .where((key) => !items.get(key)!.complete)
                    .toList();
              }

              return keys.length > 0
                  ? ListView.separated(
                      padding: EdgeInsets.all(5),
                      separatorBuilder: (_, index) => Divider(),
                      itemCount: keys.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (_, index) {
                        final int key = keys[index];
                        final DataModel? data = items.get(key);
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: ListTile(
                            title: Text(
                              data!.title,
                              style:
                                  TextStyle(fontSize: 22, color: Colors.black),
                            ),
                            subtitle: Text(data.description,
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black38)),
                            //leading: Text("$key", style: TextStyle(fontSize: 18,color: Colors.black),),
                            trailing: Icon(
                              Icons.check,
                              color: data.complete ? Colors.green : Colors.red,
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  // Correct parameter here
                                  return Dialog(
                                    backgroundColor: Colors.white,
                                    child: Container(
                                      padding: EdgeInsets.all(16),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            "Mark as complete?",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  foregroundColor: Colors.white,
                                                  backgroundColor: Colors
                                                      .green, // foreground
                                                ),
                                                child: Text("Yes",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .white)), // Adjusted text color
                                                onPressed: () {
                                                  DataModel mData = DataModel(
                                                      title: data.title,
                                                      description:
                                                          data.description,
                                                      complete: true);
                                                  dataBox.put(key, mData);
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  foregroundColor: Colors.white,
                                                  backgroundColor:
                                                      Colors.red, // foreground
                                                ),
                                                child: Text("No",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .white)), // Adjusted text color
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        );
                      },
                    )
                  : Expanded(
                      child: Center(
                        child: Text(
                          "No Data Available",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    );
            },
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                backgroundColor: Colors.white,
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(hintText: "Title"),
                        controller: titleController,
                        textCapitalization: TextCapitalization.words,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextField(
                        decoration: InputDecoration(hintText: "Description"),
                        controller: descriptionController,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, // Text color
                          backgroundColor: Colors.black, // Button color
                        ),
                        child: Text("Add Data",
                            style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          final String title = titleController.text;
                          final String description = descriptionController.text;
                          // Clearing the TextFields
                          titleController.clear();
                          descriptionController.clear();
                          // Creating a new DataModel instance
                          DataModel data = DataModel(
                              title: title,
                              description: description,
                              complete: false);
                          // Assuming `dataBox` is your database or data storage instance
                          dataBox.add(data);
                          // Close the dialog
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
