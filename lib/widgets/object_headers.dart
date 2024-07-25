import 'package:flutter/material.dart';
import 'package:kazoku/database/database.dart';
import 'package:kazoku/widgets/button.dart';

class ObjectHeadersWidget extends StatelessWidget {
  final int index;
  final Function(int id) onChange;

  const ObjectHeadersWidget({
    super.key,
    required this.index,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      color: Colors.blue,
      child: Center(
        child: FutureBuilder(
          future: DbHelper.instance.queryObjectHeaders(),
          builder: (context, snapshot) {
            if (!snapshot.hasError && !snapshot.hasData) {
              return const CircularProgressIndicator.adaptive(
                strokeWidth: 10.0,
              );
            } else if (snapshot.hasError && !snapshot.hasData) {
              return const Text("An error occured");
            }

            // Snapshot has data
            return Row(
              mainAxisSize: MainAxisSize.max,
              children: snapshot.data
                      ?.map(
                        (element) => Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                          ),
                          child: ButtonWidget(
                            borderRadius: 10.0,
                            textColor: (index + 1) == element[DbHelper.oh_IdCol]
                                ? Colors.black
                                : Colors.white,
                            onPressed: () {
                              onChange(element[DbHelper.oh_IdCol] - 1);
                            },
                            backgroundColor:
                                (index + 1) == element[DbHelper.oh_IdCol]
                                    ? Colors.white
                                    : Colors.blue[900]!,
                            text: element[DbHelper.oh_title],
                          ),
                        ),
                      )
                      .toList() ??
                  [],
            );
          },
        ),
      ),
    );
  }
}
