import 'dart:io';
import 'package:flutter/material.dart';
import 'Pictures.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'TravelPicturesDBWorker.dart';
import 'TravelPicturesModel.dart'
    show TravelPicture, TravelPicturesModel, travelPicturesModel;
import '../utils.dart' as utils;

class TravelPicturesList extends StatelessWidget with Pictures {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<TravelPicturesModel>(
        model: travelPicturesModel,
        child: ScopedModelDescendant<TravelPicturesModel>(builder:
            (BuildContext context, Widget child, TravelPicturesModel model) {
          return Scaffold(
              floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add, color: Colors.white),
                  onPressed: () async {
                    File picturesFile = picturesTempFile();
                    if (picturesFile.existsSync()) {
                      picturesFile.deleteSync();
                    }
                    travelPicturesModel.entityBeingEdited = TravelPicture();
                    travelPicturesModel.setDate(null);
                    travelPicturesModel.setStackIndex(1);
                  }),
              body: GridView.builder(
                  itemCount: travelPicturesModel.entityList.length,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 20, //horizontal
                      mainAxisSpacing: 20, //vertical
                      crossAxisCount: 2),
                  padding: const EdgeInsets.all(20),
                  itemBuilder: (BuildContext context, int index) {
                    TravelPicture travelpicture =
                        travelPicturesModel.entityList[index];
                    File picturesFile =
                        File(picturesFileName(travelpicture.id));
                    bool picturesFileExists = picturesFile.existsSync();
                    return new GestureDetector(
                      child: new Card(
                          elevation: 5.0,
                          child: new Container(
                              alignment: Alignment.center,
                              child: new CircleAvatar(
                                  backgroundColor: Colors.indigoAccent,
                                  foregroundColor: Colors.white,
                                  radius: 80,
                                  backgroundImage: picturesFileExists
                                      ? FileImage(picturesFile)
                                      : null,
                                  child: picturesFileExists
                                      ? null
                                      : Text(travelpicture.name
                                          .substring(0, 1)
                                          .toUpperCase())))),
                      onTap: () async {
                        File picturesFile = picturesTempFile();
                        if (picturesFile.existsSync()) {
                          picturesFile.deleteSync();
                        }
                        travelPicturesModel.entityBeingEdited =
                            await TravelPicturesDBWorker.db
                                .get(travelpicture.id);
                        if (travelPicturesModel.entityBeingEdited.date ==
                            null) {
                          travelPicturesModel.setDate(null);
                        } else {
                          travelPicturesModel.setDate(utils.toFormattedDate(
                              travelPicturesModel.entityBeingEdited.date));
                        }
                        travelPicturesModel.setStackIndex(1);
                      },
                      // onLongPress: Shows 'delete' button to delete specified data
                      onLongPress: () {
                        showMenu(
                            context: context,
                            items: <PopupMenuEntry>[
                              PopupMenuItem(
                                  child: RaisedButton.icon(
                                      onPressed: () => _deleteTravelPicture(
                                          context, travelpicture),
                                      icon: Icon(Icons.delete),
                                      color: Colors.red,
                                      label: Text('Delete')))
                            ],
                            position: RelativeRect.fromLTRB(40, 25, -1, 25));
                      },
                    );
                  }));
        }));
  }

  /// Deletes travelpicture data when pressed.
  /// After deleted it, displays an message at the button
  Future _deleteTravelPicture(
      BuildContext context, TravelPicture travelpicture) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext alertContext) {
          return AlertDialog(
              title: Text('Delete Travel Memory'),
              content: Text('Really delete ${travelpicture.name}?'),
              actions: [
                FlatButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(alertContext).pop();
                  },
                ),
                FlatButton(
                  child: Text('Delete'),
                  onPressed: () async {
                    await TravelPicturesDBWorker.db.delete(travelpicture.id);
                    Navigator.of(alertContext).pop();
                    Scaffold.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 2),
                      content: Text('TravelPicture deleted'), //message
                    ));
                    travelPicturesModel.loadData(TravelPicturesDBWorker.db);
                  },
                )
              ]);
        });
  }
}
