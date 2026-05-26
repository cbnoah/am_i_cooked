import 'package:flutter/material.dart';
import 'dart:typed_data';

class RecipeContainer extends StatefulWidget {
  final Uint8List? blobImage;
  final bool isBookmarked;
  final bool showBookmarkIcon;
  final String recipeTitle;
  final String recipePageLink;
  final VoidCallback? onBookmarkChanged;
  final String heroTag;
  final VoidCallback onTap;

  const RecipeContainer({
    super.key,
    required this.blobImage,
    required this.isBookmarked,
    required this.showBookmarkIcon,
    required this.recipeTitle,
    this.onBookmarkChanged,
    required this.heroTag,
    required this.recipePageLink,
    required this.onTap,
  });

  @override
  State<RecipeContainer> createState() => _RecipeContainerState();
}

class _RecipeContainerState extends State<RecipeContainer> {
  late bool _isBookmarked;
  final path = "assets/image/placeholder.png";

  @override
  void initState() {
    super.initState();
    _isBookmarked = widget.isBookmarked;
  }

  @override
  void didUpdateWidget(covariant RecipeContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isBookmarked != widget.isBookmarked) {
      _isBookmarked = widget.isBookmarked;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget? imageRender = widget.blobImage == null
        ? Image.asset(path, fit: BoxFit.cover, alignment: Alignment.center)
        : Image.memory(
            widget.blobImage!,
            fit: BoxFit.cover,
            alignment: Alignment.center,
          );
    return GestureDetector(
      onTap: widget.onTap,
      child: Hero(
        tag: widget.heroTag,
        flightShuttleBuilder:
            (
              BuildContext flightContext,
              Animation<double> animation,
              HeroFlightDirection flightDirection,
              BuildContext fromHeroContext,
              BuildContext toHeroContext,
            ) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: imageRender,
              );
            },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          clipBehavior: Clip.hardEdge,
          width: double.infinity,
          height: double.infinity,
          child: LayoutBuilder(
            builder: (context, outerConstraints) {
              final double availableHeight = outerConstraints.maxHeight;
              final double effectiveBarHeight = availableHeight <= 0
                  ? 0
                  : availableHeight.clamp(0.0, 45.0).toDouble();
              final bool hideBottomBar = effectiveBarHeight < 18;
              final double iconSize = (effectiveBarHeight - 6)
                  .clamp(16.0, 40.0)
                  .toDouble();
              final double titleFontSize = (effectiveBarHeight * 0.48)
                  .clamp(10.0, 22.0)
                  .toDouble();

              return Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(clipBehavior: Clip.hardEdge, child: imageRender),
                  if (!hideBottomBar)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: effectiveBarHeight,
                        width: double.infinity,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          color: Theme.of(
                            context,
                          ).colorScheme.secondaryContainer,
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final bool showBookmark =
                                widget.showBookmarkIcon &&
                                constraints.maxWidth > 150 &&
                                effectiveBarHeight >= 34;

                            return Padding(
                              padding: EdgeInsets.only(
                                left: 10.0,
                                right: showBookmark ? 4.0 : 10.0,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.recipeTitle,
                                      style: TextStyle(
                                        fontFamily: "bbh_sans_hegarty",
                                        fontSize: titleFontSize,
                                        height: 1.0,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                      maxLines: 1,
                                    ),
                                  ),
                                  if (showBookmark)
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isBookmarked = !_isBookmarked;
                                        });
                                        widget.onBookmarkChanged?.call();
                                      },
                                      child: Container(
                                        width: iconSize,
                                        height: iconSize,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          ),
                                          color: _isBookmarked
                                              ? const Color(0xFF4a4459)
                                              : const Color(0xffeaddff),
                                        ),
                                        child: Icon(
                                          _isBookmarked
                                              ? Icons.bookmark
                                              : Icons.bookmark_border,
                                          size: (iconSize * 0.55)
                                              .clamp(10.0, 24.0)
                                              .toDouble(),
                                          color: _isBookmarked
                                              ? const Color(0xffe8def8)
                                              : const Color(0xFF4a4459),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
