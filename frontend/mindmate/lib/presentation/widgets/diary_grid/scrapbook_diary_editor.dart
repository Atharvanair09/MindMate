import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/diary_page_data.dart';
import 'models/diary_image_block.dart';

class ScrapbookDiaryEditor extends StatefulWidget {
  final DiaryPageData pageData;
  final ValueChanged<DiaryPageData> onPageChanged;
  final bool isLayoutMode;
  final ValueChanged<bool> onLayoutModeChanged;
  final String? selectedImageId;
  final ValueChanged<String?> onImageSelected;
  final int gridColumns;
  final int gridRows;

  const ScrapbookDiaryEditor({
    super.key,
    required this.pageData,
    required this.onPageChanged,
    required this.isLayoutMode,
    required this.onLayoutModeChanged,
    required this.selectedImageId,
    required this.onImageSelected,
    this.gridColumns = 12,
    this.gridRows = 16,
  });

  @override
  State<ScrapbookDiaryEditor> createState() => _ScrapbookDiaryEditorState();
}

class _ScrapbookDiaryEditorState extends State<ScrapbookDiaryEditor> {
  late TextEditingController _textController;
  final FocusNode _textFocusNode = FocusNode();

  // Drag state
  String? _draggingImageId;
  int? _dragStartX;
  int? _dragStartY;
  int? _initialBlockX;
  int? _initialBlockY;

