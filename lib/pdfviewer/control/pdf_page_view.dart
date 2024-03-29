import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdfreader2/controllers/reader_controller.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../pdf_viewer_library.dart';
import '../common/mobile_helper.dart'
    if (dart.library.html) 'package:syncfusion_flutter_pdfviewer/src/common/web_helper.dart'
    as helper;

import '../common/pdfviewer_helper.dart';
import 'pdf_scrollable.dart';
import 'pdfviewer_canvas.dart';
import 'single_page_view.dart';
import 'package:get/get.dart';
import 'package:pdfreader2/widgets/annotations/textbox.dart';

/// Wrapper class of [Image] widget which shows the PDF pages as an image
class PdfPageView extends StatefulWidget {
  /// Constructs PdfPageView instance with the given parameters.
  const PdfPageView(
    Key key,
    this.imageStream,
    this.viewportGlobalRect,
    this.parentViewport,
    this.interactionMode,
    this.width,
    this.height,
    this.pageSpacing,
    this.pdfDocument,
    this.pdfPages,
    this.pageIndex,
    this.pdfViewerController,
    this.maxZoomLevel,
    this.enableDocumentLinkAnnotation,
    this.enableTextSelection,
    this.onTextSelectionChanged,
    this.onHyperlinkClicked,
    this.onTextSelectionDragStarted,
    this.onTextSelectionDragEnded,
    this.currentSearchTextHighlightColor,
    this.otherSearchTextHighlightColor,
    this.textCollection,
    this.isMobileWebView,
    this.pdfTextSearchResult,
    this.pdfScrollableStateKey,
    this.singlePageViewStateKey,
    this.scrollDirection,
    this.onPdfPagePointerDown,
    this.onPdfPagePointerMove,
    this.onPdfPagePointerUp,
    this.semanticLabel,
    this.isSinglePageView,
    this.textDirection,
    this.canShowHyperlinkDialog,
    this.enableHyperlinkNavigation,
    this.isAndroidTV,
  ) : super(key: key);

  /// Image stream
  final Uint8List? imageStream;

  /// Width of page
  final double width;

  /// Height of page
  final double height;

  /// Space between pages
  final double pageSpacing;

  /// Instance of [PdfDocument]
  final PdfDocument? pdfDocument;

  /// Global rect of viewport region.
  final Rect? viewportGlobalRect;

  /// Viewport dimension.
  final Size parentViewport;

  /// If true, document link annotation is enabled.
  final bool enableDocumentLinkAnnotation;

  /// If true, hyperlink navigation is enabled.
  final bool enableHyperlinkNavigation;

  /// Indicates whether hyperlink dialog must be shown or not.
  final bool canShowHyperlinkDialog;

  /// Index of  page
  final int pageIndex;

  /// Information about PdfPage
  final Map<int, PdfPageInfo> pdfPages;

  /// Indicates interaction mode of pdfViewer.
  final PdfInteractionMode interactionMode;

  /// Instance of [PdfViewerController]
  final PdfViewerController pdfViewerController;

  /// Represents the maximum zoom level .
  final double maxZoomLevel;

  /// If false,text selection is disabled.Default value is true.
  final bool enableTextSelection;

  /// Triggers when text selection is changed.
  final PdfTextSelectionChangedCallback? onTextSelectionChanged;

  /// Triggers when Hyperlink is clicked.
  final PdfHyperlinkClickedCallback? onHyperlinkClicked;

  /// Triggers when text selection dragging started.
  final VoidCallback onTextSelectionDragStarted;

  /// Triggers when text selection dragging ended.
  final VoidCallback onTextSelectionDragEnded;

  /// Current instance search text highlight color.
  final Color currentSearchTextHighlightColor;

  ///Other instance search text highlight color.
  final Color otherSearchTextHighlightColor;

  /// Searched text details
  final List<MatchedItem>? textCollection;

