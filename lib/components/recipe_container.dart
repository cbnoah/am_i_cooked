import 'package:flutter/material.dart';

class RecipeContainer extends StatefulWidget {
  final String path;
  final bool isBookmarked;
  final bool showBookmarkIcon;
  final String recipeTitle;
  final String recipePageLink;
  final VoidCallback? onBookmarkChanged;
  final String heroTag;
  final VoidCallback onTap;

  const RecipeContainer({
    super.key,
    required this.path,
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
    return GestureDetector(
      onTap: widget.onTap,
      child: Hero(
        tag: widget.heroTag,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(widget.path),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          clipBehavior: Clip.hardEdge,
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 45,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    color: Theme.of(context).colorScheme.secondaryContainer,
                  ),
                  alignment: Alignment.bottomCenter,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final bool showBookmark =
                          widget.showBookmarkIcon && constraints.maxWidth > 150;

                      return Padding(
                        padding: EdgeInsets.only(
                          left: 15.0,
                          right: showBookmark ? 4.0 : 15.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  widget.recipeTitle,
                                  style: TextStyle(
                                    fontFamily: "bbh_sans_hegarty",
                                    fontSize: 22,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  maxLines: 1,
                                ),
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
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                    color: _isBookmarked
                                        ? Color(0xFF4a4459)
                                        : Color(0xffeaddff),
                                  ),
                                  child: Icon(
                                    _isBookmarked
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                    color: _isBookmarked
                                        ? Color(0xffe8def8)
                                        : Color(0xFF4a4459),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