  // Resize state
  String? _resizingImageId;
  int? _initialBlockWidth;
  int? _initialBlockHeight;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.pageData.text);
    _textFocusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(ScrapbookDiaryEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pageData.text != oldWidget.pageData.text &&
        widget.pageData.text != _textController.text) {
      _textController.text = widget.pageData.text;
    }
  }

  void _onFocusChange() {
    if (_textFocusNode.hasFocus && widget.isLayoutMode) {
      widget.onLayoutModeChanged(false);
      widget.onImageSelected(null);
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _textFocusNode.removeListener(_onFocusChange);
    _textFocusNode.dispose();
    super.dispose();
  }

  void _notifyChanged() {
    widget.pageData.text = _textController.text;
    widget.onPageChanged(widget.pageData);
  }

  void _handleImagePanStart(DragStartDetails details, DiaryImageBlock image, double cellWidth, double cellHeight) {
    setState(() {
      _draggingImageId = image.id;
      _initialBlockX = image.x;
      _initialBlockY = image.y;
      _dragStartX = (details.globalPosition.dx / cellWidth).floor();
      _dragStartY = (details.globalPosition.dy / cellHeight).floor();
    });
    widget.onImageSelected(image.id);
    if (!widget.isLayoutMode) {
      widget.onLayoutModeChanged(true);
    }
    _textFocusNode.unfocus();
  }

  void _handleImagePanUpdate(DragUpdateDetails details, double cellWidth, double cellHeight) {
    if (_draggingImageId == null || _dragStartX == null || _dragStartY == null) return;

    int currentGridX = (details.globalPosition.dx / cellWidth).floor();
    int currentGridY = (details.globalPosition.dy / cellHeight).floor();

    int deltaX = currentGridX - _dragStartX!;
    int deltaY = currentGridY - _dragStartY!;

    final image = widget.pageData.images.firstWhere((img) => img.id == _draggingImageId);

    int newX = (_initialBlockX! + deltaX).clamp(0, widget.gridColumns - image.width);
    int newY = (_initialBlockY! + deltaY).clamp(0, widget.gridRows - image.height);

    if (image.x != newX || image.y != newY) {
      setState(() {
        image.x = newX;
        image.y = newY;
      });
      _notifyChanged();
    }
  }

  void _handleImagePanEnd(DragEndDetails details) {
    setState(() {
      _draggingImageId = null;
      _dragStartX = null;
      _dragStartY = null;
      _initialBlockX = null;
      _initialBlockY = null;
    });
  }

  void _handleResizePanStart(DragStartDetails details, DiaryImageBlock image, double cellWidth, double cellHeight) {
    setState(() {
      _resizingImageId = image.id;
      _initialBlockWidth = image.width;
      _initialBlockHeight = image.height;
      _dragStartX = (details.globalPosition.dx / cellWidth).floor();
      _dragStartY = (details.globalPosition.dy / cellHeight).floor();
    });
    widget.onImageSelected(image.id);
    _textFocusNode.unfocus();
  }

  void _handleResizePanUpdate(DragUpdateDetails details, double cellWidth, double cellHeight) {
    if (_resizingImageId == null || _dragStartX == null || _dragStartY == null) return;

    int currentGridX = (details.globalPosition.dx / cellWidth).floor();
    int currentGridY = (details.globalPosition.dy / cellHeight).floor();

    int deltaX = currentGridX - _dragStartX!;
    int deltaY = currentGridY - _dragStartY!;

    final image = widget.pageData.images.firstWhere((img) => img.id == _resizingImageId);

    int newWidth = (_initialBlockWidth! + deltaX).clamp(2, widget.gridColumns - image.x);
    int newHeight = (_initialBlockHeight! + deltaY).clamp(2, widget.gridRows - image.y);

    if (image.width != newWidth || image.height != newHeight) {
      setState(() {
        image.width = newWidth;
        image.height = newHeight;
      });
      _notifyChanged();
    }
  }

  void _handleResizePanEnd(DragEndDetails details) {
    setState(() {
      _resizingImageId = null;
      _initialBlockWidth = null;
      _initialBlockHeight = null;
      _dragStartX = null;
      _dragStartY = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.isLayoutMode) {
          widget.onLayoutModeChanged(false);
          widget.onImageSelected(null);
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double cellWidth = constraints.maxWidth / widget.gridColumns;
          final double cellHeight = constraints.maxHeight / widget.gridRows;

          // For the notebook lines
          final double fontSize = widget.pageData.fontSize;
          final double textHeight = 1.8;
          final double lineHeight = fontSize * textHeight;

          // Calculate constraints for TextField to avoid overlapping images
          int currentMaxY = 0;
          int currentMaxX = 0;
          int currentMinRight = widget.gridColumns;

          bool changed = true;
          while (changed) {
            changed = false;
            for (var img in widget.pageData.images) {
              if (img.y <= currentMaxY) {
                // If image is wide or in the middle, it pushes the text down
                bool isWide = img.width > widget.gridColumns / 2;
                bool isMiddle = img.x > 0 && (img.x + img.width) < widget.gridColumns;
                
                if (isWide || isMiddle) {
                  int bottomY = img.y + img.height;
                  if (bottomY > currentMaxY) {
                    currentMaxY = bottomY;
                    changed = true;
                  }
                }
              }
            }
          }

          // Calculate left/right constraints from images intersecting the start Y
          for (var img in widget.pageData.images) {
            if (img.y <= currentMaxY && img.y + img.height > currentMaxY) {
               if (img.x == 0) {
                 if (img.width > currentMaxX) {
                   currentMaxX = img.width;
                 }
               } else if (img.x + img.width == widget.gridColumns) {
                 if (img.x < currentMinRight) {
                   currentMinRight = img.x;
                 }
               }
            }
          }

          // If left and right constraints overlap or touch, space is blocked horizontally
          if (currentMaxX >= currentMinRight) {
             int newMaxY = currentMaxY;
             for (var img in widget.pageData.images) {
               if (img.y <= currentMaxY && img.y + img.height > currentMaxY) {
                 if (img.y + img.height > newMaxY) {
                   newMaxY = img.y + img.height;
                 }
               }
             }
             currentMaxY = newMaxY;
             currentMaxX = 0;
             currentMinRight = widget.gridColumns;
          }

          // Calculate bottom constraint to stop text when it hits an image below it
          int currentMinBottomY = widget.gridRows;
          for (var img in widget.pageData.images) {
            if (img.y >= currentMaxY) {
              int textStartX = currentMaxX;
              int textEndX = currentMinRight;
              int imgStartX = img.x;
              int imgEndX = img.x + img.width;

              if (textStartX < imgEndX && imgStartX < textEndX) {
                 if (img.y < currentMinBottomY) {
                    currentMinBottomY = img.y;
                 }
              }
            }
          }

          double textTopOffset = 0.0;
          double textLeftOffset = 0.0;
          double textRightOffset = 0.0;
          double textBottomOffset = 0.0;

          if (currentMaxY > 0) {
            double maxBottomPixel = currentMaxY * cellHeight;
            int linesToSkip = (maxBottomPixel / lineHeight).ceil();
            textTopOffset = linesToSkip * lineHeight;
            if (textTopOffset > constraints.maxHeight) {
              textTopOffset = constraints.maxHeight;
            }
          }
          if (currentMaxX > 0) {
            textLeftOffset = currentMaxX * cellWidth;
          }
          if (currentMinRight < widget.gridColumns) {
            textRightOffset = (widget.gridColumns - currentMinRight) * cellWidth;
          }
          if (currentMinBottomY < widget.gridRows) {
            double minBottomPixel = currentMinBottomY * cellHeight;
            double availableHeight = minBottomPixel - textTopOffset;
            if (availableHeight > 0) {
                int maxLines = (availableHeight / lineHeight).floor();
                double snappedHeight = maxLines * lineHeight;
                textBottomOffset = constraints.maxHeight - (textTopOffset + snappedHeight);
            } else {
                textBottomOffset = constraints.maxHeight - textTopOffset;
            }
          }

          return Container(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                // Layer 1: Notebook lines
                Positioned.fill(
                  child: AnimatedOpacity(
                    opacity: widget.isLayoutMode ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 300),
                    child: CustomPaint(
                      painter: _NotebookLinesPainter(
                        lineHeight: lineHeight,
                        lineColor: const Color(0xFFE5E0FF),
                      ),
                    ),
                  ),
                ),

                // Layer 2: Text Field
                Positioned(
                  top: textTopOffset,
                  left: textLeftOffset,
                  right: textRightOffset,
                  bottom: textBottomOffset,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      controller: _textController,
                      focusNode: _textFocusNode,
                      maxLines: null,
                      expands: true,
                      style: GoogleFonts.getFont(
                        widget.pageData.fontFamily,
                        fontSize: fontSize,
                        color: const Color(0xFF1E1E1E),
                        height: textHeight,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Dear diary...",
                        hintStyle: GoogleFonts.getFont(
                          widget.pageData.fontFamily,
                          color: Colors.grey.shade400,
                          fontSize: fontSize,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                      ),
                      onChanged: (text) {
                        _notifyChanged();
                      },
                    ),
                  ),
                ),

                // Layer 3: Grid Overlay (Fades in during layout mode)
                IgnorePointer(
                  child: AnimatedOpacity(
                    opacity: widget.isLayoutMode ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: CustomPaint(
                      size: Size(constraints.maxWidth, constraints.maxHeight),
                      painter: _GridPainter(
                        gridColumns: widget.gridColumns,
                        gridRows: widget.gridRows,
                        cellWidth: cellWidth,
                        cellHeight: cellHeight,
                      ),
                    ),
                  ),
                ),

                // Layer 4: Floating Images
                for (var image in widget.pageData.images)
                  Positioned(
                    left: image.x * cellWidth,
                    top: image.y * cellHeight,
                    width: image.width * cellWidth,
                    height: image.height * cellHeight,
                    child: _buildImageBlock(image, cellWidth, cellHeight),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageBlock(DiaryImageBlock image, double cellWidth, double cellHeight) {
    bool isSelected = widget.selectedImageId == image.id && widget.isLayoutMode;

    return GestureDetector(
      onTap: () {
        widget.onImageSelected(image.id);
        if (!widget.isLayoutMode) {
          widget.onLayoutModeChanged(true);
        }
      },
      onPanStart: widget.isLayoutMode ? (details) => _handleImagePanStart(details, image, cellWidth, cellHeight) : null,
      onPanUpdate: widget.isLayoutMode ? (details) => _handleImagePanUpdate(details, cellWidth, cellHeight) : null,
      onPanEnd: widget.isLayoutMode ? _handleImagePanEnd : null,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: isSelected
                  ? Border.all(color: const Color(0xFF4B39EF), width: 3)
                  : Border.all(color: Colors.transparent, width: 3),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    spreadRadius: 2,
                  )
                else if (widget.isLayoutMode)
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.file(
                File(image.imagePath),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: Icon(Icons.broken_image, color: Colors.grey, size: 40),
                  ),
                ),
              ),
            ),
          ),
          if (isSelected)
            Positioned(
              right: -10,
              bottom: -10,
              child: GestureDetector(
                onPanStart: (details) => _handleResizePanStart(details, image, cellWidth, cellHeight),
                onPanUpdate: (details) => _handleResizePanUpdate(details, cellWidth, cellHeight),
                onPanEnd: _handleResizePanEnd,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Color(0xFF4B39EF),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 4),
                    ],
                  ),
                  child: const Icon(
                    Icons.open_in_full,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
          if (isSelected)
             Positioned(
              left: -10,
              top: -10,
              child: GestureDetector(
                onTap: () {
                   setState(() {
                     widget.pageData.images.removeWhere((img) => img.id == image.id);
                   });
                   widget.onImageSelected(null);
                   _notifyChanged();
                },
                child: Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 4),
                    ],
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _NotebookLinesPainter extends CustomPainter {
  final double lineHeight;
  final Color lineColor;

  _NotebookLinesPainter({required this.lineHeight, required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 1.0;

    for (double i = lineHeight; i < size.height; i += lineHeight) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _NotebookLinesPainter oldDelegate) {
    return oldDelegate.lineHeight != lineHeight || oldDelegate.lineColor != lineColor;
  }
}

class _GridPainter extends CustomPainter {
  final int gridColumns;
  final int gridRows;
  final double cellWidth;
  final double cellHeight;

  _GridPainter({
    required this.gridColumns,
    required this.gridRows,
    required this.cellWidth,
    required this.cellHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF4B39EF).withOpacity(0.15)
      ..strokeWidth = 1.0;

    for (int i = 1; i < gridColumns; i++) {
      canvas.drawLine(Offset(i * cellWidth, 0), Offset(i * cellWidth, size.height), paint);
    }
    for (int i = 1; i < gridRows; i++) {
      canvas.drawLine(Offset(0, i * cellHeight), Offset(size.width, i * cellHeight), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) {
    return oldDelegate.gridColumns != gridColumns ||
        oldDelegate.gridRows != gridRows ||
        oldDelegate.cellWidth != cellWidth ||
        oldDelegate.cellHeight != cellHeight;
  }
}
