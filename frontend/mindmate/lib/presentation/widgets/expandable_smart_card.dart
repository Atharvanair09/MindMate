import 'package:flutter/material.dart';
import 'dart:ui';

class ExpandableSmartCardController extends ChangeNotifier {
  static final ExpandableSmartCardController instance =
      ExpandableSmartCardController();

  String? _currentlyExpandedId;

  String? get currentlyExpandedId => _currentlyExpandedId;

  void expand(String id) {
    _currentlyExpandedId = id;
    notifyListeners();
  }

  void collapseAll() {
    _currentlyExpandedId = null;
    notifyListeners();
  }
}

class ExpandableSmartCard extends StatefulWidget {
  final String id;
  final Widget collapsedChild;
  final Widget expandedChild;
  final Color backgroundColor;
  final Color? borderColor;
  final Color shadowColor;
  final double collapsedBorderRadius;
  final EdgeInsets padding;
  final EdgeInsets margin;

  const ExpandableSmartCard({
    Key? key,
    required this.id,
    required this.collapsedChild,
    required this.expandedChild,
    required this.backgroundColor,
    this.borderColor = Colors.black,
    this.shadowColor = Colors.black,
    this.collapsedBorderRadius = 0.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.margin = const EdgeInsets.all(0),
  }) : super(key: key);

  @override
  State<ExpandableSmartCard> createState() => _ExpandableSmartCardState();
}

class _ExpandableSmartCardState extends State<ExpandableSmartCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  OverlayEntry? _overlayEntry;
  final GlobalKey _key = GlobalKey();

  bool _isExpanded = false;
  Rect? _originalRect;
  ModalRoute? _route;

  void _onGlobalStateChanged() {
    if (_isExpanded &&
        ExpandableSmartCardController.instance.currentlyExpandedId !=
            widget.id) {
      _close();
    }
  }

  void _onRouteAnimation() {
    if (_isExpanded &&
        _route?.secondaryAnimation?.status == AnimationStatus.forward) {
      _closeImmediately();
    }
  }

  void _closeImmediately() {
    if (!_isExpanded) return;

    if (mounted) {
      setState(() {
        _isExpanded = false;
      });
    }

    if (ExpandableSmartCardController.instance.currentlyExpandedId ==
        widget.id) {
      ExpandableSmartCardController.instance.collapseAll();
    }

    _controller.value = 0.0;
    _removeOverlay();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    ExpandableSmartCardController.instance.addListener(_onGlobalStateChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _route?.secondaryAnimation?.removeListener(_onRouteAnimation);
    _route = ModalRoute.of(context);
    _route?.secondaryAnimation?.addListener(_onRouteAnimation);
  }

  @override
  void dispose() {
    _route?.secondaryAnimation?.removeListener(_onRouteAnimation);
    ExpandableSmartCardController.instance
        .removeListener(_onGlobalStateChanged);
    _controller.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _open() {
    if (_isExpanded) return;

    final RenderBox? renderBox =
        _key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    _originalRect = offset & size;

    setState(() {
      _isExpanded = true;
    });

    ExpandableSmartCardController.instance.expand(widget.id);

    _showOverlay();
    _controller.forward();
  }

  void _close() {
    if (!_isExpanded) return;

    setState(() {
      _isExpanded = false;
    });

    if (ExpandableSmartCardController.instance.currentlyExpandedId ==
        widget.id) {
      ExpandableSmartCardController.instance.collapseAll();
    }

    _controller.reverse().then((_) {
      if (!mounted) return;
      _removeOverlay();
    });
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return _ExpandableOverlayWidget(
          controller: _controller,
          originalRect: _originalRect!,
          padding: widget.padding,
          margin: widget.margin,
          collapsedChild: widget.collapsedChild,
          expandedChild: widget.expandedChild,
          backgroundColor: widget.backgroundColor,
          borderColor: widget.borderColor,
          shadowColor: widget.shadowColor,
          collapsedBorderRadius: widget.collapsedBorderRadius,
          onClose: _close,
        );
      },
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    // The collapsed state is built here. It acts as a placeholder when expanded.
    return GestureDetector(
      key: _key,
      onTap: _open,
      child: Opacity(
        opacity: _isExpanded ? 0.0 : 1.0,
        child: Container(
          margin: widget.margin,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(widget.collapsedBorderRadius),
            border: widget.borderColor != null
                ? Border.all(color: widget.borderColor!, width: 2)
                : null,
            boxShadow: [
              BoxShadow(
                color: widget.shadowColor,
                offset: const Offset(4, 4),
              ),
            ],
          ),
          child: widget.collapsedChild,
        ),
      ),
    );
  }
}

class _ExpandableOverlayWidget extends StatefulWidget {
  final AnimationController controller;
  final Rect originalRect;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Widget collapsedChild;
  final Widget expandedChild;
  final VoidCallback onClose;
  final Color backgroundColor;
  final Color? borderColor;
  final Color shadowColor;
  final double collapsedBorderRadius;

  const _ExpandableOverlayWidget({
    Key? key,
    required this.controller,
    required this.originalRect,
    required this.padding,
    required this.margin,
    required this.collapsedChild,
    required this.expandedChild,
    required this.onClose,
    required this.backgroundColor,
    this.borderColor,
    required this.shadowColor,
    required this.collapsedBorderRadius,
  }) : super(key: key);