  /// PdfTextSearchResult instance
  final PdfTextSearchResult pdfTextSearchResult;

  /// If true,MobileWebView is enabled.Default value is false.
  final bool isMobileWebView;

  /// Key to access scrollable.
  final GlobalKey<PdfScrollableState> pdfScrollableStateKey;

  /// Key to access single page view state.
  final GlobalKey<SinglePageViewState> singlePageViewStateKey;

  /// Represents the scroll direction of PdfViewer.
  final PdfScrollDirection scrollDirection;

  /// Triggers when pointer down event is called on pdf page.
  final PointerDownEventListener onPdfPagePointerDown;

  /// Triggers when pointer move event is called on pdf page.
  final PointerMoveEventListener onPdfPagePointerMove;

  /// Triggers when pointer up event is called on pdf page.
  final PointerUpEventListener onPdfPagePointerUp;

  /// A Semantic description of the page.
  final String? semanticLabel;

  /// Determines layout option in PdfViewer.
  final bool isSinglePageView;

  ///A direction of text flow.
  final TextDirection textDirection;

  /// Returns true when the SfPdfViewer is deployed in Android TV.
  final bool isAndroidTV;

  @override
  State<StatefulWidget> createState() {
    return PdfPageViewState();
  }
}

/// State for [PdfPageView]
class PdfPageViewState extends State<PdfPageView> {
  SfPdfViewerThemeData? _pdfViewerThemeData;
  final GlobalKey _canvasKey = GlobalKey();
  int _lastTap = DateTime.now().millisecondsSinceEpoch;
  int _consecutiveTaps = 1;
  final double _jumpOffset = 10.0;
  // reader controller for retrieving the state of the user's choice
  // of background colour
  ReaderController readCon = Get.find<ReaderController>();

  /// Mouse cursor for mouse region widget
  SystemMouseCursor _cursor = SystemMouseCursors.basic;

  /// focus node of pdf page view.
  FocusNode focusNode = FocusNode();

  /// CanvasRenderBox getter for accessing canvas properties.
  CanvasRenderBox? get canvasRenderBox =>
      _canvasKey.currentContext?.findRenderObject() != null
          ?
          // ignore: avoid_as
          (_canvasKey.currentContext?.findRenderObject())! as CanvasRenderBox
          : null;

