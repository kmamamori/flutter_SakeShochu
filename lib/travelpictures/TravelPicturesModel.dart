import "../BaseModel.dart";

TravelPicturesModel travelPicturesModel = TravelPicturesModel();

/// Includes Data required for this extension.
/// Retrieved data will be return as String
class TravelPicture {
  int id;
  String name;
  String place;
  String diary;
  String date;

  String toString() {
    return "{ id=$id, name=$name, place=$place, diary=$diary, date=$date }";
  }
}

/// Model part of the project.
/// Loads & Sets data using BaseModel
class TravelPicturesModel extends BaseModel<TravelPicture> with DateSelection {
  void setDate(String date) {
    super.setChosenDate(date);
  }

  void triggerRebuild() {
    notifyListeners();
  }
}
