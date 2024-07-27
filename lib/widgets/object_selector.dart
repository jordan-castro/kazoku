import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kazoku/database/database.dart';
import 'package:kazoku/kazoku.dart';
import 'package:kazoku/widgets/texture_image_button.dart';

class ObjectSelectorWidget extends StatelessWidget {
  final int headerId;
  final Kazoku kazoku;

  const ObjectSelectorWidget({
    super.key,
    required this.headerId,
    required this.kazoku,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125.0,
      color: Colors.blue[700],
      child: FutureBuilder(
        future: DbHelper.instance.queryObjects(headerId),
        builder: (context, snapshot) {
          if (!snapshot.hasError && !snapshot.hasData) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError && !snapshot.hasData) {
            return const Text("An error occured");
          }

          return ListView(
            scrollDirection: Axis.horizontal,
            children: snapshot.data
                    ?.map(
                      (element) => Container(
                        margin: const EdgeInsets.all(10.0),
                        child: decideWidget(element),
                      ),
                    )
                    .toList() ??
                [],
          );
        },
      ),
    );
  }

  Widget decideWidget(Map<String, dynamic> element) {
    if (element.containsKey(DbHelper.ft_IdCol)) {
      return tileButton(element);
    } else {
      return objectTextureButton(element);
    }
  }

  Widget objectTextureButton(Map<String, dynamic> element) {
    return TextureImageButton(
      assetSource: element[DbHelper.ao_Source],
      height: 75.0,
      width: 75.0,
      fit: BoxFit.fill,
      onPressed: () {},
    );
  }

  Widget tileButton(Map<String, dynamic> element) {
    return TileImageButton(
      source: element[DbHelper.ft_Source],
      height: 50.0,
      width: 50.0,
      coords: element[DbHelper.ft_Coords],
      fit: BoxFit.fill,
      onPressed: () {
        // kazoku.currentFloor.floor.tiles = [];
      },
    );
  }
}