  @override
  void initState() {
    _cursor = readCon.textBoxMode.value
        ? SystemMouseCursors.text
        : SystemMouseCursors.basic;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        RenderBox rb = context.findRenderObject() as RenderBox;
        readCon.maxX.value = rb.size.width;
        readCon.maxY.value = rb.size.height;
        readCon.pdfController.value.zoomLevel = fitToScreen(context);
      },
    );
    if (kIsDesktop && !widget.isMobileWebView) {
      helper.preventDefaultMenu();
      focusNode.addListener(
        () {
          helper.hasPrimaryFocus = focusNode.hasFocus;
        },
      );
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _pdfViewerThemeData = SfPdfViewerTheme.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
    _pdfViewerThemeData = null;
    super.dispose();
  }

  // function to expand the PDF file image to fill the PDF reader viewport
  double fitToScreen(BuildContext context) {
    double res = readCon.maxX.value == 0
        ? MediaQuery.of(context).size.width / 670
        : MediaQuery.of(context).size.width / readCon.maxX.value;
    return res;
  }

  // filters for the pdf document
  final ColorFilter kNormalFilter = const ColorFilter.matrix(<double>[
    1.0, 0.0, 0.0, 0.0, 0.0, //
    0.0, 1.0, 0.0, 0.0, 0.0, //
    0.0, 0.0, 1.0, 0.0, 0.0, //
    0.0, 0.0, 0.0, 1.0, 0.0, //
  ]);
  final ColorFilter kDarkFilter = const ColorFilter.matrix(<double>[
    -1.0, 0.0, 0.0, 0.0, 200.0, //
    0.0, -1.0, 0.0, 0.0, 200.0, //
    0.0, 0.0, -1.0, 0.0, 200.0, //
    0.0, 0.0, 0.0, 1.0, 0.0, //
  ]);
  final ColorFilter kSepiaFilter = const ColorFilter.matrix(<double>[
    0.474, 0.937, 0.228, 0.000, 0.000, //
    0.422, 0.834, 0.203, 0.000, 0.000, //
    0.328, 0.650, 0.158, 0.000, 0.000, //
    0.000, 0.000, 0.000, 1.000, 0.000, //
  ]);
  // Alternate sepia filter transformation matrix
  // final ColorFilter kSepiaFilter = const ColorFilter.matrix(<double>[
  //   0.393, 0.769, 0.189, 0.000, 0.000, //
  //   0.349, 0.686, 0.168, 0.000, 0.000, //
  //   0.272, 0.534, 0.131, 0.000, 0.000, //
  //   0.000, 0.000, 0.000, 1.000, 0.000, //
  // ]);

  @override
  Widget build(BuildContext context) {
    if (!kIsDesktop) {
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();
    }
    final double pageSpacing =
        widget.pageIndex == widget.pdfViewerController.pageCount - 1
            ? 0.0
            : widget.pageSpacing;
    final double heightSpacing =
        widget.scrollDirection == PdfScrollDirection.horizontal
            ? 0.0
            : pageSpacing;
    final double widthSpacing =
        widget.scrollDirection == PdfScrollDirection.horizontal &&
                !widget.isSinglePageView
            ? pageSpacing
            : 0.0;
    if (widget.imageStream != null) {
      final PdfPageRotateAngle rotatedAngle =
          widget.pdfDocument!.pages[widget.pageIndex].rotation;
      final Widget image = ColorFiltered(
        // add a colour filter to the PDF image, that can be changed by the user
        colorFilter: readCon.backgroundColour.value == "White"
            ? kNormalFilter
            : readCon.backgroundColour.value == "Dark"
                ? kDarkFilter
                : kSepiaFilter,
        child: Image.memory(
          widget.imageStream!,
          width: widget.width,
          height: widget.height,
          gaplessPlayback: true,
          fit: BoxFit.fitWidth,
          semanticLabel: widget.semanticLabel,
        ),
      );
      final Widget pdfPage = Container(
        height: widget.height + heightSpacing,
        width: widget.width + widthSpacing,
        color: Colors.white,
        alignment: Alignment.topCenter,
        child: widget.scrollDirection == PdfScrollDirection.vertical
            ? Column(children: <Widget>[
                image,
                Container(
                  height: pageSpacing,
                  color: _pdfViewerThemeData!.backgroundColor ??
                      (Theme.of(context).colorScheme.brightness ==
                              Brightness.light
                          ? const Color(0xFFD6D6D6)
                          : const Color(0xFF303030)),
                )
              ])
            : Row(
                children: <Widget>[
                  image,
                  Container(
                    width: widget.isSinglePageView ? 0.0 : pageSpacing,
                    color: _pdfViewerThemeData!.backgroundColor ??
                        (Theme.of(context).colorScheme.brightness ==
                                Brightness.light
                            ? const Color(0xFFD6D6D6)
                            : const Color(0xFF303030)),
                  )
                ],
              ),
      );
      int quarterTurns = 0;
      if (rotatedAngle == PdfPageRotateAngle.rotateAngle90) {
        quarterTurns = 1;
      } else if (rotatedAngle == PdfPageRotateAngle.rotateAngle180) {
        quarterTurns = 2;
      } else if (rotatedAngle == PdfPageRotateAngle.rotateAngle270) {
        quarterTurns = 3;
      }
      final bool isRotatedTo90or270 =
          rotatedAngle == PdfPageRotateAngle.rotateAngle90 ||
              rotatedAngle == PdfPageRotateAngle.rotateAngle270;
      final PdfViewerCanvas pdfViewerCanvas = PdfViewerCanvas(
        _canvasKey,
        isRotatedTo90or270 ? widget.width : widget.height,
        isRotatedTo90or270 ? widget.height : widget.width,
        widget.pdfDocument,
        widget.pageIndex,
        widget.pdfPages,
        widget.interactionMode,
        widget.pdfViewerController,
        widget.enableDocumentLinkAnnotation,
        widget.enableTextSelection,
        widget.onTextSelectionChanged,
        widget.onHyperlinkClicked,
        widget.onTextSelectionDragStarted,
        widget.onTextSelectionDragEnded,
        widget.textCollection,
        widget.currentSearchTextHighlightColor,
        widget.otherSearchTextHighlightColor,
        widget.pdfTextSearchResult,
        widget.isMobileWebView,
        widget.pdfScrollableStateKey,
        widget.singlePageViewStateKey,
        widget.viewportGlobalRect,
        widget.scrollDirection,
        widget.isSinglePageView,
        widget.textDirection,
        widget.canShowHyperlinkDialog,
        widget.enableHyperlinkNavigation,
      );
      final Widget canvasContainer = Container(
          height: isRotatedTo90or270 ? widget.width : widget.height,
          width: isRotatedTo90or270 ? widget.height : widget.width,
          alignment: Alignment.topCenter,
          child: pdfViewerCanvas);
      final Widget canvas = (kIsDesktop &&
              !widget.isMobileWebView &&
              canvasRenderBox != null)
          ? RotatedBox(
              quarterTurns: quarterTurns,
              child: Listener(
                onPointerSignal: (PointerSignalEvent details) {
                  if (widget.isSinglePageView &&
                      details is PointerScrollEvent) {
                    widget.singlePageViewStateKey.currentState?.jumpTo(
                      yOffset: widget.pdfViewerController.scrollOffset.dy +
                          (details.scrollDelta.dy.isNegative
                              ? -_jumpOffset
                              : _jumpOffset),
                    );
                  }
                  canvasRenderBox!.updateContextMenuPosition();
                },
                onPointerDown: (PointerDownEvent details) {
                  widget.onPdfPagePointerDown(details);
                  if (kIsDesktop && !widget.isMobileWebView) {
                    final int now = DateTime.now().millisecondsSinceEpoch;
                    if (now - _lastTap <= 500) {
                      _consecutiveTaps++;
                      if (_consecutiveTaps == 2 &&
                          details.buttons != kSecondaryButton) {
                        focusNode.requestFocus();
                        canvasRenderBox!.handleDoubleTapDown(details);
                      }
                      if (_consecutiveTaps == 3 &&
                          details.buttons != kSecondaryButton) {
                        focusNode.requestFocus();
                        canvasRenderBox!.handleTripleTapDown(details);
                      }
                    } else {
                      _consecutiveTaps = 1;
                    }
                    _lastTap = now;
                  }
                },
                onPointerMove: (PointerMoveEvent details) {
                  focusNode.requestFocus();
                  widget.onPdfPagePointerMove(details);
                  if (widget.interactionMode == PdfInteractionMode.pan) {
                    _cursor = readCon.textBoxMode.value
                        ? SystemMouseCursors.text
                        : SystemMouseCursors.basic;
                  }
                },
                onPointerUp: (PointerUpEvent details) {
                  widget.onPdfPagePointerUp(details);
                  if (widget.interactionMode == PdfInteractionMode.pan) {
                    _cursor = readCon.textBoxMode.value
                        ? SystemMouseCursors.text
                        : SystemMouseCursors.basic;
                  }
                },
                child: RawKeyboardListener(
                  focusNode: focusNode,
                  onKey: (RawKeyEvent event) {
                    final bool isPrimaryKeyPressed =
                        kIsMacOS ? event.isMetaPressed : event.isControlPressed;
                    if ((canvasRenderBox!
                                .getSelectionDetails()
                                .mouseSelectionEnabled ||
                            canvasRenderBox!
                                .getSelectionDetails()
                                .selectionEnabled) &&
                        isPrimaryKeyPressed &&
                        event.logicalKey == LogicalKeyboardKey.keyC) {
                      Clipboard.setData(
                        ClipboardData(
                            text: canvasRenderBox!
                                    .getSelectionDetails()
                                    .copiedText ??
                                ''),
                      );
                    }
                    if (isPrimaryKeyPressed &&
                        event.logicalKey == LogicalKeyboardKey.digit0) {
                      widget.pdfViewerController.zoomLevel =
                          fitToScreen(context);
                    }
                    if (isPrimaryKeyPressed &&
                        event.logicalKey == LogicalKeyboardKey.minus) {
                      if (event is RawKeyDownEvent) {
                        double zoomLevel = widget.pdfViewerController.zoomLevel;
                        zoomLevel = zoomLevel - 0.25;
                        widget.pdfViewerController.zoomLevel = zoomLevel;
                      }
                    }
                    if (isPrimaryKeyPressed &&
                        event.logicalKey == LogicalKeyboardKey.equal) {
                      if (event is RawKeyDownEvent) {
                        double zoomLevel = widget.pdfViewerController.zoomLevel;
                        zoomLevel = zoomLevel + 0.25;
                        widget.pdfViewerController.zoomLevel = zoomLevel;
                      }
                    }
                    if (event is RawKeyDownEvent) {
                      if (event.logicalKey == LogicalKeyboardKey.home ||
                          (kIsMacOS &&
                              event.logicalKey == LogicalKeyboardKey.fn &&
                              event.logicalKey ==
                                  LogicalKeyboardKey.arrowLeft)) {
                        widget.pdfViewerController.jumpToPage(1);
                      } else if (event.logicalKey == LogicalKeyboardKey.end ||
                          (kIsMacOS &&
                              event.logicalKey == LogicalKeyboardKey.fn &&
                              event.logicalKey ==
                                  LogicalKeyboardKey.arrowRight)) {
                        widget.pdfViewerController
                            .jumpToPage(widget.pdfViewerController.pageCount);
                      } else if (event.logicalKey ==
                          LogicalKeyboardKey.arrowRight) {
                        widget.pdfViewerController.nextPage();
                      } else if (event.logicalKey ==
                          LogicalKeyboardKey.arrowLeft) {
                        widget.pdfViewerController.previousPage();
                      }
                    }
                    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                      canvasRenderBox!.scroll(true, false);
                    }
                    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                      canvasRenderBox!.scroll(false, false);
                    }
                  },
                  child: MouseRegion(
                    cursor: _cursor,
                    onHover: (PointerHoverEvent details) {
                      setState(
                        () {
                          if (canvasRenderBox != null) {
                            if (widget.interactionMode ==
                                PdfInteractionMode.selection) {
                              final bool isText = canvasRenderBox!
                                      .findTextWhileHover(
                                          details.localPosition) !=
                                  null;
                              final bool isTOC = canvasRenderBox!
                                  .findTOC(details.localPosition);
                              if (isTOC) {
                                _cursor = SystemMouseCursors.click;
                              } else if (isText && !isTOC) {
                                if (isRotatedTo90or270) {
                                  _cursor = SystemMouseCursors.verticalText;
                                } else {
                                  _cursor = readCon.textBoxMode.value
                                      ? SystemMouseCursors.text
                                      : SystemMouseCursors.basic;
                                }
                              } else {
                                _cursor = readCon.textBoxMode.value
                                    ? SystemMouseCursors.text
                                    : SystemMouseCursors.basic;
                              }
                            } else {
                              final bool isTOC = canvasRenderBox!
                                  .findTOC(details.localPosition);
                              if (isTOC) {
                                _cursor = SystemMouseCursors.click;
                              } else if (_cursor != SystemMouseCursors.grab) {
                                _cursor = readCon.textBoxMode.value
                                    ? SystemMouseCursors.text
                                    : SystemMouseCursors.basic;
                              }
                            }
                          }
                        },
                      );
                    },
                    child: canvasContainer,
                  ),
                ),
              ),
            )
          : RotatedBox(
              quarterTurns: quarterTurns,
              child: Listener(
                onPointerDown: (PointerDownEvent details) {
                  widget.onPdfPagePointerDown(details);
                },
                onPointerMove: (PointerMoveEvent details) {
                  widget.onPdfPagePointerMove(details);
                },
                onPointerUp: (PointerUpEvent details) {
                  widget.onPdfPagePointerUp(details);
                },
                child: widget.isAndroidTV
                    ? RawKeyboardListener(
                        focusNode: focusNode,
                        onKey: (RawKeyEvent event) {
                          if (event.runtimeType.toString() ==
                              'RawKeyDownEvent') {
                            if (event.logicalKey ==
                                LogicalKeyboardKey.arrowRight) {
                              widget.pdfViewerController.nextPage();
                            } else if (event.logicalKey ==
                                LogicalKeyboardKey.arrowLeft) {
                              widget.pdfViewerController.previousPage();
                            }
                          }
                          if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                            canvasRenderBox!.scroll(true, false);
                          }
                          if (event.logicalKey ==
                              LogicalKeyboardKey.arrowDown) {
                            canvasRenderBox!.scroll(false, false);
                          }
                        },
                        child: canvasContainer,
                      )
                    : canvasContainer,
              ),
            );
      // stack for the pdf viewer screen
      return Stack(
        children: [
          pdfPage,
          // note: can add here but will reflect on everywhere
          GestureDetector(
            onTapDown: (details) {
              Offset lp = details.localPosition;
              if (readCon.textBoxMode.value) {
                // change textBoxMode to false to prevent the user from
                // needlessly spamming textboxes
                readCon.textBoxMode.value = false;
                // add annotation to the selected page
                readCon.children[widget.pageIndex].updateAnnotations(
                  TextboxWidget(
                    key: UniqueKey(),
                    x: lp.dx,
                    y: lp.dy,
                    page: widget.pageIndex,
                  ),
                );
              }
            },
            child: canvas,
          ),
        ],
      );
    } else {
      final BorderSide borderSide = BorderSide(
          width: widget.isSinglePageView ? pageSpacing / 2 : pageSpacing,
          color: _pdfViewerThemeData!.backgroundColor ??
              (Theme.of(context).colorScheme.brightness == Brightness.light
                  ? const Color(0xFFD6D6D6)
                  : const Color(0xFF303030)));
      final Widget child = Container(
        height: widget.height + heightSpacing,
        width: widget.width + widthSpacing,
        color: Colors.white,
        foregroundDecoration: BoxDecoration(
          border: widget.isSinglePageView
              ? Border(left: borderSide, right: borderSide)
              : widget.scrollDirection == PdfScrollDirection.horizontal
                  ? Border(right: borderSide)
                  : Border(bottom: borderSide),
        ),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
                _pdfViewerThemeData!.progressBarColor ??
                    (Theme.of(context).colorScheme.primary)),
            backgroundColor: _pdfViewerThemeData!.progressBarColor == null
                ? (Theme.of(context).colorScheme.primary.withOpacity(0.2))
                : _pdfViewerThemeData!.progressBarColor!.withOpacity(0.2),
          ),
        ),
      );
      return child;
    }
  }
}

/// Information about PdfPage is maintained.
class PdfPageInfo {
  /// Constructor of PdfPageInfo
  PdfPageInfo(this.pageOffset, this.pageSize);

  /// Page start offset
  final double pageOffset;

  /// Size of page in the viewport
  final Size pageSize;
}
