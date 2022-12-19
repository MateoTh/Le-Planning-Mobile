import 'package:flutter/material.dart';

class ProfileImageWidget extends StatelessWidget {
  final String imagePath;
  final VoidCallback onClicked;
  const ProfileImageWidget(
      {super.key, required this.imagePath, required this.onClicked});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Stack(
          children: [
            buildCircle(
              Colors.black,
              const EdgeInsets.all(2),
              buildCircle(
                Colors.white,
                const EdgeInsets.all(6),
                buildImage(),
              ),
            ),
            Positioned(bottom: 0, right: 4, child: buildEditIcon()),
          ],
        ),
      ),
    );
  }

  Widget buildImage() {
    final image = NetworkImage(imagePath);
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 125,
          height: 125,
          child: InkWell(
            onTap: onClicked,
          ),
        ),
      ),
    );
  }

  Widget buildEditIcon() {
    return buildCircle(
        Colors.black,
        const EdgeInsets.all(2),
        buildCircle(Colors.white, const EdgeInsets.all(5),
            const Icon(Icons.edit, size: 20)));
  }

  Widget buildCircle(Color? color, EdgeInsets padding, Widget child) {
    return ClipOval(
        child: Container(
      padding: padding,
      color: color,
      child: child,
    ));
  }
}
