import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pdfreader2/controllers/reader_controller.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'hiveModels/textbox.g.dart';

@HiveType(typeId: 1)
// ignore: must_be_immutable
class TextboxWidget extends StatefulWidget {
  TextboxWidget(
      {super.key,
      required this.x,
      required this.y,
      required this.page,
      this.currString = ""});
  // current coordinates of the widget relative to the canvas
  @HiveField(0)
  double x;
  @HiveField(1)
  double y;
  // page that the textbox is on
  @HiveField(2)
  int page;
  // cursor for the textbox
  final SystemMouseCursor _cursor = SystemMouseCursors.move;
  // max width the textbox can expand to
  RxDouble maxWidth = 100.0.obs;
  // font size of the widget
  late RxDouble currentFontSize = 12.0.obs;
  // text editing controller for the textbox
  final TextEditingController _textEditingController = TextEditingController();
  @HiveField(3)
  // save the text before disposal
  String currString;

  @override
  State<TextboxWidget> createState() => _TextboxWidgetState();
}

class _TextboxWidgetState extends State<TextboxWidget> {
  // reader controller
  ReaderController readCon = Get.find<ReaderController>();

  // function to reduce the font size
  void _decreaseFontSize() {
    widget.currentFontSize.value -= 0.5;
  }

  // function to reduce the font size
  void _increaseFontSize() {
    widget.currentFontSize.value += 0.5;
  }

  // sets the initial coordinates and handle invalid coordinates if needed
  void _handleInvalidCoordinates(bool isInitState) {
    setState(
      () {
        if (isInitState) {
          widget._textEditingController.text = widget.currString;
        }
        RenderBox rb = context.findRenderObject() as RenderBox;
        // get the max local coordinates from readCon
        double maxX = readCon.maxX.value;
        double maxY = readCon.maxY.value;
        // get the width and height of the textbox
        double textboxWidth = rb.size.width;
        double textboxHeight = rb.size.height;
        // widget.maxWidth = ((readCon.maxX.value - widget.x) * 0.75).obs;
        // gc0: leakout of left side of page
        if (widget.x < 0) {
          // set x coordinates to be equals to 0
          widget.x = 0;
          // set y
          widget.y = widget.y < 0
              // set to 0 if leak out over to prev page
              ? 0
              // set to max y coords if leak out to next page
              : widget.y + textboxHeight > maxY
                  ? maxY - textboxHeight
                  // else, set normally
                  : widget.y;
          // terminate
          return;
        }
        // gc1: leak out of right side of page
        if (widget.x + textboxWidth > maxX) {
          // set x coordinates to maxX - length of widget
          widget.x = maxX - textboxWidth;
          // set y
          widget.y = widget.y < 0
              // set to 0 if leak out over to prev page
              ? 0
              // set to max y coords if leak out to next page
              : widget.y + textboxHeight > maxY
                  ? maxY - textboxHeight
                  // else, set normally
                  : widget.y;
          // terminate
          return;
        }
        // gc2: just leak out of top of page
        if (widget.y < 0) {
          // keep initial x coordinates => do nth
          // set the y coordinates to 0
          widget.y = 0;
          // terminate
          return;
        }
        // gc3: just leak out of bottom of page
        if (widget.y + textboxHeight > maxY) {
          // keep initial x coordinates => do nth
          // set the y coordinates to maxY - height of textbox
          widget.y = maxY - textboxHeight;
          // terminate
          return;
        }
        // gc4: the textbox becomes too big for the page(i.e. 75% )
        if ((textboxWidth > maxX * 0.75) || (textboxHeight > maxY * 0.75)) {
          // adjust font size
          widget.currentFontSize.value -= 0.5;
        }
        // else, x and y coordinates are valid => no action required
      },
    );
  }

