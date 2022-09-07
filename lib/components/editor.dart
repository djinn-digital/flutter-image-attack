import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_painter/flutter_painter.dart';

import 'dart:ui' as ui;

import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:image_attack/components/color_picker.dart';

class ImageAttackEditor extends StatefulWidget {
  ui.Image initialImage;
  ImageAttackEditor({Key? key, required this.initialImage}) : super(key: key);

  @override
  _ImageAttackEditorState createState() => _ImageAttackEditorState();
}

class _ImageAttackEditorState extends State<ImageAttackEditor> {
  static const Color red = Color(0xFFFF0000);
  FocusNode textFocusNode = FocusNode();
  late PainterController controller;
  bool renderingImage = false;
  ui.Image? backgroundImage;

  Paint shapePaint = Paint()
    ..strokeWidth = 5
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  @override
  void initState() {
    super.initState();
    backgroundImage = widget.initialImage;
    controller = PainterController(
        background: widget.initialImage.backgroundDrawable,
        settings: PainterSettings(
            text: TextSettings(
              focusNode: textFocusNode,
              textStyle: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.red, fontSize: 18),
            ),
            freeStyle: const FreeStyleSettings(
              color: Colors.red,
              strokeWidth: 5,
            ),
            shape: ShapeSettings(
              paint: shapePaint,
            ),
            scale: const ScaleSettings(
              enabled: true,
              minScale: 1,
              maxScale: 5,
            )));
    // Listen to focus events of the text field
    textFocusNode.addListener(onFocus);
  }

  /// Updates UI when the focus changes
  void onFocus() {
    setState(() {});
  }

  Widget buildDefault(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size(double.infinity, kToolbarHeight),
          // Listen to the controller and update the UI when it updates.
          child: ValueListenableBuilder<PainterControllerValue>(
              valueListenable: controller,
              child: Container(),
              builder: (context, _, child) {
                return AppBar(
                  title: child,
                  actions: [
                    // Delete the selected drawable
                    IconButton(
                      icon: const Icon(
                        PhosphorIcons.trash,
                      ),
                      onPressed: controller.selectedObjectDrawable == null
                          ? null
                          : removeSelectedDrawable,
                    ),
                    // Redo action
                    IconButton(
                      icon: const Icon(
                        PhosphorIcons.arrow_clockwise,
                      ),
                      onPressed: controller.canRedo ? redo : null,
                    ),
                    // Undo action
                    IconButton(
                      icon: const Icon(
                        PhosphorIcons.arrow_counter_clockwise,
                      ),
                      onPressed: controller.canUndo ? undo : null,
                    ),
                    IconButton(
                      icon: const Icon(
                        PhosphorIcons.check,
                      ),
                      onPressed: () => {
                        if (textFocusNode.hasFocus)
                          {textFocusNode.unfocus()}
                        else
                          {renderAndDisplayImage()}
                      },
                    ),
                  ],
                );
              }),
        ),
        // Generate image
        // floatingActionButton: FloatingActionButton(
        //   child: const Icon(
        //     PhosphorIcons.image_fill,
        //   ),
        //   onPressed: renderAndDisplayImage,
        // ),
        body: Stack(
          children: [
            if (backgroundImage != null)
              // Enforces constraints
              Positioned.fill(
                child: Center(
                  child: AspectRatio(
                    aspectRatio:
                        backgroundImage!.width / backgroundImage!.height,
                    child: FlutterPainter(
                      controller: controller,
                    ),
                  ),
                ),
              ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: ValueListenableBuilder(
                valueListenable: controller,
                builder: (context, _, __) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Container(
                        constraints: const BoxConstraints(
                          maxWidth: 400,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: const BoxDecoration(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                          color: Colors.white,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (controller.freeStyleMode !=
                                FreeStyleMode.none) ...[
                              const Divider(),
                              const Text("Free Style Settings"),
                              // Control free style stroke width
                              Row(
                                children: [
                                  const Expanded(
                                      flex: 1, child: Text("Stroke Width")),
                                  Expanded(
                                    flex: 3,
                                    child: Slider.adaptive(
                                        min: 2,
                                        max: 25,
                                        value: controller.freeStyleStrokeWidth,
                                        onChanged: setFreeStyleStrokeWidth),
                                  ),
                                ],
                              ),
                              if (controller.freeStyleMode ==
                                  FreeStyleMode.draw)
                                Row(
                                  children: [
                                    const Expanded(
                                        flex: 1, child: Text("Color")),
                                    Expanded(
                                        flex: 3,
                                        child: ColorPicker(
                                          selectedColor:
                                              controller.freeStyleColor,
                                          selectColor: (Color color) =>
                                              {setFreeStyleColor(color)},
                                        ))
                                    // Control free style color hue
                                    // Expanded(
                                    //   flex: 3,
                                    //   child: Slider.adaptive(
                                    //       min: 0,
                                    //       max: 359.99,
                                    //       value: HSVColor.fromColor(
                                    //               controller.freeStyleColor)
                                    //           .hue,
                                    //       activeColor:
                                    //           controller.freeStyleColor,
                                    //       onChanged: setFreeStyleColor),
                                    // ),
                                  ],
                                ),
                            ],
                            if (textFocusNode.hasFocus) ...[
                              const Divider(),
                              const Text("Text settings"),
                              // Control text font size
                              Row(
                                children: [
                                  const Expanded(
                                      flex: 1, child: Text("Font Size")),
                                  Expanded(
                                    flex: 3,
                                    child: Slider.adaptive(
                                        min: 8,
                                        max: 96,
                                        value:
                                            controller.textStyle.fontSize ?? 14,
                                        onChanged: setTextFontSize),
                                  ),
                                ],
                              ),

                              // Control text color hue
                              Row(
                                children: [
                                  const Expanded(flex: 1, child: Text("Color")),

                                  Expanded(
                                      flex: 3,
                                      child: ColorPicker(
                                        selectedColor:
                                            controller.textStyle.color ??
                                                Colors.black,
                                        selectColor: (Color color) {
                                          setTextColor(color);
                                        },
                                      )),
                                  // Expanded(
                                  //   flex: 3,
                                  //   child: Slider.adaptive(
                                  //       min: 0,
                                  //       max: 359.99,
                                  //       value: HSVColor.fromColor(
                                  //               controller.textStyle.color ??
                                  //                   red)
                                  //           .hue,
                                  //       activeColor: controller.textStyle.color,
                                  //       onChanged: setTextColor),
                                  // ),
                                ],
                              ),
                            ],
                            if (controller.shapeFactory != null) ...[
                              const Divider(),
                              const Text("Shape Settings"),

                              // Control text color hue
                              Row(
                                children: [
                                  const Expanded(
                                      flex: 1, child: Text("Stroke Width")),
                                  Expanded(
                                    flex: 3,
                                    child: Slider.adaptive(
                                        min: 2,
                                        max: 25,
                                        value: controller
                                                .shapePaint?.strokeWidth ??
                                            shapePaint.strokeWidth,
                                        onChanged: (value) =>
                                            setShapeFactoryPaint(
                                                (controller.shapePaint ??
                                                        shapePaint)
                                                    .copyWith(
                                              strokeWidth: value,
                                            ))),
                                  ),
                                ],
                              ),

                              // Control shape color hue
                              Row(
                                children: [
                                  const Expanded(flex: 1, child: Text("Color")),
                                  Expanded(
                                      flex: 3,
                                      child: ColorPicker(
                                        selectedColor: (controller.shapePaint ??
                                                shapePaint)
                                            .color,
                                        selectColor: (Color color) {
                                          // setTextColor(color);
                                          setShapeFactoryPaint(
                                              (controller.shapePaint ??
                                                      shapePaint)
                                                  .copyWith(
                                            color: color,
                                          ));
                                        },
                                      )),
                                ],
                              ),

                              Row(
                                children: [
                                  const Expanded(
                                      flex: 1, child: Text("Fill shape")),
                                  Expanded(
                                    flex: 3,
                                    child: Center(
                                      child: Switch(
                                          value: (controller.shapePaint ??
                                                      shapePaint)
                                                  .style ==
                                              PaintingStyle.fill,
                                          onChanged: (value) =>
                                              setShapeFactoryPaint(
                                                  (controller.shapePaint ??
                                                          shapePaint)
                                                      .copyWith(
                                                style: value
                                                    ? PaintingStyle.fill
                                                    : PaintingStyle.stroke,
                                              ))),
                                    ),
                                  ),
                                ],
                              ),
                            ]
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: ValueListenableBuilder(
            valueListenable: controller,
            builder: (context, _, __) => InkWell(
                onTap: () {},
                child: Container(
                  color: Colors.black,
                  padding: EdgeInsets.only(bottom: 10, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: Icon(
                          PhosphorIcons.scribble_loop,
                          color: controller.freeStyleMode == FreeStyleMode.draw
                              ? Theme.of(context).accentColor
                              : Colors.white,
                        ),
                        onPressed: toggleFreeStyleDraw,
                      ),
                      IconButton(
                        icon: Icon(
                          PhosphorIcons.text_t,
                          color: textFocusNode.hasFocus
                              ? Theme.of(context).accentColor
                              : Colors.white,
                        ),
                        onPressed: addText,
                      ),
                      if (controller.shapeFactory == null)
                        PopupMenuButton<ShapeFactory?>(
                          tooltip: "Add shape",
                          itemBuilder: (context) => <ShapeFactory, String>{
                            LineFactory(): "Line",
                            ArrowFactory(): "Arrow",
                            DoubleArrowFactory(): "Double Arrow",
                            RectangleFactory(): "Rectangle",
                            OvalFactory(): "Oval",
                          }
                              .entries
                              .map((e) => PopupMenuItem(
                                  value: e.key,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        getShapeIcon(e.key),
                                        color: Colors.black,
                                      ),
                                      Text(" ${e.value}")
                                    ],
                                  )))
                              .toList(),
                          onSelected: selectShape,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              getShapeIcon(controller.shapeFactory),
                              color: controller.shapeFactory != null
                                  ? Theme.of(context).accentColor
                                  : Colors.white,
                            ),
                          ),
                        )
                      else
                        IconButton(
                          icon: Icon(
                            getShapeIcon(controller.shapeFactory),
                            color: Theme.of(context).accentColor,
                          ),
                          onPressed: () => {selectShape(null)},
                        ),
                      IconButton(
                        icon: Icon(
                          PhosphorIcons.eraser,
                          color: controller.freeStyleMode == FreeStyleMode.erase
                              ? Theme.of(context).accentColor
                              : Colors.white,
                        ),
                        onPressed: toggleFreeStyleErase,
                      ),
                    ],
                  ),
                ))));
  }

  @override
  Widget build(BuildContext context) {
    if (renderingImage)
      return Scaffold(
          body: Center(
              child: CircularProgressIndicator(
        strokeWidth: 2,
        color: Colors.black,
      )));
    return buildDefault(context);
  }

  static IconData getShapeIcon(ShapeFactory? shapeFactory) {
    if (shapeFactory is LineFactory) return PhosphorIcons.line_segment;
    if (shapeFactory is ArrowFactory) return PhosphorIcons.arrow_up_right;
    if (shapeFactory is DoubleArrowFactory) {
      return PhosphorIcons.arrows_horizontal;
    }
    if (shapeFactory is RectangleFactory) return PhosphorIcons.rectangle;
    if (shapeFactory is OvalFactory) return PhosphorIcons.circle;
    return PhosphorIcons.polygon;
  }

  void undo() {
    controller.undo();
  }

  void redo() {
    controller.redo();
  }

  void toggleFreeStyleDraw() {
    controller.freeStyleMode = FreeStyleMode.draw;
    controller.shapeFactory = null;
    textFocusNode.unfocus();
    onFocus();
  }

  void toggleFreeStyleErase() {
    controller.freeStyleMode = FreeStyleMode.erase;
    controller.shapeFactory = null;
    onFocus();
  }

  void addText() {
    controller.freeStyleMode = FreeStyleMode.none;
    controller.addText();
    controller.shapeFactory = null;
    setState(() {});
  }

  void setFreeStyleStrokeWidth(double value) {
    controller.freeStyleStrokeWidth = value;
  }

  void setFreeStyleColor(Color color) {
    controller.freeStyleColor = color;
  }

  void setTextFontSize(double size) {
    // Set state is just to update the current UI, the [FlutterPainter] UI updates without it
    setState(() {
      controller.textSettings = controller.textSettings.copyWith(
          textStyle:
              controller.textSettings.textStyle.copyWith(fontSize: size));
    });
  }

  void setShapeFactoryPaint(Paint paint) {
    // Set state is just to update the current UI, the [FlutterPainter] UI updates without it
    setState(() {
      controller.shapePaint = paint;
    });
  }

  void setTextColor(Color color) {
    controller.textStyle = controller.textStyle.copyWith(color: color);
  }

  void selectShape(ShapeFactory? factory) {
    controller.freeStyleMode = FreeStyleMode.none;
    controller.shapeFactory = factory;
  }

  void renderAndDisplayImage() async {
    if (backgroundImage == null) return;
    setState(() {
      renderingImage = true;
    });

    print(DateTime.now());
    print('done editing');
    final backgroundImageSize = Size(
        backgroundImage!.width.toDouble(), backgroundImage!.height.toDouble());

    ui.Image img = await controller.renderImage(backgroundImageSize);
    print(DateTime.now());
    print('done rendering');
    if (!mounted) return;
    Navigator.of(context).pop(img.pngBytes);
    setState(() {
      renderingImage = true;
    });
  }

  void removeSelectedDrawable() {
    final selectedDrawable = controller.selectedObjectDrawable;
    if (selectedDrawable != null) controller.removeDrawable(selectedDrawable);
  }

  void flipSelectedImageDrawable() {
    final imageDrawable = controller.selectedObjectDrawable;
    if (imageDrawable is! ImageDrawable) return;

    controller.replaceDrawable(
        imageDrawable, imageDrawable.copyWith(flipped: !imageDrawable.flipped));
  }
}

class RenderedImageDialog extends StatelessWidget {
  final Future<Uint8List?> imageFuture;

  const RenderedImageDialog({Key? key, required this.imageFuture})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Rendered Image"),
      content: FutureBuilder<Uint8List?>(
        future: imageFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const SizedBox(
              height: 50,
              child: Center(child: CircularProgressIndicator.adaptive()),
            );
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const SizedBox();
          }
          return InteractiveViewer(
              maxScale: 10, child: Image.memory(snapshot.data!));
        },
      ),
    );
  }
}
