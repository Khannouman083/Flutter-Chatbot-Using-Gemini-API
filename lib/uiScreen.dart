import 'dart:io';
import 'dart:typed_data';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';

class uiScreen extends StatefulWidget {
  const uiScreen({super.key});

  @override
  State<uiScreen> createState() => _uiScreenState();
}

class _uiScreenState extends State<uiScreen> {
  final Gemini gemini = Gemini.instance;
  List<ChatMessage> messages =[];
  final currentUser = ChatUser(id: "0", firstName: "User",);
  final GeminiUser = ChatUser(id: "1", firstName: "Gemini", profileImage: "assets/icon.png");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: const Text("Geminize"),
      ),
      body: DashChat(
          inputOptions: InputOptions(
            trailing: [
              IconButton(onPressed: (){
                _pickMediaMessage();
              }, icon: const Icon(Icons.image))
            ]
          ),
          currentUser: currentUser,
          onSend: _sendMessage,
          messages: messages),
    );

  }
  void _sendMessage (ChatMessage chatMessage){
    setState(() {
      messages = [chatMessage, ...messages];
      try{
        List<Uint8List> images =[];
        String question = chatMessage.text;
        if(chatMessage.medias?.isNotEmpty ?? false){
          images = [File(chatMessage.medias!.first.url).readAsBytesSync()];
        }
        gemini.streamGenerateContent(question, images: images).listen((event){
          ChatMessage? lastMessage = messages.firstOrNull;
          if(lastMessage!=null && lastMessage.user == GeminiUser){
            lastMessage = messages.removeAt(0);
            final response = event.content?.parts?.fold("", (previous, current)=> "$previous ${current.text}")??"";
            lastMessage.text += response;
            setState(() {
              messages = [lastMessage!, ...messages];
            });
          }
          else {
            String response = event.content?.parts?.fold("", (previous, current)=> "$previous ${current.text}")??"";
            ChatMessage message = ChatMessage(user: GeminiUser, createdAt: DateTime.now(), text: response);
            setState(() {
              messages = [message, ...messages];
            });
          }
        });
      }
      catch(e){
        print(e.toString());
      }
    });
  }
  void _pickMediaMessage () async{
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if(file!=null){
      ChatMessage chatMessage = ChatMessage(user: currentUser, createdAt: DateTime.now(), text: "Describe this picture",
          medias: [ChatMedia(url: file.path, fileName: "fileName", type: MediaType.image)]
      );
      _sendMessage(chatMessage);
    }
  }
}
