import 'package:flutter/material.dart';
import 'package:giphy_picker/giphy_picker.dart';
import 'package:whattsup/comman/utils.dart';

Future<GiphyGif?> pickGif(BuildContext context) async {
 GiphyGif? gif;
  try {
    gif = await GiphyPicker.pickGif(
      context: context,
      apiKey: '9MgjoVw0j4G2l1tgdWMnnQXxi17fyo90',
    );
  } catch (e) {
    showSnackBar(
      context: context,
      message: e.toString(),
    );
  }

  return gif;
}
