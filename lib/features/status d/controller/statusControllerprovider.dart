import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../Model/statusModel.dart';
import '../../../enum/statusenum.dart';
import '../../auth/controller/AuthController.dart';
import '../class/statusClassProvider.dart';
final statusControllerProvider = Provider((ref) {
  final statusClass = ref.read(statusClassProvider);
  return StatusController(
    statusClass: statusClass,
    ref: ref,
  );
});

class StatusController {
  final StatusClass statusClass;
  final ProviderRef ref;

  StatusController({
    required this.statusClass,
    required this.ref,
  });

  void uploadStatus({
    required File statusImage,
    required BuildContext context,
    required String type,
    String text='',
    required int x
  }) {

    try {
      ref.watch(userLogindataProvider).whenData((logindata) {
        print("controller =${statusImage}");
        statusClass.uploadStatus(
          username: logindata!.name.toString(),
          profilePic: logindata.photoUrl.toString(),
          phoneNumber: logindata.phoneNumber.toString(),
          statusImage: statusImage,
          context: context,
          text: text,
          type: type,
          x:x,
        );
      });

    } catch (e) {
      print("Error =  ${e.toString()}");


    }

  }

  Future<List<StatusModel>> getStatus(BuildContext context) async {
    List<StatusModel> statuses = await statusClass.getStatus(context);
    return statuses;
  }
}