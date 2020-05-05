import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'Pictures.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'TravelPicturesDBWorker.dart';
import 'TravelPicturesModel.dart';
import '../utils.dart' as utils;

class TravelPicturesEntry extends StatelessWidget with Pictures {
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _placeEditingController = TextEditingController();
  final TextEditingController _diaryEditingController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TravelPicturesEntry() {
    _nameEditingController.addListener(() {
      travelPicturesModel.entityBeingEdited.name = _nameEditingController.text;
    });
    _placeEditingController.addListener(() {
      travelPicturesModel.entityBeingEdited.place =
          _placeEditingController.text;
    });
    _diaryEditingController.addListener(() {
      travelPicturesModel.entityBeingEdited.diary =
          _diaryEditingController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<TravelPicturesModel>(
      model: travelPicturesModel,
      child: ScopedModelDescendant<TravelPicturesModel>(builder:
          (BuildContext context, Widget child, TravelPicturesModel model) {
        // Correction:
        // add the following two lines for "editing" an existing note
        if (model.entityBeingEdited != null) {
          _nameEditingController.text = model.entityBeingEdited.name;
          _placeEditingController.text = model.entityBeingEdited.place;
          _diaryEditingController.text = model.entityBeingEdited.diary;
        }

        File picturesFile = picturesTempFile();
        if (!picturesFile.existsSync()) {
          if (model.entityBeingEdited != null &&
              model.entityBeingEdited.id != null) {
            picturesFile = File(picturesFileName(model.entityBeingEdited.id));
          }
        }

        return Scaffold(
            bottomNavigationBar: Padding(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                child: Row(children: [
                  FlatButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      File picturesFile = picturesTempFile();
                      if (picturesFile.existsSync()) {
                        picturesFile.deleteSync();
                      }
                      FocusScope.of(context).requestFocus(FocusNode());
                      model.setStackIndex(0);
                    },
                  ),
                  Spacer(),
                  FlatButton(
                    child: Text('Save'),
                    onPressed: () {
                      _save(context, model);
                    },
                  )
                ])),
            body: Form(
                key: _formKey,
                child: ListView(children: [
                  ListTile(
                      title: picturesFile.existsSync()
                          ?
                          //Image.file(picturesFile)
                          Image.memory(
                              Uint8List.fromList(
                                  picturesFile.readAsBytesSync()),
                              alignment: Alignment.center,
                              height: 200,
                              width: 200,
                              fit: BoxFit.contain,
                            )
                          : Text("No pictures image for this travelpicture"),
                      trailing: IconButton(
                          icon: Icon(Icons.edit),
                          color: Colors.blue,
                          onPressed: () => _selectTravelPicture(context))),
                  ListTile(
                      leading: Icon(Icons.person),
                      title: TextFormField(
                          decoration: InputDecoration(hintText: 'Name'),
                          controller: _nameEditingController,
                          validator: (String value) {
                            if (value.length == 0) {
                              return 'Please enter a name';
                            }
                            return null;
                          })),
                  ListTile(
                      leading: Icon(Icons.place),
                      title: TextFormField(
                        // keyboardType: TextInputType.place,
                        decoration: InputDecoration(hintText: "Place"),
                        controller: _placeEditingController,
                      )),
                  ListTile(
                    leading: Icon(Icons.today),
                    title: Text("Date"),
                    subtitle: Text(travelPicturesModel.chosenDate == null
                        ? ""
                        : travelPicturesModel.chosenDate),
                    trailing: IconButton(
                        icon: Icon(Icons.edit),
                        color: Colors.blue,
                        onPressed: () async {
                          String chosenDate = await utils.selectDate(
                              context,
                              travelPicturesModel,
                              travelPicturesModel.entityBeingEdited.date);
                          if (chosenDate != null) {
                            travelPicturesModel.entityBeingEdited.date =
                                chosenDate;
                          }
                        }),
                  ),
                  ListTile(
                      leading: Icon(Icons.content_paste),
                      title: TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 8,
                        decoration: InputDecoration(hintText: 'Diary'),
                        controller: _diaryEditingController,
                      ))
                ])));
      }),
    );
  }

  Future _selectTravelPicture(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            content: SingleChildScrollView(
                child: ListBody(
              children: <Widget>[
                GestureDetector(
                    child: Text("Take a picture"),
                    onTap: () async {
                      var cameraImage = await ImagePicker.pickImage(
                          source: ImageSource.camera);
                      if (cameraImage != null) {
                        cameraImage.copySync(picturesTempFileName());
                        travelPicturesModel.triggerRebuild();
                      }
                      Navigator.of(dialogContext).pop();
                    }),
                Divider(),
                GestureDetector(
                  child: Text("Select From Gallery"),
                  onTap: () async {
                    var galleryImage = await ImagePicker.pickImage(
                        source: ImageSource.gallery);
                    if (galleryImage != null) {
                      galleryImage.copySync(picturesTempFileName());
                      imageCache.clear();
                      travelPicturesModel.triggerRebuild();
                    }
                    Navigator.of(dialogContext).pop();
                  },
                ),
              ],
            )),
          );
        });
  }

  void _save(BuildContext context, TravelPicturesModel model) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    int id = 0;
    if (model.entityBeingEdited.id == null) {
      id = await TravelPicturesDBWorker.db
          .create(travelPicturesModel.entityBeingEdited);
    } else {
      id = await TravelPicturesDBWorker.db
          .update(travelPicturesModel.entityBeingEdited);
    }
    File picturesFile = picturesTempFile();
    if (picturesFile.existsSync()) {
      File f = picturesFile.renameSync(picturesFileName(id));

      // FIXME: force to reload the avartar in the TravelPicturesList
    }
    travelPicturesModel.loadData(TravelPicturesDBWorker.db);
    model.setStackIndex(0);
    Scaffold.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.green,
      duration: Duration(seconds: 2),
      content: Text('Travel memory saved'),
    ));
  }
}
