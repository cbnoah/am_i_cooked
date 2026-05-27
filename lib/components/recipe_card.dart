import 'package:flutter/material.dart';

class Recipe {
  final String title;
  final String imageAssets;

  const Recipe({required this.title, required this.imageAssets});
}

class RecipeCard extends StatelessWidget {
  const RecipeCard({
    super.key,
    required this.title,
    required this.imageAssets,
    required this.onBookmark,
    required this.isBookmarked,
  });

  final String title;
  final String imageAssets;
  final VoidCallback onBookmark;
  final bool isBookmarked;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              imageAssets,
              fit: BoxFit.cover,
              alignment: const Alignment(0, -0.15),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 58,
                padding: const EdgeInsets.only(left: 18, right: 14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(22),
                    topRight: Radius.circular(22),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'bbh_sans_hegarty',
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: onBookmark,
                      child: Container(
                        width: 44,
                        height: 44,
                        margin: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          color: isBookmarked
                              ? const Color(0xFF6750A4)
                              : const Color(0xFFEADEFF),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                        ),
                        child: Icon(
                          isBookmarked
                              ? Icons.bookmark
                              : Icons.bookmark_border_outlined,
                          color: isBookmarked
                              ? const Color(0xFFF3EDFF)
                              : const Color(0xFF6750A4),
                          size: 32,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
