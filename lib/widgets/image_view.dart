import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';


// ! when using this screen remember to use Hero widget in the other screen
class ImageView extends StatelessWidget {
  final String imageURL;

  const ImageView({Key key, @required this.imageURL}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PhotoView(
      enableRotation: true,
      heroAttributes: PhotoViewHeroAttributes(tag: this.imageURL),
      loadFailedChild: Center(
        child: CircularProgressIndicator(),
      ),
      imageProvider: CachedNetworkImageProvider(
        this.imageURL,
      ),
    );
  }
}
