import 'dart:convert';
import 'dart:developer';
import 'dart:io';
//import 'dart:js_interop';

import 'package:chatgpt/constants/api_consts.dart';
import 'package:chatgpt/models/chat_model.dart';
import 'package:chatgpt/models/models_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List<ModelsModel>> getModels() async {
    try {
      var response = await http.get(
        Uri.parse("$BASE_URL/models"),
        headers: {'Authorization': 'Bearer $API_KEY'},
      );
      Map jsonResponse = jsonDecode(response.body);
      if (jsonResponse['error'] != null) {
        //print("jsonResponse['error] ${jsonResponse['error']["message"]}");
        throw HttpException(jsonResponse['error']['message']);
      }
      //print("jsonResponse $jsonResponse");
      List temp = [];
      for (var value in jsonResponse["data"]) {
        temp.add(value);
       
      }
      return ModelsModel.modelsFromSnapshot(temp);
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }

//send message fct
  static Future<List<ChatModel>> sendMessage(
      {required String message, required String modelId}) async {
    try {
      //log(API_KEY);
      //
      //log(modelId);
      var response = await http.post(Uri.parse("$BASE_URL/chat/completions"),
          headers: {
            'Authorization': 'Bearer $API_KEY',
            "Content-Type": "application/json"
          },
          body: jsonEncode(
            {
              "model": modelId,
              "messages": [
                {"role": "user", "content": message}
              ], // Adjusted to match the expected format
              "max_tokens": 100,
            },
          ));

      
      //log(response.body);
      Map jsonResponse = jsonDecode(response.body);


      log(jsonEncode(jsonResponse));
      //log(jsonResponse.length.toString());
      
      // if (jsonResponse['error'] != null) {
      //   log("hata");
      //   log("jsonResponse['error] ${jsonResponse['error']["message"]}");
      //   throw HttpException(jsonResponse['error']["message"]);
      // }
      //log('jsonResponse choices text: ${jsonResponse['choices']}');
      log("elma");
      log('jsonResponse choices text: ${jsonEncode(jsonResponse['choices'][0]['message']['content'])}');
      log("elma");

      List<ChatModel> chatList = [];

        log("arm");
        chatList = List.generate(
          jsonResponse['choices'].length,
          (index) => ChatModel(
            
            msg: jsonResponse['choices'][index]['message']['content'],
            chatIndex: 1,
          ),
        );
      
      log("arm2");
      return chatList;
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }
}
