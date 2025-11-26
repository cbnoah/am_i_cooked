import 'package:flutter/material.dart';

class RecipeContainer extends StatelessWidget {
  final String path;
  final bool isBookmarked;
  final bool showBookmarkIcon;

  const RecipeContainer({super.key, required this.path, required this.isBookmarked, required this.showBookmarkIcon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: NetworkImage(path), fit: BoxFit.cover),
          borderRadius: BorderRadius.all(Radius.circular(30))
        ),
        width: 300,
        height: 200,
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
                  color: Color(0xFFF2F2F2),
                ),
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Poulet roti", style: TextStyle(fontFamily: "bbh_sans_hegarty", fontSize: 22, overflow: TextOverflow.ellipsis),),
                      GestureDetector(
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            color: Color(0xffeaddff),
                          ),
                          child: Icon(Icons.bookmark_border, color: Color(0xFF4a4459),),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
