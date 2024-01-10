import 'package:chatgpt/models/models_model.dart';
import 'package:chatgpt/services/api_services.dart';
import 'package:flutter/material.dart';

class ModelsProvider with ChangeNotifier{

  String currentModel = "text-search-babbage-doc-001";
  String get getcurrentModel{
    return currentModel;
  }
  void setCurrentModel (String newModel){
    currentModel = newModel;
    notifyListeners();
  }
    List<ModelsModel> modelsList = [];
  List<ModelsModel> get getModelslist{
    return modelsList;
  }

  Future<List<ModelsModel>> getAllModels () async{
    modelsList = await ApiService.getModels();
      return modelsList;


  }
}