import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pdfreader2/controllers/reader_controller.dart';

// ignore: must_be_immutable
class TextboxWidget extends StatefulWidget {
  TextboxWidget({super.key, required this.x, required this.y});
  late double x;
  late double y;
  final ReaderController _readCon = Get.find<ReaderController>();

  @override
  State<TextboxWidget> createState() => _TextboxWidgetState();
}

class _TextboxWidgetState extends State<TextboxWidget> {
  // focus node for the formfield
  late FocusNode _focusNode;
  // text editing controller for the textbox
  late TextEditingController _textEditingController;

  // init the required variables
  @override
  void initState() {
    _focusNode = FocusNode();
    _textEditingController = TextEditingController();
    super.initState();
  }

  // dispose all the initialized form variables
  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
    _textEditingController.dispose();
  }

  // design for textbox goes here
  @override
  Widget build(BuildContext context) {
    // the textbox will be based on the TextFormField widget, wrapped around
    // transformer
    return Transform(
      transform: Matrix4.translationValues(widget.x, widget.y, 0.0),
      child: TextFormField(
        focusNode: _focusNode,
        controller: _textEditingController,
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            constraints: BoxConstraints(maxWidth: 100.0)),
        onTap: () {
          widget._readCon.updateSelectedTextbox(_focusNode);
          _focusNode.requestFocus();
        },
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}