  @override
  State<_ExpandableOverlayWidget> createState() =>
      _ExpandableOverlayWidgetState();
}

class _ExpandableOverlayWidgetState extends State<_ExpandableOverlayWidget> {
  final GlobalKey _expandedContentKey = GlobalKey();
  double? _targetExpandedHeight;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_expandedContentKey.currentContext != null) {
        final renderBox =
            _expandedContentKey.currentContext!.findRenderObject() as RenderBox;
        setState(() {
          _targetExpandedHeight = renderBox.size.height;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Animation Definitions
    final liftAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: widget.controller,
          curve: const Interval(0.0, 0.25, curve: Curves.easeOut)),
    );

    final widthAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: widget.controller,
          curve: const Interval(0.25, 0.60, curve: Curves.easeOutCubic)),
    );

    final heightAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: widget.controller,
          curve: const Interval(0.60, 0.85, curve: Curves.easeOutCubic)),
    );

    final contentFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: widget.controller,
          curve: const Interval(0.70, 1.0, curve: Curves.easeOut)),
    );

    final maxAvailableWidth = size.width - widget.padding.horizontal;

    final isLeft = widget.originalRect.left < size.width / 3;
    final isRight = widget.originalRect.right > (size.width * 2) / 3;

    return Stack(
      children: [
        // Background dimming and blur overlay
        GestureDetector(
          onTap: widget.onClose,
          child: AnimatedBuilder(
            animation: widget.controller,
            builder: (context, child) {
              final blurAmount = 8.0 * widget.controller.value;
              return ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
                  child: Container(
                    color: Colors.black.withOpacity(0.15 * widget.controller.value),
                  ),
                ),
              );
            },
          ),
        ),

        AnimatedBuilder(
          animation: widget.controller,
          builder: (context, child) {
            final currentWidth = widget.originalRect.width +
                (maxAvailableWidth - widget.originalRect.width) *
                    widthAnim.value;

            double left;
            if (isLeft) {
              left = widget.originalRect.left;
            } else if (isRight) {
              left = widget.originalRect.right - currentWidth;
            } else {
              final center = widget.originalRect.center.dx;
              left = center - currentWidth / 2;
            }

            final expandedHeight = _targetExpandedHeight ?? 0;
            final currentHeight = widget.originalRect.height +
                (expandedHeight * heightAnim.value);

            final scale = 1.0 + (0.02 * liftAnim.value);
            final shadowOffset =
                4.0 + (4.0 * liftAnim.value); // Increases shadow offset to 8

            final targetBorderRadius = (widget.collapsedBorderRadius - 4.0)
                .clamp(0.0, double.infinity);
            final borderRadius = widget.collapsedBorderRadius +
                ((targetBorderRadius - widget.collapsedBorderRadius) *
                    widthAnim.value);

            return Positioned(
              left: left,
              top: widget.originalRect.top - (10.0 * liftAnim.value),
              width: currentWidth,
              height: currentHeight,
              child: Transform.scale(
                scale: scale,
                alignment: isLeft
                    ? Alignment.centerLeft
                    : (isRight ? Alignment.centerRight : Alignment.center),
                child: Material(
                  type: MaterialType.transparency,
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.backgroundColor,
                      borderRadius: BorderRadius.circular(borderRadius),
                      border: widget.borderColor != null
                          ? Border.all(color: widget.borderColor!, width: 2)
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: widget.shadowColor,
                          offset: Offset(shadowOffset, shadowOffset),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(borderRadius),
                      child: Stack(
                        children: [
                          // Expanded content that fades in and slides up
                          if (_targetExpandedHeight != null)
                            Positioned(
                              top: widget.originalRect.height,
                              left: 0,
                              right: 0,
                              child: Opacity(
                                opacity: contentFadeAnim.value,
                                child: Transform.translate(
                                  offset: Offset(
                                      0, 15.0 * (1 - contentFadeAnim.value)),
                                  child: SizedBox(
                                    width: currentWidth,
                                    child: widget.expandedChild,
                                  ),
                                ),
                              ),
                            ),

                          // Hidden expanded content to measure intrinsic size
                          if (_targetExpandedHeight == null)
                            Positioned(
                              top: widget.originalRect.height,
                              left: 0,
                              child: Opacity(
                                opacity: 0.0,
                                child: Container(
                                  key: _expandedContentKey,
                                  width: maxAvailableWidth,
                                  // Hidden content should ignore pointer to prevent interaction
                                  child: IgnorePointer(child: widget.expandedChild),
                                ),
                              ),
                            ),

                          // Original collapsed content stays on top
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            height: widget.originalRect.height,
                            child: widget.collapsedChild,
                          ),

                          // Red close button (cross) at top right
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Opacity(
                              opacity: contentFadeAnim.value,
                              child: IgnorePointer(
                                ignoring: contentFadeAnim.value < 0.5,
                                child: GestureDetector(
                                  onTap: widget.onClose,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.black, width: 2),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black,
                                          offset: Offset(1.5, 1.5),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
