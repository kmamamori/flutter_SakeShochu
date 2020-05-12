import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'TravelPicturesEntry.dart';
import 'TravelPicturesModel.dart' show TravelPicturesModel, travelPicturesModel;
import 'TravelPicturesDBWorker.dart';
import 'TravelPicturesList.dart';

/// Travel Picture initial point.
/// It declared at main.dart
class TravelPictures extends StatelessWidget {

  /// Load Travel Picture Data in DB
  TravelPictures() {
    travelPicturesModel.loadData(TravelPicturesDBWorker.db);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<TravelPicturesModel>(
        model: travelPicturesModel,
        child: ScopedModelDescendant<TravelPicturesModel>(builder:
            (BuildContext context, Widget child, TravelPicturesModel model) {
          return IndexedStack(
            index: model.stackIndex,
            children: <Widget>[ TravelPicturesEntry()],
          );
        }));
  }
}
