

import 'dart:developer';

import 'package:chatgpt/constants/constants.dart';
import 'package:chatgpt/models/chat_model.dart';
import 'package:chatgpt/services/api_services.dart';
import 'package:chatgpt/services/assets_manager.dart';
import 'package:chatgpt/services/services.dart';
import 'package:chatgpt/widgets/chat_widget.dart';
import 'package:chatgpt/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../providers/models_provider.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = false;
  late TextEditingController textEditingController;

  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
  }
List<ChatModel> chatList = [];
  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.openaiLogo),
        ),
        title: const Text("chatGPt"),
        actions: [
          IconButton(
            onPressed: () async {
              await Services.showModalSheet(context: context);
            },
            icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                  itemCount: chatList.length,
                  itemBuilder: (context, index) {
                    return ChatWidget(
                      msg: chatList[index].msg.toString(),
                      chatIndex: 
                          chatList[index].chatIndex,);
                          
                  }),
            ),
            if (_isTyping) ...[
              const SpinKitThreeBounce(
                color: Colors.white,
                size: 18,
              ),
              ],
             const SizedBox(
                height: 15,
              ),
              Material(
                color: cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: const TextStyle(color: Colors.white),
                          controller: textEditingController,
                          onSubmitted: (value)  async{
                            await sendMessageFCT(
                              modelsProvider: modelsProvider,
                            );
                          },
                          decoration: const InputDecoration.collapsed(
                              hintText: "How Can I Help You",
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                      ),
                      IconButton(
                          onPressed: () async{await sendMessageFCT(modelsProvider: modelsProvider);},
                          icon: const Icon(
                            Icons.send,
                            color: Colors.white,
                          ))
                    ],
                  ),
                ),
              ),
             
        ],
        ),
      ),
    );
  }
  Future<void> sendMessageFCT ({required ModelsProvider modelsProvider}) async {
                            try {
                              log("request has been sent");
                               chatList = await ApiService.sendMessage(
                                message: textEditingController.text,
                                modelId: modelsProvider.getcurrentModel,
                              );
                              setState(() {
                                
                              });
                            } catch (error) {
                              log("error $error");
                            }
                            finally{
                              setState(() {
                                _isTyping = true;
                              });
                            }
                          }
}