  // changes the position of the textbox
  void _updatePosition(DraggableDetails details) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        setState(
          () {
            RenderBox rb = context.findRenderObject() as RenderBox;
            // get the max local coordinates from readCon
            double maxX = readCon.maxX.value;
            double maxY = readCon.maxY.value;
            // get the width and height of the textbox
            double textboxWidth = rb.size.width;
            double textboxHeight = rb.size.height;
            // get the top left local coordinates of the widget
            Offset translatedOffset = rb.globalToLocal(details.offset);
            // gc0: the widget goes out the page to the left
            if (translatedOffset.dx < 0) {
              // set the x coord to be 0
              widget.x = 0;
              // if leak out of the page, bring it back into the page
              widget.y = translatedOffset.dy < 0
                  ? 0
                  : translatedOffset.dy + textboxHeight > maxY
                      ? maxY - textboxHeight
                      : translatedOffset.dy;
              return;
            }

            // gc1: the widget goes out of the page to the right
            if (translatedOffset.dx + textboxWidth > maxX) {
              // set the x coord to be the max x coords
              widget.x = maxX - textboxWidth;
              // if leak out of the page, bring it back into the page
              widget.y = translatedOffset.dy < 0
                  ? 0
                  : translatedOffset.dy + textboxHeight > maxY
                      ? maxY - textboxHeight
                      : translatedOffset.dy;
              return;
            }

            // gc2: widget goes into previous page
            if (translatedOffset.dy < 0) {
              // case where page is 0 or is less than halfway across the page
              if (widget.page == 0) {
                // set the x to the new x
                widget.x = translatedOffset.dx;
                // set the new y to 0
                widget.y = 0;
                // terminate
                return;
              }
              // delete the widget from the annotations list
              readCon.annotationsList[widget.page].remove(widget);
              // adjust the page number of the widget
              widget.page--;
              // set the x
              widget.x = translatedOffset.dx;
              // set the y to the max possible y
              widget.y = maxY - textboxHeight;
              // place the widget in the annotations list of the previous page
              readCon.annotationsList[widget.page].add(widget);
              // terminate
              return;
            }

            // gc3: widget goes into next page
            if (translatedOffset.dy + textboxHeight > maxY) {
              // case where page is the last page or is less than halfway across
              // the page
              if (widget.page == readCon.children.length - 1) {
                // set the x to be the new x
                widget.x = translatedOffset.dx;
                // set the y to be the max possible y
                widget.y = maxY - textboxHeight;
                // terminate
                return;
              }
              // delete the widget from the annotations list
              readCon.annotationsList[widget.page].remove(widget);
              // update the page number to the next page
              widget.page++;
              // set the x
              widget.x = translatedOffset.dx;
              // set the y to 0
              widget.y = 0;
              // add the textbox to the next page
              readCon.annotationsList[widget.page].add(widget);
              // terminate
              return;
            }
            // if ok, set the coordinates normally
            widget.x = translatedOffset.dx;
            widget.y = translatedOffset.dy;
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // handle invalid coordinates and update x/y if out of bounds
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _handleInvalidCoordinates(true);
      },
    );
  }

  // design for textbox goes here
  @override
  Widget build(BuildContext context) {
    // handle invalid coordinates and update x/y if out of bounds
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _handleInvalidCoordinates(false);
      },
    );
    Material child = Material(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IntrinsicWidth(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: widget.maxWidth.value,
              ),
              child: Obx(
                () => TextField(
                  mouseCursor: widget._cursor,
                  controller: widget._textEditingController,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: null,
                  onChanged: (v) {
                    widget.maxWidth.value = readCon.maxX.value - widget.x;
                    setState(
                      () {
                        widget.currString = widget._textEditingController.text;
                      },
                    );
                  },
                  decoration: InputDecoration(
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.zero),
                      borderSide: BorderSide(
                        color: Colors.blueAccent,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.zero),
                      borderSide: BorderSide(
                        color: readCon.currentColor.value,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    fontSize: widget.currentFontSize.value,
                    color: readCon.currentColor.value,
                  ),
                ),
              ),
            ),
          ),
          Obx(
            () => Wrap(
              direction: Axis.horizontal,
              children: [
                IconButton(
                  onPressed: () {
                    readCon.annotationsList[widget.page].remove(widget);
                  },
                  color: readCon.currentColor.value,
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    Icons.delete,
                    size: 15.0,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _decreaseFontSize();
                  },
                  color: readCon.currentColor.value,
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    Icons.font_download,
                    size: 10.0,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _increaseFontSize();
                  },
                  color: readCon.currentColor.value,
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    Icons.font_download,
                    size: 15.0,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
    // the textbox will be based on the TextFormField widget, wrapped around
    // transformer
    return Transform(
      transform: Matrix4.translationValues(widget.x, widget.y, 0.0),
      child: Draggable(
        maxSimultaneousDrags: 1,
        feedback: child,
        childWhenDragging: child,
        onDragEnd: _updatePosition,
        child: child,
      ),
    );
  }
}
